// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Category _$CategoryFromJson(Map<String, dynamic> json) {
  return Category(
    id: json['id'] as int,
    name: json['name'] as String,
    desc: json['desc'] as String,
    createdAt: json['createdAt'] as String,
    updatedAt: json['updatedAt'] as String,
  );
}

Map<String, dynamic> _$CategoryToJson(Category instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'desc': instance.desc,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
    };
