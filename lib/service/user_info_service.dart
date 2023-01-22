

import 'package:gitshiwam/models/repository_model.dart';
import 'package:gitshiwam/models/user_info_model.dart';
import 'package:gitshiwam/network_layer/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';


class UserInfoService {
  // Ref: https://docs.github.com/en/rest/reference/users#get-the-authenticated-user
  static Future<UserInfoModel> getCurrentUserInfo() async {
    final response = await API
        .request()
        .get(
          '/user',
        );
    return UserInfoModel.fromJson(response.data);
  }

  // Ref: https://docs.github.com/en/rest/reference/repos#list-repositories-for-the-authenticated-user
  static Future<List<RepositoryModel>> getCurrentUserRepos(
    int perPage,
    int pageNumber, {
    required bool refresh,
    String? sort,
    bool? ascending = false,
  }) async {
    final response = await API
        .request()
        .get('/user/repos', queryParameters: {
      if (sort != null) 'sort': sort,
      if (ascending != null) 'direction': ascending ? 'asc' : 'desc',
      'per_page': perPage,
      'type': 'owner',
      'page': pageNumber
    });
    final List unParsedData = response.data;
    return unParsedData.map((e) => RepositoryModel.fromJson(e)).toList();
  }

  static Future<List<RepositoryModel>> getUserRepos(
    String? username,
    int perPage,
    int pageNumber,
    String? sort, {
    required bool refresh,
  }) async {
    final response = await API
        .request()
        .get(
      '/users/$username/repos',
      queryParameters: {
        'sort': 'updated',
        'per_page': perPage,
        'page': pageNumber,
        if (sort != null) 'sort': sort,
      },
    );
    final List unParsedData = response.data;
    final data = unParsedData.map((e) => RepositoryModel.fromJson(e)).toList();
    return data;
  }

  static Future<UserInfoModel> getUserInfo(String? login) async {
    final response =
        await API.request().get(
              '/users/$login',
            );
    return UserInfoModel.fromJson(response.data);
  }
}
