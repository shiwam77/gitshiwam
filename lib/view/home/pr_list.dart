import 'package:flutter/material.dart';
import 'package:gitshiwam/app/global.dart';
import 'package:gitshiwam/models/user_info_model.dart';
import 'package:gitshiwam/mvvm/pr_mvvm.dart';
import 'package:gitshiwam/statemanagement/mvvm_builder.widget.dart';
import 'package:gitshiwam/statemanagement/views/stateless.view.dart';
import 'package:gitshiwam/view/home/home.dart';
import 'package:gitshiwam/widget/loading_indicator.dart';


class PrListView extends StatelessWidget {
  final UserInfoModel? userInfo;
  final String? repoName;
  const PrListView({Key? key, this.userInfo, this.repoName,}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return MVVM<PrMvvm>(
      view: (context, vmodel) => const PrList(),
      viewModel: PrMvvm()
                ..userInfo= userInfo
                ..repoName = repoName,
    );
  }
}

class PrList extends StatelessView<PrMvvm> {
  const PrList({Key? key}) : super(key: key);

  @override
  Widget render(BuildContext context, PrMvvm vm) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 50),
          UserProfile(userInfo: vm.userInfo),
          FollowersDetails(userInfo: vm.userInfo),
          const SizedBox(height: 20),
           Padding(
            padding: EdgeInsets.only(left: 20),
            child:  Text(
              'List of Pull Request of ${vm.repoName}',
              style: const TextStyle(
                fontSize: 25,
                color: Colors.black,
              ),
            ),
          ),
          const SizedBox(height: 20),
           Padding(
            padding:const EdgeInsets.only(left: 20),
            child: Row(
              children: [
                const Text(
                  'State open',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                  ),
                ),
                Checkbox(value: vm.stateOpen,
                    onChanged: (value){
                      vm.setStateCheckBox(value);
                    }
                )
              ],
            ),
          ),
          const SizedBox(height: 20),


          Expanded(
            child:Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: vm.getPr == null ? FutureBuilder(
                future: vm.getRepoPr(),
                builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  if (snapshot.connectionState == ConnectionState.done &&
                      snapshot.error == null && !snapshot.hasError){
                    if(vm.getPr != null && vm.getPr!.isNotEmpty ){
                      return  PrItems(vm:vm);
                    }else{
                      return const Center(child : Text("No Closed Pull Request"));
                    }

                  }else{

                    return const LoadingIndicator();
                  }
                },) : vm.getPr!.isNotEmpty ?  const PrItems() :   const Center(child : Text("No Closed Pull Request")),
            ),
          ),

        ],
      ),
    );
  }
}

class PrItems extends StatelessWidget {
  final  vm;
  const PrItems({Key? key,this.vm}) : super(key: key);

  ListView itemContainer(vm) {
    return ListView.separated(

      itemBuilder: (context,index){
        return InkWell(
          onTap: (){
          },
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: const [
                  Icon(Icons.offline_bolt_rounded,),
                ],
              ),
              const SizedBox(width: 10,),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${vm.getPr![index].title}",
                    style: const TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 18),),
                  const SizedBox(height: 5,),
                  Row(
                    children: [
                      const Text(
                        "CreatedAt",
                        maxLines: 2,
                        softWrap: true,
                        overflow: TextOverflow.clip,
                        style: TextStyle(fontWeight: FontWeight.normal
                            ,fontSize: 12,
                            color: Colors.grey ),),
                      SizedBox(width: 10,),
                      Container(
                        height: 5,
                        width: 5,
                        decoration: const BoxDecoration(
                            color: Colors.indigo,
                            shape: BoxShape.circle
                        ),
                      ),
                      SizedBox(width: 5,),
                      Text(
                        "${formattedDate(vm.getPr![index].createdAt)}",
                        maxLines: 2,
                        softWrap: true,
                        overflow: TextOverflow.clip,
                        style:  const TextStyle(fontWeight: FontWeight.normal
                            ,fontSize: 12,
                            color:Colors.grey ),),
                    ],
                  ),
                  Row(
                    children: [
                      const Text(
                        "UpdatedAt",
                        maxLines: 2,
                        softWrap: true,
                        overflow: TextOverflow.clip,
                        style: TextStyle(fontWeight: FontWeight.normal
                            ,fontSize: 12,
                            color: Colors.grey ),),
                      SizedBox(width: 10,),
                      Container(
                        height: 5,
                        width: 5,
                        decoration: const BoxDecoration(
                            color: Colors.indigo,
                            shape: BoxShape.circle
                        ),
                      ),
                      SizedBox(width: 5,),
                      Text(
                        "${formattedDate(vm.getPr![index].updatedAt)}",
                        maxLines: 2,
                        softWrap: true,
                        overflow: TextOverflow.clip,
                        style:  const TextStyle(fontWeight: FontWeight.normal
                            ,fontSize: 12,
                            color:Colors.grey ),),
                    ],
                  ),
                  const SizedBox(height: 10,),
                  Row(
                    children:  [
                      const Text(
                        "state:",
                        maxLines: 2,
                        softWrap: true,
                        overflow: TextOverflow.clip,
                        style: TextStyle(fontWeight: FontWeight.normal
                            ,fontSize: 12,
                            color:Colors.indigo),),
                      SizedBox(width: 8,),

                      Text(
                        "${vm.getPr![index].state}",
                        overflow: TextOverflow.clip,
                        style: const TextStyle(fontWeight: FontWeight.normal
                            ,fontSize: 12,
                            color:Colors.grey ),),
                    ],
                  ),
                ],
              ),
            ],
          ),
        );
      },
      separatorBuilder:  (context,index){
        return Divider();
      },
      itemCount: vm.getPr?.length as int);
  }

  @override
  Widget build(BuildContext context) {
    return itemContainer(vm);
  }
}


