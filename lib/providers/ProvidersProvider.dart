import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wuzzufy_admin/models/Admin.dart';
import 'package:wuzzufy_admin/models/Provider.dart';
import 'package:wuzzufy_admin/models/User.dart';
import 'package:wuzzufy_admin/providers/BaseProvider.dart';
import 'package:wuzzufy_admin/utils/Config.dart';

class ProvidersProvider extends BaseProvider {
  List providers;
  Admin admin;

  int count = 0;

  int from = 0;

  String titleClassName;
  String descClassName;

  getAll(context) async {
    try {
      var token = await getAdminToken();
      Response response = await Dio()
          .get(Config.API_URL + "/providers/$from?admin_token=$token");
      if (response.data['success'] == true) {
        if (providers != null && providers.isNotEmpty && from != 0) {
          providers.addAll((response.data["data"]["providers"] as List)
              ?.map((e) => e == null
                  ? null
                  : Provider.fromJson(e as Map<String, dynamic>))
              ?.toList());
        } else {
          providers = (response.data["data"]["providers"] as List)
              ?.map((e) => e == null
                  ? null
                  : Provider.fromJson(e as Map<String, dynamic>))
              ?.toList();
        }

        admin = Admin.fromJson(response.data["data"]["admin"]);
        count = response.data["data"]["count"];
      } else {
        catchError(context, response.data["error"]);
      }
    } catch (err) {
      catchError(context, err);
    }
    notifyListeners();
  }

  void clear() {
    from = 0;
    count = 0;
    providers = null;
    admin = null;
    isError = false;
    error = null;
    notifyListeners();
  }

  Future<void> getProviderConfig(int id) async {
    titleClassName = "";
    descClassName = "";
    SharedPreferences prefs = await SharedPreferences.getInstance();
    titleClassName = (prefs.getString('$id-title-class') ?? "title");
    descClassName = (prefs.getString('$id-desc-class') ?? "desc");
    notifyListeners();
  }

  Future<void> setProviderTitleConfig(int id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('$id-title-class', titleClassName);
    notifyListeners();
  }

  Future<void> setProviderDescConfig(int id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('$id-desc-class', descClassName);
    notifyListeners();
  }
}
