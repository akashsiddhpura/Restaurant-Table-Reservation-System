import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reserved_table/Constance/Colors.dart';
import 'package:reserved_table/Hotel Owner/AcceptForFamily.dart';
import 'package:reserved_table/Constance/Styles.dart';
import 'package:reserved_table/Widgets/Widgets.dart';
import 'package:reserved_table/main.dart';

CollectionReference userRequestToOwnerReference = FirebaseFirestore.instance
    .collection("Users")
    .doc(MyApp().controller.userModel.key1)
    .collection("UserRequest");

class RequestCustomerPage extends StatefulWidget {
  @override
  _RequestCustomerPageState createState() => _RequestCustomerPageState();
}

class _RequestCustomerPageState extends State<RequestCustomerPage> {
  double height = 210.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          MyApp().controller.hotelModel.hotelName,
          style: size25B,
        ),
        elevation: 0.0,
        backgroundColor: Color(0x00FFFFFF),
        centerTitle: true,
      ),
      drawer: customDrawer(context),
      body: Container(
        child: StreamBuilder<QuerySnapshot>(
          stream: userRequestToOwnerReference.snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) return Text("Error : ${snapshot.error}");
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return Container(
                    child: Center(child: customCircularProcess()));
              default:
                return snapshot.data.docs.length != 0
                    ? ListView.builder(
                        itemCount: snapshot.data.docs.length,
                        itemBuilder: (_, int index) {
                          var hotelImage =
                              snapshot.data.docs[index]["HotelImage"];
                          var tableNo =
                              snapshot.data.docs[index]["TableNumber"];
                          var date = snapshot.data.docs[index]["Date"];
                          var time = snapshot.data.docs[index]["Time"];
                          var totalPerson =
                              snapshot.data.docs[index]["TotalPerson"];
                          var name = snapshot.data.docs[index]["UserName"];
                          var mobile = snapshot.data.docs[index]["MobileNo"];
                          var keyUser = snapshot.data.docs[index]["KeyUser"];
                          var keyHotel = snapshot.data.docs[index]["KeyHotel"];
                          var key = snapshot.data.docs[index]["Key"];
                          var family =
                              snapshot.data.docs[index]["FamilyRequest"];
                          return Container(
                            height: height,
                            margin: EdgeInsets.symmetric(
                                horizontal: 4, vertical: 2),
                            decoration: BoxDecoration(
                                color: Color(0xFF424242),
                                borderRadius: BorderRadius.circular(7.0)),
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                ImageClipRRect(height: height, hotelImage: hotelImage),
                                GradientClipRRect(),
                                Positioned(
                                  right: 0,
                                  top: 0,
                                  child: Container(
                                    height: 60,
                                    width: 120,
                                    decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.7),
                                        borderRadius: borderRadius(0, 7, 0, 7)),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          time,
                                          style: size18,
                                        ),
                                        Text(
                                          date,
                                          style: size18,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  height: height,
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        flex: 3,
                                        child: Container(
                                          margin: EdgeInsets.only(
                                              left: 20.0, top: 5),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                flex: 2,
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 5.0),
                                                  child: family == "Yes"
                                                      ? Text(
                                                          "In Family",
                                                          style:
                                                              size30W500Amber,
                                                        )
                                                      : RichText(
                                                          text: TextSpan(
                                                              children: [
                                                                TextSpan(
                                                                  text:
                                                                      "Table No : ",
                                                                  style:
                                                                      size30W500Grey,
                                                                ),
                                                                TextSpan(
                                                                  text: tableNo,
                                                                  style:
                                                                      size30W500Cyan,
                                                                ),
                                                              ]),
                                                        ),
                                                ),
                                              ),
                                              Expanded(
                                                flex: 5,
                                                child: SingleChildScrollView(
                                                  child: Column(
                                                    children: [
                                                      requestData(
                                                          "Name : ", name),
                                                      requestData(
                                                          "Mobile No : ",
                                                          mobile),
                                                      requestData(
                                                          "Total Person : ",
                                                          totalPerson),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Row(
                                          children: <Widget>[
                                            Expanded(
                                              child: GestureDetector(
                                                onTap: () async {
                                                  Get.to(() => RejectUserRequestPage(index:index,keyCustomer:key,keyUser:keyUser,keyHotel:keyHotel));
                                                },
                                                child: Container(
                                                  margin: EdgeInsets.only(
                                                      left: 5,
                                                      right: 2.5,
                                                      bottom: 5),
                                                  decoration: BoxDecoration(
                                                    color: Color(0xFFa64c32),
                                                    borderRadius: borderRadius(
                                                        0, 0, 0, 7),
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
                                                  family == "Yes"
                                                      ? Get.to(() =>
                                                          AcceptFamilyRequest(
                                                              index: index,
                                                              keyUser: keyUser,
                                                              keyRequest: key,
                                                              totalPerson: int.parse(totalPerson)
                                                          ))
                                                      :
                                                  customDialog(context,"Accept User","Are You Sure To Accept This User ?",()=>acceptedUser(index, key, keyUser, keyHotel),"Accept",size20Green);
                                                },
                                                child: Container(
                                                  margin: EdgeInsets.only(
                                                      left: 2.5,
                                                      right: 5,
                                                      bottom: 5),
                                                  decoration: BoxDecoration(
                                                      color: Color(0xFF32a647),
                                                      borderRadius:
                                                          borderRadius(
                                                              0, 0, 7, 0)),
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
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      )
                    : noMoreData();
            }
          },
        ),
      ),
    );
  }

  void acceptedUser(int index, String key, String keyUser, String keyHotel) {
    Get.back();
    MyApp().controller.handleSubmit(context);
    MyApp().controller.acceptUserRequest(index, key, keyUser, keyHotel);
  }
}

class RejectUserRequestPage extends StatefulWidget {
  final int index;
  final String keyCustomer;
  final String keyHotel;
  final String keyUser;

  RejectUserRequestPage(
      {this.index, this.keyCustomer, this.keyUser, this.keyHotel});

  @override
  _RejectUserRequestPageState createState() => _RejectUserRequestPageState();
}

class _RejectUserRequestPageState extends State<RejectUserRequestPage> {
  List reasonList = [
    "Table already reserved.",
    "Please reserve another table.",
    "Fill up valid information.",
    "Closed."
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
    print(reasonList);
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
              flex: 90,
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
                                  activeColor: checkBox,
                                  checkColor: black,
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
              flex: 10,
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
                    rejectedUser(widget.index, widget.keyCustomer,
                        widget.keyUser, widget.keyHotel, reason);
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
                      style: size25BlackW500,
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

  void rejectedUser(int index, String key, String keyUser, String keyHotel,
      String rejectReason) {
    MyApp().controller.handleSubmit(context);
    MyApp().controller
        .rejectUserRequest(index, key, keyUser, keyHotel, rejectReason);
  }
}
