import 'dart:math';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:reserved_table/Constance/Colors.dart';
import 'package:reserved_table/Constance/Strings.dart';
import 'package:reserved_table/Constance/Styles.dart';
import 'package:reserved_table/User/ReservationPage.dart';
import 'package:reserved_table/User/FamilyReservationPage.dart';
import 'package:reserved_table/User/RattingPage.dart';
import 'package:reserved_table/Widgets/CommonMenuPage.dart';
import 'package:reserved_table/Widgets/Widgets.dart';
import 'package:reserved_table/main.dart';
import 'package:intl/intl.dart';

class ShowSearchHotelTablesPage extends StatefulWidget {
  final int index;

  ShowSearchHotelTablesPage({this.index});

  @override
  _ShowSearchHotelTablesPageState createState() =>
      _ShowSearchHotelTablesPageState();
}

class _ShowSearchHotelTablesPageState extends State<ShowSearchHotelTablesPage> {
  String code = "";
  double height = 170.0;

  @override
  Widget build(BuildContext context) {
    String holiday = MyApp().controller.list[widget.index]["HotelHolidayDate"];
    String holidayReason =
        MyApp().controller.list[widget.index]["HotelHolidayReason"];
    CollectionReference hotelTables = FirebaseFirestore.instance
        .collection("Users")
        .doc(MyApp().controller.list[widget.index]["Key"])
        .collection("Tables");
    CollectionReference menuReference = FirebaseFirestore.instance
        .collection("Users")
        .doc(MyApp().controller.list[widget.index]["Key"])
        .collection("Menu");
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).padding.top,
            ),
            Container(
              height: MediaQuery.of(context).size.height -
                  MediaQuery.of(context).padding.top,
              child: Column(
                children: [
                  Expanded(
                    flex: 400,
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(7.0),
                      ),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          ClipRRect(
                              borderRadius: BorderRadius.circular(7.0),
                              child: CustomNetworkImage(
                                image: MyApp().controller.list[widget.index]
                                    ["HotelImage"],
                              )),
                          ClipRRect(
                              borderRadius: BorderRadius.circular(7.0),
                              child: Container(
                                color: blackWithOpacity5,
                              )),
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 15),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(flex: 100, child: Container()),
                                Expanded(
                                  flex: 45,
                                  child: Container(
                                    width: 85,
                                    margin: EdgeInsets.symmetric(vertical: 3),
                                    decoration: BoxDecoration(
                                        color: Colors.black,
                                        borderRadius:
                                            BorderRadius.circular(5.0)),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5, horizontal: 10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.star,
                                            size: 22,
                                            color: Colors.amber,
                                          ),
                                          SizedBox(width: 5),
                                          Text(
                                            MyApp()
                                                    .controller
                                                    .list[widget.index]
                                                ["HotelRatting"],
                                            style: size20AmberW500,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                    flex: 45,
                                    child: Text(
                                      MyApp().controller.list[widget.index]
                                          ["HotelName"],
                                      style: size30W500,
                                    )),
                                Expanded(
                                    flex: 35,
                                    child: text20(MyApp()
                                        .controller
                                        .list[widget.index]["HotelAddress"])),
                              ],
                            ),
                          ),
                          Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                functionList(
                                    'Give Ratting To The Hotel',
                                    Icons.star,
                                    () => Get.to(() => HotelRattingPage(
                                        keyHotel: MyApp()
                                            .controller
                                            .list[widget.index]["Key"])),
                                    220),
                                functionList(
                                    'Mack Family Request',
                                    Icons.family_restroom,
                                    () => mackFamilyRequest(),
                                    197),
                                functionList(
                                    '${customFormat.format(selectedDate)}',
                                    Icons.date_range,
                                    () => showPicker(context),
                                    138),
                                functionList(
                                    'Menu',
                                    Icons.menu_book,
                                    () => Get.to(() => CommonMenuPage(
                                        menuReference: menuReference,
                                        keyHotelForUserSide: MyApp()
                                            .controller
                                            .list[widget.index]["Key"])),
                                    100),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1000,
                    child: holiday == '${customFormat.format(selectedDate)}'
                        ? Container(
                            width: double.infinity,
                            child: Center(
                              child: Text(
                                holidayReason,
                                style: size30W500Grey,
                              ),
                            ),
                          )
                        : StreamBuilder<QuerySnapshot>(
                            stream: hotelTables.snapshots(),
                            builder: (BuildContext context,
                                AsyncSnapshot<QuerySnapshot> snapshot) {
                              if (snapshot.hasError)
                                return Text("Error : ${snapshot.error}");
                              switch (snapshot.connectionState) {
                                case ConnectionState.waiting:
                                  return Container(
                                      child: Center(
                                          child: customCircularProcess()));
                                default:
                                  return Container(
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 2),
                                    child: ClipRRect(
                                      borderRadius: borderRadius(7.0,7.0,0.0,0.0),
                                      child: ListView.builder(
                                        itemCount: snapshot.data.docs.length,
                                        itemBuilder: (_, int index) {
                                          var tableNo = snapshot.data.docs[index]
                                              ["TableNumber"];
                                          var tableCapacity =
                                              snapshot.data.docs[index]["Person"];
                                          var key =
                                              snapshot.data.docs[index]["Key"];
                                          var keyHotel = MyApp()
                                              .controller
                                              .list[widget.index]["Key"];
                                          List splitText = tableCapacity.split(" ");
                                          return Container(
                                            height: height,
                                            margin: EdgeInsets.symmetric(vertical: 2),
                                            decoration: BoxDecoration(
                                                color: Color(0xFF424242),
                                                borderRadius:
                                                    BorderRadius.circular(7.0)),
                                            child: Stack(
                                              children: [
                                                Container(
                                                  child: Row(
                                                    children: [
                                                      Expanded(
                                                        flex: 10,
                                                        child: ClipRRect(
                                                          borderRadius:
                                                              borderRadius(
                                                                  7.0, 0, 0, 7.0),
                                                          child: Image.asset(
                                                              tableCapacity ==
                                                                      "2  Person"
                                                                  ? person2Image
                                                                  : tableCapacity ==
                                                                          "4  Person"
                                                                      ? person4Image
                                                                      : tableCapacity ==
                                                                              "6  Person"
                                                                          ? person6Image
                                                                          : person8Image,
                                                              fit: BoxFit.cover),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        flex: 16,
                                                        child: Container(
                                                            child: ShowTableCustomerData(
                                                                keyTable: key,
                                                                keyHotel: keyHotel,
                                                                date:
                                                                    "${customFormat.format(selectedDate)}")),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  decoration: BoxDecoration(
                                                      color: Colors.black54,
                                                      borderRadius: borderRadius(
                                                          7.0, 0, 7.0, 0)),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(4.0),
                                                    child: Text(
                                                      tableNo,
                                                      style: size20Amber,
                                                    ),
                                                  ),
                                                ),
                                                Positioned(
                                                  bottom: 0,
                                                  right: 0,
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      code = getRandomString(20);
                                                      setState(() {});
                                                      Get.to(() => ReservationPage(
                                                          index: widget.index,
                                                          listLength: int.parse(
                                                              splitText[0]),
                                                          tableKey: key,
                                                          tableNumber: tableNo,
                                                          date:
                                                              '${customFormat.format(selectedDate)}',
                                                          code: code));
                                                    },
                                                    child: Container(
                                                      margin: EdgeInsets.all(5.0),
                                                      decoration: BoxDecoration(
                                                        color: Colors.black54,
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                7.0),
                                                      ),
                                                      child: Padding(
                                                        padding: const EdgeInsets
                                                                .symmetric(
                                                            horizontal: 10,
                                                            vertical: 6),
                                                        child: Center(
                                                          child: Text(
                                                            "Reserve",
                                                            style: size18,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  );
                              }
                            },
                          ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container functionList(
      String title, IconData icon, Function fun, double width) {
    return Container(
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(7.0),
        border: Border.all(color: buttonBorderTablePage),
        color: black,
      ),
      child: GestureDetector(
        onTap: fun,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 13),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title),
              Icon(
                icon,
                size: 20,
              )
            ],
          ),
        ),
      ),
    );
  }

  DateTime selectedDate = DateTime.now();
  var customFormat = DateFormat('dd/MM/yyyy');

  Future<Null> showPicker(BuildContext context) async {
    final DateTime picked = await globalDatePicker(context);
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  void mackFamilyRequest() {
    code = getRandomString(20);
    setState(() {});

    Get.to(() => FamilyReservationPage(
        index: widget.index,
        date: '${customFormat.format(selectedDate)}',
        code: code));
  }

  var _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  Random _rnd = Random();

  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
}
