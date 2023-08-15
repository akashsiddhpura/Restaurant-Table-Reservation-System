import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reserved_table/Admin/RequestDetailPage.dart';
import 'package:reserved_table/Constance/Colors.dart';
import 'package:reserved_table/Constance/Strings.dart';
import 'package:reserved_table/Constance/Styles.dart';
import 'package:reserved_table/Widgets/Widgets.dart';
import 'package:reserved_table/main.dart';

class PendingRequestPage extends StatefulWidget {
  @override
  _PendingRequestPageState createState() => _PendingRequestPageState();
}

class _PendingRequestPageState extends State<PendingRequestPage> {

  double height = 170.0;
  double heightOnTap = 115.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).padding.top,
            ),
            Expanded(
              child: Container(
                child: StreamBuilder<QuerySnapshot>(
                  stream: MyApp().controller.ownerRequestReference.snapshots(),
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
                            var hotelAddress =
                                snapshot.data.docs[index]["HotelAddress"];
                            var hotelName = snapshot.data.docs[index]["HotelName"];
                            var hotelImage = snapshot.data.docs[index]["HotelImage"];
                            var hotelReRequested =
                                snapshot.data.docs[index]["HotelReRequested"];
                            var key = snapshot.data.docs[index]["Key"];
                            return Container(
                              height: height,
                              margin: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                              decoration: BoxDecoration(
                                  color: Color(0xFF424242),
                                  borderRadius: BorderRadius.circular(7.0)),
                              child: Stack(
                                children: [

                                  ImageClipRRect(height: height, hotelImage: hotelImage),
                                  GradientClipRRect(),

                                  Container(
                                    height: height,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        SizedBox(),
                                        Container(
                                          margin: EdgeInsets.only(left: 20),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Expanded(
                                               flex:30,
                                                child: Container(
                                                  margin: EdgeInsets.only(right: 10),
                                                  child: Image.asset(hotelIcon,
                                                      fit: BoxFit.cover),
                                                ),
                                              ),
                                              Expanded(
                                                flex:220,
                                                child: text20(
                                                  hotelName
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(left: 20),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Expanded(
                                                flex:30,
                                                child: Container(
                                                  margin: EdgeInsets.only(right: 10),
                                                  child: Image.asset(
                                                      hotelLocationIcon,
                                                      fit: BoxFit.cover),
                                                ),
                                              ),
                                              Expanded(
                                                flex:220,
                                                child: text20(
                                                  hotelAddress
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Row(
                                          children: <Widget>[
                                            Expanded(
                                              child: GestureDetector(
                                                onTap: () {
                                                  Get.to(()=>RejectOwnerRequestPage(index:index,ownerKey:key));
                                                },
                                                child: Container(
                                                  height: 50,
                                                  margin: EdgeInsets.only(
                                                      left: 5, right: 2.5, bottom: 5),
                                                  decoration: BoxDecoration(
                                                    color: Color(0xFFa64c32),
                                                    borderRadius: borderRadius(0,0,0,7),
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      "Rejected",
                                                      style: size20,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: GestureDetector(
                                                onTap: () {
                                                  customDialog(context,"Accept","Are You Sure To Accept This Hotel ?",()=>acceptedOwner(index, key),"Accept",size20Green);
                                                },
                                                child: Container(
                                                  height: 50,
                                                  margin: EdgeInsets.only(
                                                      left: 2.5, right: 5, bottom: 5),
                                                  decoration: BoxDecoration(
                                                    color: Color(0xFF32a647),
                                                    borderRadius: borderRadius(0,0,7,0)
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      "Accepted",
                                                      style: size20,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Get.to(()=>RequestInDetailPage(
                                          snapshot: snapshot, index: index));
                                    },
                                    child: Container(
                                      height: heightOnTap,
                                    ),
                                  ),
                                  hotelReRequested == "Yes"
                                      ? Positioned(
                                          top: 0,
                                          right: 0,
                                          child: Container(
                                            height: 40,
                                            width: 40,
                                            decoration: BoxDecoration(
                                                color: Colors.black54,
                                                borderRadius: borderRadius(0,7,0,7)),
                                            child: Icon(Icons.star_rounded),
                                          ),
                                        )
                                      : Container(
                                          height: 0,
                                          width: 0,
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
            ),
          ],
        ),
      ),
    );
  }


  void acceptedOwner(int index, String key) {
    Get.back();
    MyApp().controller.handleSubmit(context);
    MyApp().controller.acceptRequest(index, key);
  }
}


class RejectOwnerRequestPage extends StatefulWidget {
  final int index;
  final String ownerKey;

  RejectOwnerRequestPage({this.index, this.ownerKey});

  @override
  _RejectOwnerRequestPageState createState() => _RejectOwnerRequestPageState();
}

class _RejectOwnerRequestPageState extends State<RejectOwnerRequestPage> {
  List reasonList = [
    "Owner Name Not Valid.",
    "Owner Mobile Number Not Valid.",
    "Owner Email Not Valid.",
    "Owner Image Not Valid.",
    "Owner Proof Image Not Valid.",
    "Hotel Name Not Valid.",
    "Hotel TelePhone Number Not Valid.",
    "Hotel Email Not Valid.",
    "Hotel Address Not Valid.",
    "Hotel Tables Should Be At Least 15.",
    "Hotel Person Capacity Should Be More Than 50.",
    "Hotel Open Time Should Be At Least 10:00 PM.",
    "Hotel Close Time Should Be At Least 7:00 AM.",
  ];
  List mackReason = [];
  String reason = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      mackReason = [];
      for (int i = 1; i <= reasonList.length; i++) {
        inputs.add(false);
      }
    });
  }

  List<bool> inputs = new List<bool>();

  void itemChange(bool val, int index) {
    setState(() {
      inputs[index] = val;
    });

    if (val == true) {
      mackReason.add(reasonList[index]);
    } else {
      mackReason.remove(reasonList[index]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Select Reasons",
          style: size25,
        ),
        elevation: 0.0,
        backgroundColor: Color(0x00FFFFFF),
        centerTitle: true,
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
              flex: 9,
              child: Container(
                child: ListView.builder(
                    itemCount: inputs.length,
                    itemBuilder: (BuildContext context, int index) {
                      return new Card(
                        child: new Container(
                          padding: new EdgeInsets.all(10.0),
                          child: new Column(
                            children: <Widget>[
                              new CheckboxListTile(
                                  value: inputs[index],
                                  checkColor: black,
                                  activeColor: checkBox,
                                  title: new Text(
                                    reasonList[index],
                                    style: size20,
                                  ),
                                  controlAffinity:
                                  ListTileControlAffinity.leading,
                                  onChanged: (bool val) {
                                    itemChange(val, index);
                                  })
                            ],
                          ),
                        ),
                      );
                    }),
              ),
            ),
            Expanded(
              flex: 1,
              child: GestureDetector(
                onTap: () {
                  if (mackReason.length == 0) {
                    Get.snackbar("Error", "Please select at least 1 reason");
                  } else {
                    for (int i = 0; i < mackReason.length; i++) {
                      setState(() {
                        reason = reason + mackReason[i] + " ";
                      });
                    }
                    rejectedOwner(widget.index, widget.ownerKey, reason);
                  }
                },
                child: Container(
                  height: 60,
                  margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      stops: [0.1, 0.6, 0.9],
                      colors: [
                        Colors.red.shade900,
                        Colors.red.shade500,
                        Colors.red.shade300
                      ],
                    ),
                  ),
                  child: Center(
                    child: Text(
                      "Reject Request",
                      style: size25,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void rejectedOwner(int index, String key, String rejectReason) {
    MyApp().controller.handleSubmit(context);
    MyApp().controller.rejectOwnerRequest(index, key, rejectReason);
  }
}