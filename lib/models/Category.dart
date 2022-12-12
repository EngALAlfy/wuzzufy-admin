import 'package:json_annotation/json_annotation.dart';

part 'Category.g.dart';

@JsonSerializable(explicitToJson: true)
class Category {
  int id;
  String name;
  String desc;
  String createdAt;
  String updatedAt;

  @JsonKey(ignore: true)
  bool isAds = false;

  Category({this.id, this.name, this.desc, this.createdAt, this.updatedAt , this.isAds = false});

  factory Category.fromJson(Map<String, dynamic> json) => _$CategoryFromJson(json);
  Map<String, dynamic> toJson() => _$CategoryToJson(this);

}