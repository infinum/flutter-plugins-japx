import 'dart:convert';

class _TypeIdPair {
  _TypeIdPair({required this.type, required this.id});

  final String type;
  final String id;

  static _TypeIdPair? from(Map<String, dynamic>? json) {
    if (json == null || json[_type] == null || json[_id] == null) {
      return null;
    }
    return _TypeIdPair(type: json[_type], id: json[_id]);
  }

  static _TypeIdPair fromOrThrow(Map<String, dynamic> json) {
    final pair = _TypeIdPair.from(json);
    if (pair == null) {
      throw 'Unable to find type id from: $json';
    }
    return pair;
  }

  @override
  int get hashCode => type.hashCode ^ id.hashCode;

  @override
  bool operator ==(other) => other is _TypeIdPair && type == other.type && id == other.id;

  @override
  String toString() => '[$type: $id]';

  Map<String, dynamic> toMap() => {_type: type, _id: id};
}

final String _type = 'type';
final String _id = 'id';
final String _data = 'data';
final String _included = 'included';
final String _attributes = 'attributes';
final String _relationships = 'relationships';

class Japx {
  /// Converts simple flat JSON object to JSON:API object.
  ///
  /// - parameter json:              JSON object as Data.
  /// - parameter additionalParams:  Additional Map<String: dynamic> to add with `data` to JSON:API object.
  ///
  /// - returns: JSON:API object.
  static Map<String, dynamic> encode(Object json, {Map<String, dynamic>? additionalParams}) {
    final params = additionalParams ?? {};
    if (json is List) {
      final list = json.map((e) => e as Map<String, dynamic>).map((e) => _encodeAttributesAndRelationships(e)).toList();
      params[_data] = list;
    }
    if (json is Map<String, dynamic>) {
      params[_data] = _encodeAttributesAndRelationships(json);
    }
    return params;
  }

  /// Converts JSON:API object to simple flat JSON object
  ///
  /// - parameter jsonApi:            JSON:API object.
  /// - parameter includeList:       The include list for deserializing JSON:API relationships.
  ///
  /// - returns: JSON object.
  static Map<String, dynamic> decode(Map<String, dynamic> jsonApi, {String? includeList}) {
    return (includeList != null) ? _japxDecodeList(jsonApi, includeList) : _decode(jsonApi);
  }

  static Map<String, dynamic> _japxDecodeList(Map<String, dynamic> jsonApi, String includeList) {
    final params = includeList.split(',').map((e) => e.split('.').toList()).toList();

    final paramsMap = Map<String, dynamic>();
    for (var lineArray in params) {
      Map<String, dynamic> map = paramsMap;
      for (var param in lineArray) {
        if (map[param] != null) {
          map = map[param];
        } else {
          final newMap = Map<String, dynamic>();
          map[param] = newMap;
          map = newMap;
        }
      }
    }

    final dataObjectsArray = _arrayOrThrow(jsonApi, _data);
    final includedObjectsArray = _array(jsonApi, _included) ?? [];
    final allObjectsArray = dataObjectsArray + includedObjectsArray;
    final allObjects = allObjectsArray.fold(Map<_TypeIdPair, Map<String, dynamic>>(), (dynamic map, element) {
      map[_TypeIdPair.from(element)] = element;
      return map;
    });

    final objects = dataObjectsArray.map((e) => _resolve(e, allObjects, paramsMap)).toList();

    final isObject = jsonApi[_data] is List ? false : true;
    if (isObject && objects.length == 1) {
      jsonApi[_data] = objects.first;
    } else {
      jsonApi[_data] = objects;
    }
    jsonApi.remove(_included);
    return jsonApi;
  }

  static _resolve(
      Map<String, dynamic> object, Map<_TypeIdPair, Map<String, dynamic>> allObjects, Map<String, dynamic> paramsMap) {
    final attributes = (object[_attributes] ?? Map<String, dynamic>()) as Map<String, dynamic>;
    attributes[_type] = object[_type];
    attributes[_id] = object[_id];

    final relationshipsReferences = (object[_relationships] ?? Map<String, dynamic>()) as Map<String, dynamic>;

    final relationships = paramsMap.keys.fold(Map<String, dynamic>(), (Map<String, dynamic> result, relationshipsKey) {
      if (relationshipsReferences[relationshipsKey] == null) {
        return result;
      }
      final relationship = relationshipsReferences[relationshipsKey] as Map<String, dynamic>;

      final otherObjectsData = _array(relationship, _data);
      if (otherObjectsData == null) {
        return result;
      }

      final otherObjects = otherObjectsData
          .map((e) => _TypeIdPair.fromOrThrow(e))
          .map((e) => allObjects[e])
          .where((e) => e != null)
          .map((e) {
        final objectCopy = jsonDecode(jsonEncode(e));
        return _resolve(
            objectCopy, allObjects, (paramsMap[relationshipsKey] ?? Map<String, dynamic>()) as Map<String, dynamic>);
      }).toList();

      final isObject = relationship[_data] is List ? false : true;

      if (isObject) {
        if (otherObjects.length == 1) {
          result[relationshipsKey] = otherObjects.first;
        }
      } else {
        result[relationshipsKey] = otherObjects;
      }

      return result;
    });

    attributes.addAll(relationships);
    return attributes;
  }

