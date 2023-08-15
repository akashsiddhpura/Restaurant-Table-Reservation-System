import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:reserved_table/User/HistoryPage.dart';
import 'package:reserved_table/User/SearchHotelPage.dart';
import 'package:reserved_table/User/Today%20Booking.dart';
import 'package:reserved_table/User/UserProfilePage.dart';
import 'package:reserved_table/main.dart';
import 'package:reserved_table/Constance/Styles.dart';
import 'package:reserved_table/Widgets/Widgets.dart';

class UserHomePage extends StatefulWidget {
  @override
  _UserHomePageState createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage> {





  final List<Widget> bodyContent = [
    TodayBookings(),
    SearchHotelPage(),
    HistoryPage(),
    UserProfilePage(),
  ];

  Future<bool> _willPopCallback() {
    return customDialog(context,"Are you sure ?","Do you want to exit an app ?",()=>SystemNavigator.pop(),"Yes",size20Green)??
        false;
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _willPopCallback,
      child: Scaffold(
        body: Obx(
              () => Center(
            child: bodyContent.elementAt(MyApp().controller.selectedIndexUser),
          ),
        ),
        bottomNavigationBar: Obx(
              () => BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.bookmark_border_sharp),
                label: "Today Booking",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.search),
                label: "Search Hotel",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.history),
                label: "History",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: "Profile",
              ),
            ],
            currentIndex: MyApp().controller.selectedIndexUser,
            onTap: (index) => MyApp().controller.selectedIndexUser = index,
          ),
        ),
      ),
    );
  }
}
