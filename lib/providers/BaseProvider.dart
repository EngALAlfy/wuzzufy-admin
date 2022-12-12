import 'dart:collection';

import 'package:connectivity/connectivity.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:wuzzufy_admin/providers/AuthProvider.dart';
import 'package:wuzzufy_admin/providers/UtilsProvider.dart';
import 'package:wuzzufy_admin/screens/HomeScreen.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wuzzufy_admin/screens/LoginScreen.dart';
import 'package:wuzzufy_admin/utils/Errors.dart';

class BaseProvider extends ChangeNotifier {
  String error;
  bool isError = false;

  catchError(context, err) async {
    isError = true;
    EasyLoading.showError("حدث خطأ ما !");
    if (err is DioError) {
      switch (err.type) {
        case DioErrorType.connectTimeout:
        case DioErrorType.sendTimeout:
        case DioErrorType.receiveTimeout:
          error = "انتهي وقت الطلب";
          break;
        case DioErrorType.response:
          error = err.response == null
              ? "غير قادر علي الوصول للسيرفر"
              : " خطأ في السيرفر \n كود الحالة : ${err.response.statusCode} ";
          break;
        case DioErrorType.cancel:
          error = "تم الغاء الطلب";
          break;
        case DioErrorType.other:
        default:
          error = "غير قادر علي الاتصال بالسيرفر";
          break;
      }
    } else {
      if (err is LinkedHashMap<String, dynamic>) {
        error = handleServerError(err , context);
      }
      error = "خطا غير معروف بالسيرفر";
    }

    if (await checkShowErrors()) {
      Alert(
              context: context,
              title: "خطأ مفصل",
              desc: err.toString(),
              type: AlertType.error)
          .show();
    }

    print(err);
  }

  Future<bool> checkInternet() async {
    return await Connectivity().checkConnectivity() != ConnectivityResult.none;
  }

  Future<bool> setPermissions() async {
    return Permission.storage.request().isGranted;
  }

  Future<bool> checkPermissions() async {
    var storagePermission = await Permission.storage.request();

    if (storagePermission.isDenied) {
      EasyLoading.showError("لا يمكن تشغيل التطبيق بدون منح الاذونات");
      return false;
    } else {
      return true;
    }
  }

  Future<bool> checkShowErrors() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getBool("showErrors") ?? false;
  }

  Future<bool> setShowErrors(show) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.setBool("showErrors", show);
  }

  Future<String> getAdminToken() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString("token");
  }

  Future<bool> setAdminToken(token) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.setString("token", token);
  }

  Future<bool> clearAdminToken() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.remove("token");
  }

  goToHome(context) {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (BuildContext context) => HomeScreen()),
        (route) => false);
  }

  goToLogin(context) {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (BuildContext context) => LoginScreen()),
        (route) => false);
  }

  handleServerError(LinkedHashMap<String, dynamic> err , context) {
    if (err.containsKey("code")) {
      switch (err["code"]) {
        case Errors.not_auth:
          {
            AuthProvider authProvider =
            Provider.of<AuthProvider>(context, listen: false);
            if (authProvider.isAuth) {
              // not auth user
              EasyLoading.showInfo("تحتاج لتسجيل الدخول");
              authProvider.unAuth();
            } else {
              EasyLoading.showInfo("غير قادر علي تسجيل الدخول");
              return "غير قادر علي تسجيل الدخول";
            }
            break;
          }
        case Errors.wrong_password:
          {
            EasyLoading.showInfo("اسم المستخدم او كلمة السر خطأ");
            return "كلمة السر خطأ";
            break;
          }
        case Errors.user_exist:
          {
            EasyLoading.showInfo("البريد او اسم المستخدم موجود مسبقا");
            return "البريد او اسم المستخدم موجودين بالفعل";
            break;
          }
        case Errors.db_err:
          {
            EasyLoading.showInfo("خطأ في قواعد البيانات");
            return "خطأ في قواعد البيانات بالسيرفر";
            break;
          }
        case Errors.no_token:
          {
            EasyLoading.showInfo("لا يوجد رمز امان");
            return "لا يوجد رمز امان مقدم جرب تسجيل الدخول";
            break;
          }
        case Errors.not_allowed:
          {
            EasyLoading.showInfo("غير مسموح");
            return "غير مسموح بالدخول للصفحه";
            break;
          }
        case Errors.not_found:
          {
            EasyLoading.showInfo("غير موجود");
            return "صفحة غير موجودة";
            break;
          }
        case Errors.unknown_err:
          {
            EasyLoading.showInfo("خطأ غير معروف");
            return "خطأ غير معروف ربما يكون try&catch";
            break;
          }
        case Errors.job_exist:
          {
            EasyLoading.showInfo("الوظيفة موجودة بالفعل");
            return "الوظيفة موجوده بالفعل";
            break;
          }
      }
    }
    return "خطأ غير معروف الكود";
  }


}
