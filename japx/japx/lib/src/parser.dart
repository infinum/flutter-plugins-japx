import 'package:flutter/foundation.dart';

class TypeIdPair {
  TypeIdPair({@required this.type, @required this.id});

  final String type;
  final String id;

  static TypeIdPair from(Map<String, dynamic> json) {
    if (json == null || json['type'] == null || json['id'] == null) {
      return null;
    }
    return TypeIdPair(type: json['type'], id: json['id']);
  }

  @override
  int get hashCode => type.hashCode ^ id.hashCode;

  @override
  bool operator ==(other) => other is TypeIdPair && type == other.type && id == other.id;

  @override
  String toString() => '[$type: $id]';

  Map<String, dynamic> toMap() => {'type': type, 'id': id};
}

Map<String, dynamic> japxEncode(Object json, {Map<String, dynamic> additionalParams}) {
  final params = additionalParams ?? {};
  if (json is List) {
    final list = json.map((e) => e as Map<String, dynamic>).map((e) => encodeAttributesAndRelationships(e)).toList();
    params['data'] = list;
  }
  if (json is Map<String, dynamic>) {
    params['data'] = encodeAttributesAndRelationships(json);
  }
  return params;
}

Map<String, dynamic> japxDecode(Map<String, dynamic> jsonApi) {
  final dataObjectsArray = array(jsonApi, 'data');
  final includedObjectsArray = array(jsonApi, 'included');

  final dataObjects = List<TypeIdPair>();
  final objects = Map<TypeIdPair, Map<String, dynamic>>();

  for (Map<String, dynamic> map in dataObjectsArray) {
    final typeId = TypeIdPair.from(map);
    dataObjects.add(typeId);
    objects[typeId] = map;
  }

  for (Map<String, dynamic> map in includedObjectsArray) {
    final typeId = TypeIdPair.from(map);
    objects[typeId] = map;
  }

  resolveAttributes(objects);
  resolveRelationships(objects);

  final isObject = jsonApi['data'] is List ? false : true;
  if (isObject && dataObjects.length == 1) {
    jsonApi['data'] = objects[dataObjects.first];
  } else {
    jsonApi['data'] = dataObjects.map((e) => objects[e]).toList();
  }
  jsonApi.remove('included');
  return jsonApi;
}

Map<String, dynamic> encodeAttributesAndRelationships(Map<String, dynamic> json) {
  final attributes = Map<String, dynamic>();
  final relationships = Map<String, dynamic>();
  final keys = json.keys.toList();

  for (String key in keys) {
    if (key == 'id' || key == 'type') {
      continue;
    }
    if (json[key] is List) {
      final array = (json[key] as List).map((e) => e as Map<String, dynamic>).toList();
      final isArrayOfRelationships = TypeIdPair.from(array.first) != null;
      if (!isArrayOfRelationships) {
        attributes[key] = array;
        json.remove(key);
        continue;
      }
      final dataArray = array.map((e) => TypeIdPair.from(e)).map((e) => e.toMap()).toList();
      relationships[key] = {'data': dataArray};
      json.remove(key);
    }
    if (json[key] is Map<String, dynamic>) {
      final map = json[key] as Map<String, dynamic>;
      final typeIdPair = TypeIdPair.from(map);
      if (typeIdPair == null) {
        attributes[key] = map;
        json.remove(key);
        continue;
      }
      relationships[key] = {'data': typeIdPair.toMap()};
      json.remove(key);
    }
    attributes[key] = json[key];
    json.remove(key);
  }
  json['attributes'] = attributes;
  json['relationships'] = relationships;
  return json;
}

void resolveAttributes(Map<TypeIdPair, Map<String, dynamic>> objects) {
  for (Map<String, dynamic> object in objects.values) {
    final attributes = object['attributes'] as Map<String, dynamic>;
    for (String key in attributes.keys) {
      object[key] = attributes[key];
    }
    object.remove('attributes');
  }
}

void resolveRelationships(Map<TypeIdPair, Map<String, dynamic>> objects) {
  objects.values.forEach((object) {
    final relationships = object['relationships'] as Map<String, dynamic>;
    object.remove('relationships');
    relationships?.forEach((key, value) {
      if (!(value is Map<String, dynamic>)) {
        throw 'Relationship not found';
      }
      final relationshipParams = value as Map<String, dynamic>;

      final others = array(relationshipParams, 'data');

      // Fetch those object from `objects`
      final othersObjects = others.map((e) => TypeIdPair.from(e)).map((e) => objects[e]).toList();

      final isObject = relationshipParams['data'] is List ? false : true;

      if (others.length == 1 && isObject) {
        object[key] = othersObjects.first;
      } else {
        object[key] = othersObjects;
      }
    });
  });
}

List<Map<String, dynamic>> array(Map<String, dynamic> json, String key) {
  if (json[key] is List) {
    final list = json[key] as List;
    return list.map((e) => e as Map<String, dynamic>).toList();
  } else {
    return [json[key] as Map<String, dynamic>];
  }
}
