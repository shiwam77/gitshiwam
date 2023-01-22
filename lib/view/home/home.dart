import 'package:flutter/material.dart';
import 'package:gitshiwam/app/global.dart';
import 'package:gitshiwam/models/repository_model.dart';
import 'package:gitshiwam/models/user_info_model.dart';
import 'package:gitshiwam/mvvm/home_mvvm.dart';
import 'package:gitshiwam/service/auth_service.dart';
import 'package:gitshiwam/statemanagement/mvvm_builder.widget.dart';
import 'package:gitshiwam/statemanagement/views/stateless.view.dart';
import 'package:gitshiwam/view/home/pr_list.dart';
import 'package:gitshiwam/widget/loading_indicator.dart';
import 'package:gitshiwam/widget/tab/tab_bar.dart';


class HomeView extends StatelessWidget {
  final UserInfoModel? userInfo;
  const HomeView({Key? key, this.userInfo,}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return MVVM<HomeMvvm>(
      view: (context, vmodel) => const Home(),
      viewModel: HomeMvvm()
        ..userInfo= userInfo
    );
  }
}

class Home extends  StatelessView<HomeMvvm>  {
  const Home({Key? key}) : super(key: key);


  @override
  Widget render(BuildContext context, HomeMvvm vm) {
   return  const UserDetails();
  }
}

class UserDetails extends StatelessView<HomeMvvm> {
  const UserDetails({Key? key,}) : super(key: key);


  @override
  Widget render(BuildContext context, HomeMvvm vm) {

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 50),
            UserProfile(userInfo: vm.userInfo),
            FollowersDetails(userInfo: vm.userInfo),
            const SizedBox(height: 20),
            const SizedBox(height: 10),
            const TabFutureBuilder()

          ],
        ),
      ),
      floatingActionButton: InkWell(
        onTap: (){
          clearSharedPref();
          AuthService.logOut();
         Navigator.pushReplacementNamed(context, '/');
        },
        child: Container(
          height: 80,
          width: 80,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.blue
          ),
          child: const Text("Log out",style: TextStyle(color: Colors.white),),
        ),
      ),
    );
  }


}

class TabWidgetBuilder extends StatefulWidget {
  final HomeMvvm vm;
  const TabWidgetBuilder({Key? key,required this.vm}) : super(key: key);

  @override
  State<TabWidgetBuilder> createState() => _TabWidgetBuilderState();
}

class _TabWidgetBuilderState extends State<TabWidgetBuilder> with TickerProviderStateMixin {
  late TabController tabController ;

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return  Column(
      children: [
        TabBarWidget(
            tabNameOne: "Repositories",
            tabNameSecond: "Pr",
            onTap: ((value) {
              widget.vm.setTabIndex(value);
            }),
            width: 300,
            currentIndex: widget.vm.currentIndex,
            tabController: tabController),
            const SizedBox(height: 10,),
            TabBarViewWidget(
                tabController: tabController,
                children:  const [
                  RepoItems(),
                  PrFutureBuilder(),
                ]),
      ],
    );
  }
}



class TabFutureBuilder extends StatelessView<HomeMvvm> {
  const TabFutureBuilder({Key? key}) : super(key: key);

  @override
  Widget render(BuildContext context, HomeMvvm vm) {
   return Expanded(
      child:Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: vm.getRepo == null ? FutureBuilder(
          future: vm.repoList,
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.error == null && !snapshot.hasError){
              if(vm.getRepo != null && vm.getRepo!.isNotEmpty ){
                return  TabWidgetBuilder(vm: vm,);
              }else{
                return const Center(child : Text("No Repositories"));
              }

            }else{

              return const LoadingIndicator();
            }
          },) : vm.getRepo!.isNotEmpty ?   TabWidgetBuilder(vm: vm,) :   const Center(child : Text("No Repositories")),
      ),
    );
  }
}

class PrFutureBuilder extends StatelessView<HomeMvvm> {
  const PrFutureBuilder({Key? key}) : super(key: key);

  @override
  Widget render(BuildContext context, HomeMvvm vm) {
    return  Padding(
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
    );
  }
}


class UserProfile extends StatelessWidget {
  final UserInfoModel? userInfo;

  const UserProfile({
    Key? key,
    this.userInfo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      isThreeLine: true,
      leading: CircleAvatar(
        backgroundImage: NetworkImage(userInfo?.avatarUrl as String),
      ),
      title: Text(
        userInfo?.login ?? '',
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        userInfo?.bio ?? '',
        style: TextStyle(color: Colors.black),
      ),
    );
  }
}


class FollowersDetails extends StatelessWidget {
  final UserInfoModel? userInfo;
  const FollowersDetails({Key? key,required this.userInfo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Icon(
            Icons.person,
            color: Colors.black,
          ),
          const SizedBox(width: 10),
          Text(
            '${userInfo?.followers} followers',
            style: TextStyle(color: Colors.black),
          ),
          const SizedBox(width: 20),
          Text(
            '${userInfo?.following} following',
            style: TextStyle(color: Colors.black),
          )
        ],
      ),
    );
  }
}

class RepoItems extends StatelessView<HomeMvvm> {
  const RepoItems({Key? key}) : super(key: key);


  @override
  Widget render(BuildContext context, HomeMvvm vm) {
    return  ListView.separated(
        itemBuilder: (context,index){
          return InkWell(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>  PrListView(repoName: vm.getRepo![index].name,userInfo: vm.userInfo,)));
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
                      "${vm.getRepo![index].name}",
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
                          "${formattedDate(vm.getRepo![index].createdAt)}",
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
                          "${formattedDate(vm.getRepo![index].updatedAt)}",
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
                          "Language:",
                          maxLines: 2,
                          softWrap: true,
                          overflow: TextOverflow.clip,
                          style: TextStyle(fontWeight: FontWeight.normal
                              ,fontSize: 12,
                              color:Colors.indigo),),
                        SizedBox(width: 8,),

                        Text(
                          "${vm.getRepo![index].language}",
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
        itemCount: vm.getRepo!.length);
  }
}


