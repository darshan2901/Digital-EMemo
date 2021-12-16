// ignore_for_file: file_names

import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:e_chalan/src/dashboard/history.dart';
import 'package:e_chalan/src/dashboard/homepage.dart';
import 'package:e_chalan/src/dashboard/profile.dart';
import 'package:e_chalan/src/providers/UserProvider.dart';
import 'package:e_chalan/src/theme/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);
  @override
  _DashboardState createState() => _DashboardState();
  static const routeName = '/dashboard';
}

class _DashboardState extends State<Dashboard> {
  int pageIndex = 0;
  List<Widget> pages = [
    const Homepage(),
    PreviousChalan(),
    const ProfilePage()
  ];
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(builder: (context, UserProvider, child) {
      return Scaffold(
        key: UserProvider.scaffoldKey,
        body: getBody(),
        bottomNavigationBar: getFooter(),
        // floatingActionButton: FloatingActionButton(
        //     onPressed: () {
        //       selectedTab(4);
        //     },
        //     child: Icon(
        //       Icons.add,
        //       size: 25,
        //     ),
        //     backgroundColor: primary
        //     //params
        //     ),
        // floatingActionButtonLocation:
        //     FloatingActionButtonLocation.centerDocked
      );
    });
  }

  Widget getBody() {
    return IndexedStack(
      index: pageIndex,
      children: pages,
    );
  }

  Widget getFooter() {
    List<IconData> iconItems = [
      Icons.dashboard_customize,
      Icons.history,
      Icons.person_outline
    ];

    return AnimatedBottomNavigationBar(
      activeColor: Theme.of(context).primaryColor,
      splashColor: secondary,
      inactiveColor: Colors.black.withOpacity(0.5),
      icons: iconItems,
      activeIndex: pageIndex,
      gapLocation: GapLocation.none,
      notchSmoothness: NotchSmoothness.smoothEdge,
      leftCornerRadius: 10,
      iconSize: 25,
      rightCornerRadius: 10,
      onTap: (index) {
        selectedTab(index);
      },
      //other params
    );
  }

  selectedTab(index) {
    setState(() {
      pageIndex = index;
    });
  }
}
