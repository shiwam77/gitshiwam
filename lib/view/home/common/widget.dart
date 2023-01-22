import 'package:flutter/material.dart';
import 'package:gitshiwam/app/global.dart';
import 'package:gitshiwam/models/user_info_model.dart';
import 'package:url_launcher/url_launcher.dart';


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

class PrItems extends StatelessWidget {
  final  vm;
  const PrItems({Key? key,this.vm}) : super(key: key);

  ListView itemContainer(vm) {
    return ListView.separated(

        itemBuilder: (context,index){
          return InkWell(
            onTap: (){
              launchUrl(Uri.parse(vm.getPr![index].htmlUrl),mode: LaunchMode.externalApplication);
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
                          formattedDate(vm.getPr![index].createdAt),
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
