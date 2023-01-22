import 'package:flutter/material.dart';

class TabBarWidget extends StatelessWidget {
  const TabBarWidget(
      {Key? key,
        this.width,
        this.onTap,
        this.currentIndex,
        required this.tabController,
        required this.tabNameOne,
        required this.tabNameSecond})
      : super(key: key);
  final String tabNameOne;
  final String tabNameSecond;
  final TabController tabController;
  final double? width;
  final void Function(int)? onTap;
  final int? currentIndex;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width:MediaQuery.of(context).size.width,
      child: TabBar(
        // labelColor: AppColors.primaryBlue[500],
        //unselectedLabelColor: AppColors.primaryBlue[100],
        labelStyle: const TextStyle(
            fontSize: 13,
            color: Colors.black,
            fontWeight: FontWeight.w500),
        unselectedLabelStyle: const TextStyle(
            fontSize: 13,
            color: Colors.black,
            fontWeight: FontWeight.w400),
        onTap: onTap,
        controller: tabController,
        indicatorPadding: const EdgeInsets.only(top: 20),
        tabs: [
          Tab(
            // text: tabNameOne,
            child: Text(tabNameOne,
                style: const TextStyle(
                  color:Colors.black,
                )),
          ),
          Tab(
            child: Text(
              tabNameSecond,
              style: const TextStyle(
                color: Colors.black,
              ),
            ),
          )
        ],
      ),
    );
  }
}


class TabBarViewWidget extends StatelessWidget {
  const TabBarViewWidget(
      {super.key, required this.tabController, required this.children});
  final TabController tabController;
  final List<Widget> children;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TabBarView(
        physics: const NeverScrollableScrollPhysics(),
        controller: tabController,
        children: children,
      ),
    );
  }
}