  static Map<String, dynamic> _decode(Map<String, dynamic> jsonApi) {
    final dataObjectsArray = _arrayOrThrow(jsonApi, _data);
    final includedObjectsArray = _array(jsonApi, _included) ?? [];

    final dataObjects = <_TypeIdPair>[];
    final objects = Map<_TypeIdPair, Map<String, dynamic>>();

    for (Map<String, dynamic> map in dataObjectsArray) {
      final typeId = _TypeIdPair.fromOrThrow(map);
      dataObjects.add(typeId);
      objects[typeId] = map;
    }

    for (Map<String, dynamic> map in includedObjectsArray) {
      final typeId = _TypeIdPair.fromOrThrow(map);
      objects[typeId] = map;
    }

    _resolveAttributes(objects);
    _resolveRelationships(objects);

    final isObject = jsonApi[_data] is List ? false : true;
    if (isObject && dataObjects.length == 1) {
      jsonApi[_data] = objects[dataObjects.first];
    } else {
      jsonApi[_data] = dataObjects.map((e) => objects[e]).toList();
    }
    jsonApi.remove(_included);
    return jsonApi;
  }

  static Map<String, dynamic> _encodeAttributesAndRelationships(Map<String, dynamic> json) {
    final attributes = Map<String, dynamic>();
    final relationships = Map<String, dynamic>();
    final keys = json.keys.toList();

    for (String key in keys) {
      if (key == _id || key == _type) {
        continue;
      }
      if (json[key] is List) {
        final array = json[key] as List;
        final isArrayOfRelationships = array.first is Map<String, dynamic> && _TypeIdPair.from(array.first) != null;
        if (!isArrayOfRelationships) {
          attributes[key] = array;
          json.remove(key);
          continue;
        }
        final dataArray = array.map((e) => _TypeIdPair.fromOrThrow(e)).map((e) => e.toMap()).toList();
        relationships[key] = {_data: dataArray};
        json.remove(key);
      }
      if (json[key] is Map<String, dynamic>) {
        final map = json[key] as Map<String, dynamic>?;
        final typeIdPair = _TypeIdPair.from(map);
        if (typeIdPair == null) {
          attributes[key] = map;
          json.remove(key);
          continue;
        }
        relationships[key] = {_data: typeIdPair.toMap()};
        json.remove(key);
      }
      if (json[key] == null) {
        continue;
      }
      attributes[key] = json[key];
      json.remove(key);
    }
    json[_attributes] = attributes;
    json[_relationships] = relationships;
    return json;
  }

  static void _resolveAttributes(Map<_TypeIdPair, Map<String, dynamic>?> objects) {
    for (Map<String, dynamic>? object in objects.values) {
      if (object == null) {
        continue;
      }
      if (object[_attributes] != null) {
        final attributes = object[_attributes] as Map<String, dynamic>;
        for (String key in attributes.keys) {
          object[key] = attributes[key];
        }
        object.remove(_attributes);
      }
    }
  }

  static void _resolveRelationships(Map<_TypeIdPair, Map<String, dynamic>?> objects) {
    objects.values.forEach((object) {
      if (object == null) {
        return;
      }
      final relationships = object[_relationships] as Map<String, dynamic>?;
      object.remove(_relationships);
      relationships?.forEach((key, value) {
        if (!(value is Map<String, dynamic>)) {
          throw 'Relationship not found';
        }
        final relationshipParams = value;

        final others = _array(relationshipParams, _data);
        if (others == null) {
          object[key] = null;
          return;
        }

        // Fetch those object from `objects`
        final othersObjects = others.map((e) => _TypeIdPair.fromOrThrow(e)).map((e) => objects[e]).toList();

        final isObject = relationshipParams[_data] is List ? false : true;

        if (others.length == 1 && isObject) {
          object[key] = othersObjects.first;
        } else {
          object[key] = othersObjects;
        }
      });
    });
  }

  static List<Map<String, dynamic>>? _array(Map<String, dynamic> json, String key) {
    dynamic value = json[key];
    if (value == null) {
      return null;
    }
    if (value is List) {
      final list = json[key] as List;
      return list.map((e) => e as Map<String, dynamic>).toList();
    } else {
      return [value as Map<String, dynamic>];
    }
  }

  static List<Map<String, dynamic>> _arrayOrThrow(Map<String, dynamic> json, String key) {
    final array = _array(json, key);
    if (array == null) {
      throw 'Unable to find array for key: $key from: $json';
    }
    return array;
  }
}
