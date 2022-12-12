// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Admin.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Admin _$AdminFromJson(Map<String, dynamic> json) {
  return Admin(
    id: json['id'] as int,
    name: json['name'] as String,
    username: json['username'] as String,
    email: json['email'] as String,
    token: json['token'] as String,
    createdAt: json['createdAt'] as String,
    updatedAt: json['updatedAt'] as String,
  );
}

Map<String, dynamic> _$AdminToJson(Admin instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'username': instance.username,
      'email': instance.email,
      'token': instance.token,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
    };
