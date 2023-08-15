import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:reserved_table/Constance/Colors.dart';
import 'package:reserved_table/main.dart';
import 'package:reserved_table/Constance/Styles.dart';
import 'package:reserved_table/Widgets/Widgets.dart';
import 'dart:async';
import 'package:get/get.dart';

class OnlineCustomerPage extends StatefulWidget {
  @override
  _OnlineCustomerPageState createState() => _OnlineCustomerPageState();
}

class _OnlineCustomerPageState extends State<OnlineCustomerPage> {
  double heightDinner = 210.0;
  double height = 180.0;

  Timer timer;
  String timeString;
  String timeStringWithSplit;
  double decimalPercentage;

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

  var history = FirebaseFirestore.instance
      .collection("Users")
      .doc(MyApp().controller.userModel.key1)
      .collection("History")
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar("History"),
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
                return snapshot.data.docs.length != 0 ?ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (_, int index) {
                    var date = snapshot.data.docs[index]["Date"];
                    var time = snapshot.data.docs[index]["Time"];
                    var name = snapshot.data.docs[index]["UserName"];
                    var tableNumber = snapshot.data.docs[index]["TableNumber"];
                    var totalPerson = snapshot.data.docs[index]["TotalPerson"];
                    var dinnerStatus = snapshot.data.docs[index]["DinnerStatus"];
                    var endTime = snapshot.data.docs[index]["EndTime"];
                    var startTime = snapshot.data.docs[index]["StartTime"];
                    var key = snapshot.data.docs[index]["Key"];
                    var keyUser = snapshot.data.docs[index]["KeyUser"];
                    var keyHotel = snapshot.data.docs[index]["KeyHotel"];
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
                                      ? endDinner(key, keyUser, keyHotel,endTime)
                                      : done(key, keyUser, keyHotel,startTime,endTime),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 20.0, top: 5),
                            height: dinnerStatus == "Start" ? heightDinner : height,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 90,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 5.0),
                                    child: RichText(
                                      text: TextSpan(children: [
                                        TextSpan(
                                          text: "Table No : ",
                                          style: size30W500Grey,
                                        ),
                                        TextSpan(
                                          text: tableNumber,
                                          style: size30W500Cyan,
                                        ),
                                      ]),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 300,
                                  child: Column(
                                    children: [
                                      requestData("Name : ", name),
                                      requestData("Date : ", date),
                                      requestData("Time : ", time),
                                      requestData("Total Person : ", totalPerson),
                                      SizedBox(height: 10,),
                                      Container(
                                          margin: EdgeInsets.only(right: 20),
                                          child: dinnerStatus == "End"
                                              ? Container() : Stack(
                                            children: [
                                              LinearProgressIndicator(
                                                backgroundColor: linerProcessBackGround,
                                                minHeight: 15,
                                                valueColor: new AlwaysStoppedAnimation<Color>(linerProcessForeGround),
                                                value: percentage,
                                              ),
                                              Center(child: Text("$ss %",style:size14Black)),
                                            ],
                                          )
                                      ),
                                    ],
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


  Widget endDinner(String key, String keyUser, String keyHotel,String endTime) {
    String dinnerStatus = "Loading...";

    List tableKeyArrayForDelete = [];
    var updateHistoryUser = FirebaseFirestore.instance
        .collection("Users")
        .doc(keyUser)
        .collection("History");
    var updateHistoryOwner = FirebaseFirestore.instance
        .collection("Users")
        .doc(keyHotel)
        .collection("History");


    updateHistoryUser.doc(key).update({"DinnerStatus": "End","FlagForDinner": "1",}).then((value) {
      updateHistoryOwner.doc(key).update({"DinnerStatus": "End","FlagForDinner": "1"}).then((value) {
        updateHistoryOwner
            .where("Key", isEqualTo: key)
            .get()
            .then((QuerySnapshot value2) {

          setState(() {
            dinnerStatus = value2.docs.elementAt(0).data()["DinnerStatus"];
          });

          tableKeyArrayForDelete = value2.docs.elementAt(0).data()["KeyTableArray"];
            for (int i = 0; i < tableKeyArrayForDelete.length; i++) {
              FirebaseFirestore.instance
                  .collection("Users")
                  .doc(keyHotel)
                  .collection("Tables")
                  .where("Key", isEqualTo: tableKeyArrayForDelete[i])
                  .get()
                  .then((QuerySnapshot value4) {
                FirebaseFirestore.instance
                    .collection("Users")
                    .doc(keyHotel)
                    .collection("Tables")
                    .doc(value4.docs.elementAt(0).data()["Key"])
                    .collection("Customer")
                    .where("Key", isEqualTo: key)
                    .get()
                    .then((QuerySnapshot value3) {
                  FirebaseFirestore.instance
                      .collection("Users")
                      .doc(keyHotel)
                      .collection("Tables")
                      .doc(value4.docs.elementAt(0).data()["Key"])
                      .collection("Customer")
                      .doc(value3.docs.elementAt(0).data()["Key"])
                      .delete()
                      .then((value) {
                   print("Delete Customer From Table");
                  }).catchError((onError) {
                    print("Error 0");

                    Get.snackbar("Error", onError.message);
                  });
                }).catchError((onError) {
                  print("Error 1");

                  Get.snackbar("Error", onError.message);
                });
              }).catchError((onError) {
                print("Error 2");
                Get.snackbar("Error", onError.message);
              });
            }

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


  double percentageProgress;
  double percentage;
  String ss;
  Widget done(String key, String keyUser, String keyHotel,String startTime,String endTime) {

    String dinnerStatus = "Loading...";
    List tableKeyArrayForDelete = [];

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
    double totalSeconds = (min*60)+sec;
    double secondPercentages = (totalSeconds*100)/3600;
    percentageProgress = 100-secondPercentages;
    percentage = percentageProgress/100;
    ss = percentageProgress.toStringAsFixed(2);


    var updateHistoryUser = FirebaseFirestore.instance
        .collection("Users")
        .doc(keyUser)
        .collection("History");
    var updateHistoryOwner = FirebaseFirestore.instance
        .collection("Users")
        .doc(keyHotel)
        .collection("History");

    timeOut == true ? updateHistoryUser.doc(key).update({"DinnerStatus": "End","FlagForDinner": "1",}).then((value) {
      updateHistoryOwner.doc(key).update({"DinnerStatus": "End","FlagForDinner": "1",}).then((value) {
        updateHistoryOwner
            .where("Key", isEqualTo: key)
            .get()
            .then((QuerySnapshot value2) {
          print(value2.docs.elementAt(0).data()["DinnerStatus"]);
          setState(() {
            dinnerStatus = value2.docs.elementAt(0).data()["DinnerStatus"];
          });

          tableKeyArrayForDelete = value2.docs.elementAt(0).data()["KeyTableArray"];
          for (int i = 0; i < tableKeyArrayForDelete.length; i++) {
            FirebaseFirestore.instance
                .collection("Users")
                .doc(keyHotel)
                .collection("Tables")
                .where("Key", isEqualTo: tableKeyArrayForDelete[i])
                .get()
                .then((QuerySnapshot value4) {
              FirebaseFirestore.instance
                  .collection("Users")
                  .doc(keyHotel)
                  .collection("Tables")
                  .doc(value4.docs.elementAt(0).data()["Key"])
                  .collection("Customer")
                  .where("Key", isEqualTo: key)
                  .get()
                  .then((QuerySnapshot value3) {
                FirebaseFirestore.instance
                    .collection("Users")
                    .doc(keyHotel)
                    .collection("Tables")
                    .doc(value4.docs.elementAt(0).data()["Key"])
                    .collection("Customer")
                    .doc(value3.docs.elementAt(0).data()["Key"])
                    .delete()
                    .then((value) {
                  print("Delete Customer From Table");
                }).catchError((onError) {
                  print("Error 0");

                  Get.snackbar("Error", onError.message);
                });
              }).catchError((onError) {
                print("Error 1");

                Get.snackbar("Error", onError.message);
              });
            }).catchError((onError) {
              print("Error 2");
              Get.snackbar("Error", onError.message);
            });
          }


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
    }) : print(dinnerStatus) ;

    return Container(
        margin: EdgeInsets.all(5.0),
        child: Text(finalStringDifference,style: size14W500Amber,));
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
