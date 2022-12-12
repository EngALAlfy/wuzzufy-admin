import 'package:json_annotation/json_annotation.dart';

part 'User.g.dart';

@JsonSerializable(explicitToJson: true)
class User {
  int id;
  String name;
  String username;
  String email;
  String photo;
  String token;
  String createdAt;
  String updatedAt;

  User(
      {this.id,
      this.name,
      this.username,
      this.email,
      this.photo,
      this.token,
      this.createdAt,
      this.updatedAt});

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
