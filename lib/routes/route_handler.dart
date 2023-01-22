

import 'package:flutter/material.dart';
import 'package:gitshiwam/models/user_info_model.dart';
import 'package:gitshiwam/view/authentication/auth_screen.dart';
import 'package:gitshiwam/view/home/home.dart';




class RouteGenerator{
  static Route<dynamic> generateRoute(RouteSettings settings){

    String? path = settings.name;
    print(path);

    if(path == null){
      _errorRoute(settings);
    }

    // extract path parameters

    switch(path){

      case '/':
        return MaterialPageRoute(
            settings: settings,
            builder: (BuildContext context){
              return const AuthScreen();
            }
        );
      case 'Home':
        UserInfoModel? userInfoModel = settings.arguments as UserInfoModel?;
        return MaterialPageRoute(
            settings: settings,
            builder: (BuildContext context){
              return HomeView(userInfo: userInfoModel,);
            }
        );


      default:
      // if there is no such named route, return error route
        return _errorRoute(settings);
    }

  }

  static Route<dynamic> _errorRoute(RouteSettings settings){

    return MaterialPageRoute(
        builder: (_){
          return const ErrorPage();
        }
    );
  }
}

class ErrorPage extends StatelessWidget {
  const ErrorPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(),
    );
  }
}
