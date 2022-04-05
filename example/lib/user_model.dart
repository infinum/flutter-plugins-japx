import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

/// Using [JsonSerializable] to parse simple data object
/// After changing run:
///
/// flutter pub run build_runner build
///
/// to rebuild generated files needed for parsing to and from json
@JsonSerializable()
class User {
  User(this.email, this.name);
  factory User.fromMap(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toMap() => _$UserToJson(this);

  final String email;
  final String name;

  @override
  String toString() {
    return 'User email: $email and name: $name';
  }
}
