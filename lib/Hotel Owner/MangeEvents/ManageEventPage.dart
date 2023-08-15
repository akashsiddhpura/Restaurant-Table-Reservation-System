import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reserved_table/Constance/Styles.dart';
import 'package:reserved_table/Hotel%20Owner/MangeEvents/CancelHolidayPage.dart';
import 'package:reserved_table/Hotel%20Owner/MangeEvents/HotelMenu/AddCategory.dart';
import 'package:reserved_table/Hotel%20Owner/MangeEvents/MackHolidayPage.dart';
import 'package:reserved_table/Hotel%20Owner/MangeEvents/NotArrivePage.dart';
import 'package:reserved_table/Widgets/Widgets.dart';

class EventManagesPage extends StatefulWidget {
  @override
  _EventManagesPageState createState() => _EventManagesPageState();
}

class _EventManagesPageState extends State<EventManagesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Manages Events",
            style: size25B,
          ),
          elevation: 0.0,
          backgroundColor: Color(0x00FFFFFF),
          centerTitle: true,
        ),
        body:Container(
            width:double.infinity,
            child:Column(
              children: [
                SizedBox(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    drawerItems("Mack Holiday", Icons.done_outline_sharp,
                            () => Get.to(() => HolidayPage())),
                  ],
                ),
                SizedBox(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    drawerItemsReverse("Cancel Holiday", Icons.cancel_outlined,
                            () => Get.to(() => HolidayCancelPage())),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    drawerItems("Add Menu", Icons.article_outlined,
                            () => Get.to(() => AddMenuHotelPage())),
                  ],
                ),
                SizedBox(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    drawerItemsReverse("Not Arrive", Icons.wrong_location_outlined,
                            () => Get.to(() => NotArriveCustomerPage())),
                  ],
                ),
              ],
            )
        )
    );
  }
}