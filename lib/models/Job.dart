import 'package:json_annotation/json_annotation.dart';
import 'package:wuzzufy_admin/models/Category.dart';
import 'package:wuzzufy_admin/models/Provider.dart';
import 'package:wuzzufy_admin/models/User.dart';

part 'Job.g.dart';

@JsonSerializable(explicitToJson: true)
class Job {
  int id;
  String title;
  String desc;
  String url;
  int category_id;
  int provider_id;
  Provider provider;
  Category category;
  User added_admin;
  String createdAt;
  String updatedAt;

  @JsonKey(ignore: true)
  bool isAds = false;

  Job({this.id, this.title, this.desc, this.url, this.category_id,
      this.provider_id, this.provider , this.category , this.added_admin , this.createdAt, this.updatedAt , this.isAds = false});

  factory Job.fromJson(Map<String, dynamic> json) => _$JobFromJson(json);
  Map<String, dynamic> toJson() => _$JobToJson(this);

}