import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gitshiwam/service/auth_service.dart';



class Endpoints {
  Endpoints._();

  // base url
  static const String apiBaseURL = "https://api.github.com";

  // receiveTimeout
  static const int receiveTimeout = 5000;

  // connectTimeout
  static const int connectionTimeout = 10000;

  static const String userInfo = '/users';
  static const String repos = '/repos';
  static const String pulls = '/pulls';
}

class API {
  static  request({
    bool loggedIn = true,
    String baseURL = Endpoints.apiBaseURL,
    bool applyBaseURL = true,
    bool loginRequired = true,
    bool debugLog = false,
    String? acceptHeader,
  })  {
    final dio = Dio();

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          if (applyBaseURL) {
            options.baseUrl = baseURL;
          }
          options.headers['Accept'] = acceptHeader ?? 'application/json';
          options.headers['setContentType'] = 'application/json';
          options.headers['User-Agent'] = 'com.example.gitshiwam';
          if (loggedIn == false) {
            if (loginRequired) {
              throw Exception('Not authenticated.');
            }
          } else {
            // Queue the request to add necessary headers before executing.
            dio.interceptors.requestLock.lock();
            try {
              AuthService.getAccessTokenFromDevice().then((token) async {
                // Throw error if request requires login and no token is found
                // on device.
                if (token == null && loginRequired) {
                  throw Exception('Not authenticated.');
                }
                // Add auth token to header.
                options.headers['Authorization'] = 'token $token';
              }).whenComplete(() {
                // Execute the request and return the necessary headers.
                dio.interceptors.requestLock.unlock();
              });
            } catch (error) {
              debugPrint(error.toString());
            }
          }
          handler.next(options);
        },
        onResponse: (response, handler) async {

          handler.next(response);
        },
        onError: (error, handler) async {

          // Todo: Add better exception handling based on response codes.

          handler.next(error);
        },
      ),
    );

    return dio;
  }
}