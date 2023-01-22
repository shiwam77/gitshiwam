
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';


final Logger _log = Logger();
Logger get log => _log;

late SharedPreferences _sharedPrefs;
SharedPreferences get sharedPrefs => _sharedPrefs;

final GlobalKey<NavigatorState> navigatorKey =
GlobalKey<NavigatorState>();
bool get isInDebugMode {
  // Assume you're in production mode.
  bool inDebugMode = false;

  // Assert expressions are only evaluated during development. They are ignored
  // in production. Therefore, this code only sets `inDebugMode` to true
  // in a development environment.
  assert(inDebugMode = true);

  return inDebugMode;
}

Future setUpSharedPrefs() async {
  _sharedPrefs = await SharedPreferences.getInstance();
  // Workaround for https://github.com/mogol/flutter_secure_storage/issues/210
  if (sharedPrefs.getBool('first_run') ?? true) {
    const storage = FlutterSecureStorage();
    await storage.deleteAll();
    sharedPrefs.setBool('first_run', false);
  }
}



Future<bool> storeStringSharedPref(String key, String value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return await prefs.setString(key, value);
}

Future<bool> storeStringListSharedPref(String key, List<String> value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return await prefs.setStringList(key, value);
}


Future<bool> storeIntegerSharedPref(String key, int value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return await prefs.setInt(key, value);
}

Future<bool> storeBooleanSharedPref(String key, bool value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return await prefs.setBool(key, value);
}


Future<bool> clearSharedPref() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.clear();
}


Future<String?> readStringSharedPref(String key) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString(key);
}

Future<List<String>?> readStringListSharedPref(String key) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getStringList(key);
}

Future<int?> readIntegerSharedPref(String key) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getInt(key);
}

Future<bool?> readBooleanSharedPref(String key) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getBool(key);
}

String formattedDate(DateTime? date){
  return DateFormat.yMMMMd().format(date!).toString();
}