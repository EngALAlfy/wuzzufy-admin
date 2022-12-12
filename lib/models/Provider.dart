import 'package:json_annotation/json_annotation.dart';
import 'package:wuzzufy_admin/utils/Errors.dart';

part 'Provider.g.dart';

@JsonSerializable(explicitToJson: true)
class Provider {
  int id;
  String name;
  String desc;
  String photo;
  String url;
  String createdAt;
  String updatedAt;

  @JsonKey(ignore: true)
  bool isAds = false;

  Provider({this.id, this.name,this.photo, this.desc, this.url, this.createdAt, this.updatedAt , this.isAds = false});

  factory Provider.fromJson(Map<String, dynamic> json) => _$ProviderFromJson(json);
  Map<String, dynamic> toJson() => _$ProviderToJson(this);

}