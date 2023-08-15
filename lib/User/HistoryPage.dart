import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:reserved_table/Constance/Colors.dart';
import 'package:get/get.dart';
import 'package:reserved_table/Constance/Styles.dart';
import 'package:reserved_table/Widgets/Widgets.dart';
import 'package:reserved_table/main.dart';

class HistoryPage extends StatefulWidget {
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {

  double height = 220.0;
  double heightDinner = 250.0;
  Timer timer;
  String timeStringWithSplit;
  String timeString;
  String percentageString;
  double percentageProgress;
  double percentage;
  double decimalPercentage;

  var history = FirebaseFirestore.instance
      .collection("Users")
      .doc(MyApp().controller.userModel.key1)
      .collection("History").snapshots();

  @override
  void initState() {
    super.initState();
    timeString = DateTime.now().toString();
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) => _getTime());
  }

  @override
  void dispose() {
    // TODO: implement dispose
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "History",
          style: size25,
        ),
        elevation: 0.0,
        backgroundColor: appBar,
        centerTitle: true,
      ),
      body: Container(
        child: StreamBuilder<QuerySnapshot>(
          stream: history,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) return Text("Error : ${snapshot.error}");
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return Container(
                    child: Center(child: customCircularProcess()));
              default:
                return snapshot.data.docs.length != 0 ? ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (_, int index) {
                    var date = snapshot.data.docs[index]["Date"];
                    var time = snapshot.data.docs[index]["Time"];
                    var name = snapshot.data.docs[index]["UserName"];
                    var tableNumber = snapshot.data.docs[index]["TableNumber"];
                    var hotelName = snapshot.data.docs[index]["HotelName"];
                    var totalPerson = snapshot.data.docs[index]["TotalPerson"];
                    var endTime = snapshot.data.docs[index]["EndTime"];
                    var startTime = snapshot.data.docs[index]["StartTime"];
                    var dinnerStatus = snapshot.data.docs[index]["DinnerStatus"];
                    var keyHotel = snapshot.data.docs[index]["KeyHotel"];
                    var key = snapshot.data.docs[index]["Key"];
                    var keyUser = MyApp().controller.userModel.key1;
                    return Container(
                      height: dinnerStatus == "Start" ? heightDinner : height,
                      margin: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                      decoration: BoxDecoration(
                          color: Color(0xFF424242),
                          borderRadius: BorderRadius.circular(7.0)),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Positioned(
                            top: 0,
                            right: 0,
                            child: Container(
                              child: dinnerStatus == "End"
                                  ? Container(
                                  margin: EdgeInsets.all(5.0),
                                  child: Text("Done",style: size14W500Amber))
                                  : timeStringWithSplit == endTime
                                  ? endDinner(key, keyUser, keyHotel, endTime)
                                  : done(key, keyUser, keyHotel, startTime, endTime,),
                            ),
                          ),
                          Container(
                            height: dinnerStatus == "Start"
                                ? heightDinner
                                : height,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: Container(
                                    margin: EdgeInsets.only(left: 20.0, top: 5),
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          flex: 9,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 5.0),
                                            child: RichText(
                                              text: TextSpan(children: [
                                                TextSpan(
                                                  text: hotelName,
                                                  style: size30W500Grey,
                                                ),

                                              ]),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 30,
                                          child: Column(
                                            children: [
                                              requestData("Table No : ", tableNumber),
                                              requestData("Total Person : ", totalPerson),
                                              requestData("Name : ", name),
                                              requestData("Date : ", date),
                                              requestData("Time : ", time),
                                              SizedBox(height: 10,),
                                              Container(
                                                  margin: EdgeInsets.only(
                                                      right: 20),
                                                  child: dinnerStatus == "End"
                                                      ? Container(height: 0,)
                                                      : Stack(
                                                    children: [
                                                      LinearProgressIndicator(
                                                        backgroundColor: linerProcessBackGround,
                                                        minHeight: 15,
                                                        valueColor: new AlwaysStoppedAnimation<Color>(linerProcessForeGround),
                                                        value: percentage,
                                                      ),
                                                      Center(child: Text("$percentageString %",style:size14Black)),
                                                    ],
                                                  )
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                        ],
                      ),
                    );
                  },
                ) : noMoreData();
            }
          },
        ),
      ),
    );
  }

  Widget endDinner(String historyKey, String keyUser, String keyHotel,
      String endTime) {
    String dinnerStatus = "Loading...";

    var updateHistoryUser = FirebaseFirestore.instance
        .collection("Users")
        .doc(keyUser)
        .collection("History");
    var updateHistoryOwner = FirebaseFirestore.instance
        .collection("Users")
        .doc(keyHotel)
        .collection("History");
    updateHistoryUser.doc(historyKey).update({"DinnerStatus": "End","FlagForDinner": "1"}).then((
        value) {
      updateHistoryOwner.doc(historyKey).update({"DinnerStatus": "End","FlagForDinner": "1"}).then((
          value) {
        updateHistoryOwner
            .where("Key", isEqualTo: historyKey)
            .get()
            .then((QuerySnapshot value2) {
          setState(() {
            dinnerStatus = value2.docs.elementAt(0).data()["DinnerStatus"];
          });
        }).catchError((onError) {
          print("Error 1");
          Get.snackbar("Error", onError.message);
        });
      }).catchError((onError) {
        print("Error 2");
        Get.snackbar("Error", onError.message);
      });
    }).catchError((onError) {
      print("Error 3");
      Get.snackbar("Error", onError.message);
    });

    return Container(
        margin: EdgeInsets.all(5.0),
        child: Text(dinnerStatus,style: size14W500Amber));
  }


  Widget done(String key, String keyUser, String keyHotel, String startTime,
      String endTime) {
    String dinnerStatus = "Loading...";

    DateTime now = DateTime.now();
    String d = now.toString();
    List sp = d.split(".");
    String fs = sp[0];
    DateTime now2 = DateTime.parse(fs);
    bool timeOut = now2.isAfter(DateTime.parse(endTime));

    DateTime dob = DateTime.parse(endTime);
    Duration dur = dob.difference(DateTime.now());
    String diff = dur.toString();
    List spitList = diff.split(".");
    String finalStringDifference = spitList[0];
    print(">>>" + finalStringDifference);


    DateTime end1 = DateTime.parse(endTime);
    Duration duration = end1.difference(DateTime.now());
    String difference = duration.toString();
    List perfectTime = difference.split(".");
    String pickTime = perfectTime[0];


    List timeList = pickTime.split(":");
    double min = double.parse(timeList[1]);
    double sec = double.parse(timeList[2]);
    double totalSeconds = (min * 60) + sec;
    double secondPercentages = (totalSeconds * 100) / 3600;
    percentageProgress = 100 - secondPercentages;
    percentage = percentageProgress / 100;
    percentageString = percentageProgress.toStringAsFixed(2);
    decimalPercentage = double.parse(percentageString);


    var updateHistoryUser = FirebaseFirestore.instance
        .collection("Users")
        .doc(keyUser)
        .collection("History");
    var updateHistoryOwner = FirebaseFirestore.instance
        .collection("Users")
        .doc(keyHotel)
        .collection("History");

    timeOut == true ? updateHistoryUser.doc(key)
        .update({"DinnerStatus": "End","FlagForDinner": "1",})
        .then((value) {
      updateHistoryOwner.doc(key).update({"DinnerStatus": "End","FlagForDinner": "1",}).then((value) {
        updateHistoryOwner
            .where("Key", isEqualTo: key)
            .get()
            .then((QuerySnapshot value2) {
          print(value2.docs.elementAt(0).data()["DinnerStatus"]);
          setState(() {
            dinnerStatus = value2.docs.elementAt(0).data()["DinnerStatus"];
          });
        }).catchError((onError) {
          print("Error 1");
          Get.snackbar("Error", onError.message);
        });
      }).catchError((onError) {
        print("Error 2");
        Get.snackbar("Error", onError.message);
      });
    }).catchError((onError) {
      print("Error 3");
      Get.snackbar("Error", onError.message);
    }) : print("Updated");

    return Container(
        margin: EdgeInsets.all(5.0),
        child: Text(finalStringDifference,style: size14W500Amber));
  }

  void _getTime() {
    final DateTime now = DateTime.now();
    setState(() {
      timeString = now.toString();
      List splitText = timeString.split(".");
      timeStringWithSplit = splitText[0];
    });
  }

}
