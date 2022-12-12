
import 'package:json_annotation/json_annotation.dart';

part 'Admin.g.dart';

@JsonSerializable(explicitToJson: true)

class Admin {
  int id;
  String name;
  String username;
  String email;
  String token;
  String createdAt;
  String updatedAt;

  Admin({this.id, this.name, this.username, this.email, this.token,
      this.createdAt, this.updatedAt});

  factory Admin.fromJson(Map<String, dynamic> json) => _$AdminFromJson(json);

  Map<String, dynamic> toJson() => _$AdminToJson(this);

}