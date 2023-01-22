import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:gitshiwam/app/private_key.dart';
import 'package:gitshiwam/models/access_token_model.dart';
import 'package:gitshiwam/models/repository_model.dart';
import 'package:gitshiwam/models/user_info_model.dart';
import 'package:gitshiwam/service/auth_service.dart';
import 'package:gitshiwam/service/pulls_service.dart';
import 'package:gitshiwam/service/user_info_service.dart';
import 'package:gitshiwam/widget/button.dart';
import 'package:gitshiwam/widget/widget.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:gitshiwam/view/home/home.dart';
import 'package:shared_preferences/shared_preferences.dart';



class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool loading = false;
  @override
  Widget build(BuildContext context) {

    return ScaleExpandedSection(
      child: StringButton(
        title: 'Login with GitHub',
        listenToLoadingController: true,
        loading: loading,
        leadingIcon: const Icon(
          Octicons.mark_github,
        ),
        color: Colors.white,
        onTap: () async {
          UserInfoModel? userInfo;
          try {
            setState(() {
              loading = true;
            });
            await _browserAuth().then(( AccessTokenModel accessTokenModel) async {
               AuthService.storeAccessToken(accessTokenModel);
               userInfo = await UserInfoService.getCurrentUserInfo();
               SharedPreferences prefs = await SharedPreferences.getInstance();
              bool result =  await prefs.setString('user', jsonEncode(userInfo));
            });
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>  HomeView(userInfo: userInfo,)));

          } catch (e) {
            log(e.toString());
          } finally {
            setState(() {
              loading = false;
            });

          }
        },
      ),
    );
  }
}

Future<AccessTokenModel> _browserAuth() async {
  const appAuth = FlutterAppAuth();
  final result = await appAuth.authorizeAndExchangeCode(
    AuthorizationTokenRequest(
      PrivateKeys.clientID,
      'com.example.gitshiwam://login-callback',
      clientSecret: PrivateKeys.clientSecret,
      serviceConfiguration:  const AuthorizationServiceConfiguration(
          authorizationEndpoint: 'https://github.com/login/oauth/authorize',
          tokenEndpoint:'https://github.com/login/oauth/access_token',
      ),
      scopes: AuthService.scopes,
    ),
  );
  return AccessTokenModel(
      accessToken: result!.accessToken, scope: AuthService.scopeString);
}
