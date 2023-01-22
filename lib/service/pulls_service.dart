

import 'dart:developer';

import 'package:gitshiwam/models/pull_request_model.dart';
import 'package:gitshiwam/models/repository_model.dart';
import 'package:gitshiwam/network_layer/dio.dart';


class PullsService {


  // Ref: https://docs.github.com/en/rest/reference/pulls#list-pull-requests
  static Future<List<PullRequestModel>> getRepoPr(String? userName,String? repoName,{Map<String,String>? queryParameters}) async {
    final response = await API
        .request()
        .get('${Endpoints.repos}/$userName/$repoName/${Endpoints.pulls}',
        queryParameters: queryParameters);
  final List unParsedData = response.data;
  print(unParsedData);
    final parsedData =
        unParsedData.map((e) => PullRequestModel.fromJson(e)).toList();
    return parsedData;
  }

  static Future<List<RepositoryModel>> getRepo(String? userName) async {
    final response = await API
        .request()
        .get('${Endpoints.userInfo}/$userName/${Endpoints.repos}');
    final List unParsedData = response.data;
    final parsedData =
        unParsedData.map((e) => RepositoryModel.fromJson(e)).toList();
    return parsedData;
  }


}
