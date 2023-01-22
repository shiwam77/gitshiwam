import 'package:flutter/material.dart';
import 'package:gitshiwam/models/pull_request_model.dart';
import 'package:gitshiwam/models/repository_model.dart';
import 'package:gitshiwam/models/user_info_model.dart';
import 'package:gitshiwam/service/pulls_service.dart';
import 'package:gitshiwam/statemanagement/view_model.dart';

class HomeMvvm extends ViewModel {


  late Future repoList;
  UserInfoModel? userInfo;
  List<RepositoryModel>? _getRepo;
  List<RepositoryModel>? get getRepo => _getRepo;
  List<PullRequestModel>? _getPr;
  List<PullRequestModel>? get getPr => _getPr;
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    repoList =  getRepositories();
  }
  Future<List<RepositoryModel>?> getRepositories() async {
    try{
      _getRepo =  await PullsService.getRepo(userInfo?.login,);
      return _getRepo;
    }
    catch(error){
      return Future.error(error);
    }

  }
  setTabIndex(int index){
    currentIndex = index;
    notifyListeners();
  }

  Future<List<PullRequestModel>?> getRepoPr({Map<String,String>? queryParameters}) async {
    try{
      _getPr = [];
      for(var repo in _getRepo!)  {
        var pr = await PullsService.getRepoPr(userInfo?.login, repo.name,queryParameters : {"state": "closed"});
        print(_getPr?.length);
        _getPr?.addAll(pr);
      }

      return _getPr;
    }
    catch(error){
      return Future.error(error);
    }

  }

}