// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Provider.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Provider _$ProviderFromJson(Map<String, dynamic> json) {
  return Provider(
    id: json['id'] as int,
    name: json['name'] as String,
    photo: json['photo'] as String,
    desc: json['desc'] as String,
    url: json['url'] as String,
    createdAt: json['createdAt'] as String,
    updatedAt: json['updatedAt'] as String,
  );
}

Map<String, dynamic> _$ProviderToJson(Provider instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'desc': instance.desc,
      'photo': instance.photo,
      'url': instance.url,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
    };
