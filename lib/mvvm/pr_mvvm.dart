import 'package:gitshiwam/models/pull_request_model.dart';
import 'package:gitshiwam/models/user_info_model.dart';
import 'package:gitshiwam/service/pulls_service.dart';
import 'package:gitshiwam/statemanagement/view_model.dart';

class PrMvvm extends ViewModel {


  late Future prList;
  UserInfoModel? userInfo;
  String? repoName;
  List<PullRequestModel>? _getPr;
  List<PullRequestModel>? get getPr => _getPr;
  bool? stateOpen = false;

  @override
  void initState() {
    super.initState();
  }
  setStateCheckBox(bool? isOpen){
    stateOpen = isOpen;
    _getPr?.clear();
    _getPr = null;
    notifyListeners();
  }

  Future<List<PullRequestModel>?> getRepoPr() async {
    try{
      _getPr =  await PullsService.getRepoPr(userInfo?.login, repoName,queryParameters : {"state": stateOpen == false ? "open": "closed"});
      return _getPr;
    }
    catch(error){
      return Future.error(error);
    }

  }


}