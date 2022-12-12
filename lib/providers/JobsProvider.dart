import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_select/smart_select.dart';
import 'package:wuzzufy_admin/models/Admin.dart';
import 'package:wuzzufy_admin/models/Job.dart';
import 'package:wuzzufy_admin/models/Provider.dart';
import 'package:wuzzufy_admin/providers/BaseProvider.dart';
import 'package:wuzzufy_admin/screens/JobContentScreen.dart';
import 'package:wuzzufy_admin/utils/Config.dart';

import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart' as html;

class JobsProvider extends BaseProvider {
  List jobs;
  Job job;

  Admin admin;

  int count = 0;

  int from = 0;

  String title;
  String desc;
  String url;

  int provider_id = 102;
  int category_id = 102;

  List<S2Choice<int>> providers = [];
  List<Provider> providersObj = [];
  List<S2Choice<int>> categories = [];

  getAll(context) async {
    try {
      var token = await getAdminToken();
      Response response =
          await Dio().get(Config.API_URL + "/jobs/$from?admin_token=$token");
      if (response.data['success'] == true) {
        if (jobs != null && jobs.isNotEmpty && from != 0) {
          jobs.addAll((response.data["data"]["jobs"] as List)
              ?.map((e) =>
                  e == null ? null : Job.fromJson(e as Map<String, dynamic>))
              ?.toList());
        } else {
          jobs = (response.data["data"]["jobs"] as List)
              ?.map((e) =>
                  e == null ? null : Job.fromJson(e as Map<String, dynamic>))
              ?.toList();
        }

        count = response.data["data"]["count"];
        admin = Admin.fromJson(response.data["data"]["admin"]);
      } else {
        print(response.data);
        catchError(context, response.data["error"]);
      }
    } catch (err) {
      catchError(context, err);
    }
    notifyListeners();
  }

  getProviders(context) async {
    try {
      var token = await getAdminToken();
      Response response =
          await Dio().get(Config.API_URL + "/providers?admin_token=$token");
      if (response.data['success'] == true) {
        providers = (response.data["data"]["providers"] as List)
            ?.map((e) => e == null
                ? null
                : S2Choice<int>(value: e["id"], title: e["name"]))
            ?.toList();

        providersObj = (response.data["data"]["providers"] as List)
            ?.map((e) => e == null ? null : Provider.fromJson(e))
            ?.toList();

        admin = Admin.fromJson(response.data["data"]["admin"]);
      } else {
        catchError(context, response.data["error"]);
      }
    } catch (err) {
      catchError(context, err);
    }
    notifyListeners();
  }

  getCategories(context) async {
    try {
      var token = await getAdminToken();
      Response response =
          await Dio().get(Config.API_URL + "/categories?admin_token=$token");
      if (response.data['success'] == true) {
        categories = (response.data["data"]["categories"] as List)
            ?.map((e) => e == null
                ? null
                : S2Choice<int>(value: e["id"], title: e["name"]))
            ?.toList();

        admin = Admin.fromJson(response.data["data"]["admin"]);
      } else {
        catchError(context, response.data["error"]);
      }
    } catch (err) {
      catchError(context, err);
    }
    notifyListeners();
  }

  get(context, id) async {
    try {
      var token = await getAdminToken();
      Response response =
          await Dio().get(Config.API_URL + "/jobs/job/$id?admin_token=$token");
      if (response.data['success'] == true) {
        job = Job.fromJson(response.data["data"]["job"]);
        admin = Admin.fromJson(response.data["data"]["admin"]);
      } else {
        catchError(context, response.data["error"]);
      }
    } catch (err) {
      catchError(context, err);
    }
    notifyListeners();
  }

  notify(context, id) async {
    try {
      var token = await getAdminToken();
      Response response = await Dio()
          .get(Config.API_URL + "/jobs/job/notify/$id?admin_token=$token");
      if (response.data['success'] == true) {
        EasyLoading.showInfo("تم ارسال الاشعار");
      } else {
        catchError(context, response.data["error"]);
      }
    } catch (err) {
      catchError(context, err);
    }
    notifyListeners();
  }

