import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:wuzzufy_admin/providers/AuthProvider.dart';
import 'package:wuzzufy_admin/providers/JobsProvider.dart';
import 'package:wuzzufy_admin/providers/ProvidersProvider.dart';
import 'package:wuzzufy_admin/providers/UsersProvider.dart';
import 'package:wuzzufy_admin/providers/UtilsProvider.dart';
import 'package:wuzzufy_admin/screens/HomeScreen.dart';
import 'package:wuzzufy_admin/screens/LoginScreen.dart';
import 'package:wuzzufy_admin/utils/Config.dart';
import 'package:wuzzufy_admin/widgets/IsLoadingWidget.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UtilsProvider(context)),
        ChangeNotifierProvider(create: (context) => UsersProvider()),
        ChangeNotifierProvider(create: (context) => JobsProvider()),
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => ProvidersProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate
        ],
        supportedLocales: [
          const Locale('ar', ''),
        ],
        theme: ThemeData(
          fontFamily: "cairo",
          //scaffoldBackgroundColor: Colors.white,
          primarySwatch: Config.PRIMARY_COLOR,
          accentColor: Config.ACCENT_COLOR,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        builder: EasyLoading.init(),
        home: Consumer2<AuthProvider , UtilsProvider>(
          builder: (context,auth ,utils, child) {
            // check auth every time app restarted
            auth.checkAuth();
            return getScreen(auth , utils, child);
          },
          child: IsLoadingWidget(),
        ),
      ),
    );
  }

  getScreen(AuthProvider auth , UtilsProvider utils, child) {
    if (utils.isLoaded) {
      if (utils.noInternet) {
        //EasyLoading.showError('لا يوجد انترنت\nيمكنك مشاهدة المحفوظات');
        //return SavedJobsScreen();
        //return NoInternetScreen();
      }
      if (auth.isAuth) {
        return HomeScreen();
      } else {
        return LoginScreen();
      }
    }

    return child;
  }
}
