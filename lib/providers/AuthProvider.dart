import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wuzzufy_admin/models/Admin.dart';
import 'package:wuzzufy_admin/providers/BaseProvider.dart';
import 'package:wuzzufy_admin/utils/Config.dart';

class AuthProvider extends BaseProvider {
  bool isAuth = false;
  String loginId;
  String password;

  checkAuth() async {
    String token = await getAdminToken();
    if (token == null) {
      isAuth = false;
    } else {
      isAuth = true;
    }
  }

  logoutAndExist(context) async {
    await clearAdminToken();
    SystemNavigator.pop(animated: true);
  }

  unAuth() {
    // unAuth user
    isAuth = false;
    clearAdminToken();
    notifyListeners();
  }

  Future<void> loginWithUsername(context) async {
    try {
      Response response = await Dio().post(Config.LOGIN_URL,
          data: {"loginId": loginId, "password": password});

      print(response);
      if (response.data['success'] == true) {
        Admin admin = Admin.fromJson(response.data["data"]["admin"]);
        await setAdminToken(admin.token);
        isAuth = true;
      } else {
        catchError(context, response.data['error']);
      }
    } catch (err) {
      catchError(context, err);
    }
    notifyListeners();
  }
}