  void clear() {
    count = 0;
    from = 0;
    jobs = null;
    admin = null;
    isError = false;
    error = null;
    notifyListeners();
  }

  logoutAndLogin(BuildContext context) async {
    await clearAdminToken();
    goToLogin(context);
  }

  void clearJob() {
    job = null;
    admin = null;
    isError = false;
    error = null;
    notifyListeners();
  }

  Future<void> add(context) async {
    try {
      var token = await getAdminToken();
      Response response = await Dio()
          .post(Config.API_URL + "/jobs/add?admin_token=$token", data: {
        "title": title,
        "desc": desc,
        "url": url,
        "category_id": category_id,
        "provider_id": provider_id,
      });
      if (response.data['success'] == true) {
        EasyLoading.showSuccess("تم اضافة الوظيفة بنجاح");
        title = "";
        desc = "";
        url = "";
      } else {
        catchError(context, response.data["error"]);
      }
    } catch (err) {
      catchError(context, err);
    }
    notifyListeners();
  }

  Future<void> getJobContentFromUrl(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String titleClassName =
        (prefs.getString('$provider_id-title-class') ?? "title");
    String descClassName =
        (prefs.getString('$provider_id-desc-class') ?? "desc");

    Response response = await Dio().get(url);
    html.Document document = parse(response.data);

    // show site content test
    //showJobContentDialog(context , document);

    //var titles = document.querySelectorAll(/*titleClassName*/ ".offerheadinner .brkword");
    // format class name

    print(titleClassName);
    print(descClassName);

    // format classes with
    // .class1 .class2 .class3
    // .class1 h1

    var titles = getHtmlElementByClasses(titleClassName, document);
    var descs = getHtmlElementByClasses(descClassName, document);

    print(titles);
    print(descs);

    title = "";
    desc = "";

    for (html.Element el in titles) {
      if (title == null) title = "";
      title += el.text;
    }

    for (html.Element el in descs) {
      if (desc == null) desc = "";
      desc += el.text;
    }

    // trim
    title = title
        .trim()
        .replaceAll("\n", "")
        .replaceAll("</br>", "")
        .replaceAll("<br>", "");
    desc = desc.trim().replaceAll("</br>", "").replaceAll("<br>", "");

    if (EasyLoading.isShow) {
      EasyLoading.dismiss();
    }

    notifyListeners();
  }

  void update() {
    notifyListeners();
  }

  Future<void> telegram(BuildContext context, int id) async {
    try {
      var token = await getAdminToken();
      Response response = await Dio()
          .get(Config.API_URL + "/jobs/job/telegram/$id?admin_token=$token");
      if (response.data['success'] == true) {
        EasyLoading.showInfo("تم ارسال التليجرام");
      } else {
        catchError(context, response.data["error"]);
      }
    } catch (err) {
      catchError(context, err);
    }
    notifyListeners();
  }

  void showJobContentDialog(context, html.Document document) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => JobContentScreen(document: document),
        ));
  }

  List getHtmlElementByClasses(String className, html.Document document) {
    if (className.contains(".")) {
      var classes = className.split(".");

      var elements = [];
      var lastElement = document.body;

      for (String clazz in classes) {
        if (lastElement != null) {
          elements = lastElement.getElementsByClassName(clazz);
          lastElement = elements.elementAt(0);
        } else {
          continue;
        }
      }

      return elements;
    } else {
      return document.getElementsByClassName(className);
    }
  }

  void getProviderFromUrl() async {
    if (url != null && url.isNotEmpty) {
      var _url = url
          .replaceFirst("http://", "")
          .replaceFirst("https://", "")
          .replaceFirst("www.", "")
          .split("/")
          .first;

      print(_url);

      for (int i = 0; i < providersObj.length; i++) {
        var _providerUrl = providersObj.elementAt(i).url
            .replaceFirst("http://", "")
            .replaceFirst("https://", "")
            .replaceFirst("www.", "")
            .split("/")
            .first;


        if (_providerUrl == _url) {
          print(_providerUrl);
          provider_id = providersObj.elementAt(i).id;
          print(provider_id);
          notifyListeners();
        }
      }


    }
  }
}
