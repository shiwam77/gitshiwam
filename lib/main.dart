import 'dart:async';
import 'dart:convert';
import 'dart:isolate';
import 'package:flutter/material.dart';
import 'package:gitshiwam/models/user_info_model.dart';
import 'package:gitshiwam/routes/route_handler.dart';
import 'package:gitshiwam/service/auth_service.dart';
import 'package:gitshiwam/app/global.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  mainDelegate();
}

void mainDelegate() async {


  WidgetsFlutterBinding.ensureInitialized();
  FlutterError.onError = (FlutterErrorDetails details) async {
    if (isInDebugMode) {
      FlutterError.dumpErrorToConsole(details);
    } else {
      Zone.current.handleUncaughtError(details.exception, details.stack!);
    }
  };

  /// errors that happen outside of the Flutter context, install an error listener on the current Isolate
  Isolate.current.addErrorListener(RawReceivePort((pair) async {
    final List<dynamic> errorAndStacktrace = pair;
   ///Todo send error to firebase or sentry
  }).sendPort);

  UserInfoModel? userInfoModel = await getCurrentUserInfo();

  runZonedGuarded<Future<void>>(() async {
    runApp(MyApp(userInfoModel:userInfoModel));
  }, (error, stackTrace) {
    /// TOdo when we will add sentry then will send all the error to sentry from here
  });



}
Future<UserInfoModel?> getCurrentUserInfo() async{
  String? accessToken = await AuthService.getAccessTokenFromDevice();
  if(accessToken == null || accessToken == ""){
    return null;
  }
  SharedPreferences pref = await SharedPreferences.getInstance();
  Map<String,dynamic> json = jsonDecode(pref.getString('user') as String) as Map<String, dynamic>;
  print(json);
  return UserInfoModel.fromJson(json);
}


class MyApp extends StatelessWidget {
  final UserInfoModel? userInfoModel;
   const MyApp({Key? key,this.userInfoModel}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateRoute: RouteGenerator.generateRoute,
      initialRoute: userInfoModel == null ? '/' : 'Home',
      onGenerateInitialRoutes: (String initialRouteName) {
        return [
          RouteGenerator.generateRoute(
            RouteSettings(
              name: userInfoModel == null ? '/' : 'Home',
              arguments: userInfoModel,
            ),
          ),
        ];
      },
      navigatorKey: navigatorKey,
      supportedLocales: const [Locale('en')],
    );
  }
}
