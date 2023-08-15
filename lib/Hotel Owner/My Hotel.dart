import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reserved_table/Constance/Styles.dart';
import 'package:reserved_table/Hotel%20Owner/TablesPage.dart';
import 'package:reserved_table/Hotel%20Owner/RequestCustomerPage.dart';
import 'package:reserved_table/Hotel%20Owner/TodayCustomerPage.dart';
import 'package:reserved_table/main.dart';

class HotelHomePage extends StatefulWidget {
  @override
  _HotelHomePageState createState() => _HotelHomePageState();
}
class _HotelHomePageState extends State<HotelHomePage> {
  final List<Widget> bodyContent = [
    HotelTablesPage(),
    TodayCustomerPage(),
    RequestCustomerPage(),
  ];


  @override
  void initState() {
    MyApp().controller.getLengths();
    super.initState();
    print(MyApp().controller.userRequestLength.value);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => Center(
          child: bodyContent.elementAt(MyApp().controller.selectedIndexOwner),
        ),
      ),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "My Hotel",
            ),
            BottomNavigationBarItem(
              icon: MyApp().controller.customerLength.value == 0 ? Icon(Icons.supervisor_account_sharp) : Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Icon(Icons.supervisor_account_sharp),
                  ),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: CircleAvatar(
                      radius: 11,
                      backgroundColor: Colors.red,
                      child: Obx(() => Text(
                            MyApp().controller.customerLength.value.toString(),
                            style: size13White,
                          ),
                      ),
                    ),
                  )
                ],
              ),
              label: "Customers",
            ),
            BottomNavigationBarItem(
              icon: MyApp().controller.userRequestLength.value == 0  ? Icon(Icons.person_add_alt) : Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Icon(Icons.person_add_alt),
                  ),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: CircleAvatar(
                      radius: 11,
                      backgroundColor: Colors.red,
                      child: Obx(() => Text(
                        MyApp().controller.userRequestLength.value.toString(),
                        style: size13White,
                      ),
                      ),
                    ),
                  )
                ],
              ),
              label: "Requests",
            ),
          ],
          currentIndex: MyApp().controller.selectedIndexOwner,
          onTap: (index) => MyApp().controller.selectedIndexOwner = index,
        ),
      ),
    );
  }
}
