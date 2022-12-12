import 'dart:async';
import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:wuzzufy_admin/providers/BaseProvider.dart';


class UtilsProvider extends BaseProvider {
  bool isLoaded = false;
  bool noInternet = false;

  UtilsProvider(context) {
    if(Platform.isAndroid){
      init(context);
      addInternetListener();
    }else{
      noInternet = false;
      isLoaded = true;
      notifyListeners();
    }
  }

  init(context) async {
    noInternet = !await checkInternet();
    isLoaded = true;
    notifyListeners();
  }


  addInternetListener() {
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      if (result == ConnectivityResult.none) {
        noInternet = true;
        EasyLoading.showError('لا يوجد انترنت');
      } else {
        noInternet = false;
      }

      notifyListeners();
    });
  }
}
