import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:reserved_table/Constance/Colors.dart';
import 'package:reserved_table/Constance/Strings.dart';
import 'package:reserved_table/Constance/Styles.dart';
import 'package:reserved_table/Widgets/CommonMenuPage.dart';
import 'package:reserved_table/main.dart';
import 'package:intl/intl.dart';
import 'package:reserved_table/Widgets/Widgets.dart';

class HotelTablesPage extends StatefulWidget {
  @override
  _HotelTablesPageState createState() => _HotelTablesPageState();
}

class _HotelTablesPageState extends State<HotelTablesPage> {
  Timer timer;
  String timeString;
  String timeStringWithSplit;

  @override
  void initState() {
    super.initState();

    timer = Timer.periodic(
        Duration(seconds: 5), (Timer t) => getTimeAndRemoveCustomer());
  }

  @override
  void dispose() {
    // TODO: implement dispose
    timer.cancel();
    super.dispose();
  }

  CollectionReference collectionAcceptedReference = FirebaseFirestore.instance
      .collection("Users")
      .doc(MyApp().controller.userModel.key1)
      .collection("Tables");

  double height = 170.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          MyApp().controller.hotelModel.hotelName,
          style: size25,
        ),
        elevation: 0.0,
        backgroundColor: Color(0x00FFFFFF),
        centerTitle: true,
      ),
      drawer: customDrawer(context),
      body: Container(
        child: Column(
          children: [
            Expanded(
              flex: 5,
              child: Container(
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 300,
                      child: Center(
                        child: Text(
                          "Show By Date : ",
                          style: size25,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 200,
                      child: Container(
                        margin: EdgeInsets.only(right: 20),
                        child: GestureDetector(
                          onTap: () {
                            showPicker(context);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(7.0),
                              border: Border.all(color: buttonBorderAmber),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text('${customFormat.format(selectedDate)}'),
                                  Icon(Icons.arrow_drop_down_sharp),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 60,
              child: Container(
                child: MyApp().controller.hotelModel.hotelHolidayDate ==
                        '${customFormat.format(selectedDate)}'
                    ? Center(
                        child: Text(
                        MyApp().controller.hotelModel.hotelHolidayReason,
                        style: size30W500Grey,
                      ))
                    : StreamBuilder<QuerySnapshot>(
                        stream: collectionAcceptedReference.snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.hasError)
                            return Text("Error : ${snapshot.error}");
                          switch (snapshot.connectionState) {
                            case ConnectionState.waiting:
                              return Container(
                                  child:
                                      Center(child: customCircularProcess()));
                            default:
                              return ListView.builder(
                                itemCount: snapshot.data.docs.length,
                                itemBuilder: (_, int index) {
                                  var tableNo =
                                      snapshot.data.docs[index]["TableNumber"];
                                  var capacity =
                                      snapshot.data.docs[index]["Person"];
                                  var key = snapshot.data.docs[index]["Key"];
                                  var keyHotel =
                                      MyApp().controller.userModel.key1;
                                  return Container(
                                    height: height,
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 4, vertical: 2),
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
                                                  borderRadius: borderRadius(
                                                      7.0, 0, 0, 7.0),
                                                  child: Image.asset(
                                                      capacity == "2  Person"
                                                          ? person2Image
                                                          : capacity ==
                                                                  "4  Person"
                                                              ? person4Image
                                                              : capacity ==
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
                                                          "${customFormat.format(selectedDate)}"),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                              color: Colors.black54,
                                              borderRadius:
                                                  borderRadius(7.0, 0, 7.0, 0)),
                                          child: Padding(
                                            padding: const EdgeInsets.all(4.0),
                                            child: Text(
                                              tableNo,
                                              style: size20Amber,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                          }
                        },
                      ),
              ),
            ),
          ],
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

  void getTimeAndRemoveCustomer() {
    timeString = DateTime.now().toString();
    List splitText = timeString.split(".");
    timeStringWithSplit = splitText[0];
    print(timeStringWithSplit);
    DateTime now = DateTime.parse(timeStringWithSplit);
    var tableReference = FirebaseFirestore.instance
        .collection("Users")
        .doc(MyApp().controller.userModel.key1)
        .collection("Tables");

    tableReference.get().then((QuerySnapshot tableData) {
      tableData.docs.forEach((element) {
        print(element.data()["Key"]);

        tableReference
            .doc(element.data()["Key"])
            .collection("Customer")
            .where("FlagForDinner", isEqualTo: "0")
            .get()
            .then((QuerySnapshot customerData) {
              bool timeOut = now.isAfter(DateTime.parse(customerData.docs.elementAt(0).data()["EndTime"]));
              print(timeOut);
              timeOut == true ?
                  tableReference.doc(element.data()["Key"]).collection("Customer").doc(customerData.docs.elementAt(0).data()["Key"]).update({
                    "FlagForDinner" : "1"
                  }).catchError((onError){
                    print("Error 2");
                  }) : print("");
            })
            .catchError((onError) {
          print("Error 1");
          print(onError.message);
          print(onError);
        });
      });
    });
  }
}
