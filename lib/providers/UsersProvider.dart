import 'package:dio/dio.dart';
import 'package:wuzzufy_admin/providers/BaseProvider.dart';
import 'package:wuzzufy_admin/utils/Config.dart';

class UsersProvider extends BaseProvider{
  var statistics;

  getStatistics(context) async {
    try {
      var token = await getAdminToken();
      Response response = await Dio()
          .get(Config.API_URL + "/statistics/app-users?admin_token=$token");
      if (response.data['success'] == true) {
        statistics = response.data["data"]["statistics"];
      } else {
        catchError(context, response.data["error"]);
      }
    } catch (err) {
      catchError(context, err);
    }
    notifyListeners();
  }

}