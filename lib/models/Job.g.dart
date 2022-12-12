// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Job.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Job _$JobFromJson(Map<String, dynamic> json) {
  return Job(
    id: json['id'] as int,
    title: json['title'] as String,
    desc: json['desc'] as String,
    url: json['url'] as String,
    category_id: json['category_id'] as int,
    provider_id: json['provider_id'] as int,
    provider: json['provider'] == null
        ? null
        : Provider.fromJson(json['provider'] as Map<String, dynamic>),
    category: json['category'] == null
        ? null
        : Category.fromJson(json['category'] as Map<String, dynamic>),
    added_admin: json['added_admin'] == null
        ? null
        : User.fromJson(json['added_admin'] as Map<String, dynamic>),
    createdAt: json['createdAt'] as String,
    updatedAt: json['updatedAt'] as String,
  );
}

Map<String, dynamic> _$JobToJson(Job instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'desc': instance.desc,
      'url': instance.url,
      'category_id': instance.category_id,
      'provider_id': instance.provider_id,
      'provider': instance.provider?.toJson(),
      'category': instance.category?.toJson(),
      'added_admin': instance.added_admin?.toJson(),
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
    };
