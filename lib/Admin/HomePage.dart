import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reserved_table/Admin/AcceptedHotelPage.dart';
import 'package:reserved_table/Admin/PendingReqestPage.dart';
import 'package:reserved_table/Admin/ProfilePage.dart';
import 'package:reserved_table/Admin/RejectedHotelPage.dart';
import 'package:reserved_table/main.dart';

class AdminHomePage extends StatefulWidget {
  @override
  _AdminHomePageState createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {

  final List<Widget> bodyContent = [
    PendingRequestPage(),
    AcceptedHotelListPage(),
    RejectedHotelListPage(),
    ProfilePage()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => Center(
          child: bodyContent.elementAt(MyApp().controller.selectedIndexAdmin),
        ),
      ),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.pending_outlined),
              label: "Request",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.done),
              label: "Accepted",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.close),
              label: "Rejected",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline_sharp),
              label: "Profile",
            ),
          ],
          currentIndex: MyApp().controller.selectedIndexAdmin,
          onTap: (index) => MyApp().controller.selectedIndexAdmin = index,
        ),
      ),
    );
  }
}
