import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:reserved_table/Constance/Colors.dart';
import 'package:reserved_table/Constance/Styles.dart';
import 'package:reserved_table/Widgets/Widgets.dart';
import 'package:reserved_table/main.dart';

class QrCodePage extends StatefulWidget {
  final String code;
  final String keyUser;
  final String keyOrder;

  QrCodePage({this.code, this.keyOrder, this.keyUser});

  @override
  _QrCodePageState createState() => _QrCodePageState();
}

class _QrCodePageState extends State<QrCodePage> {


  Timer timer;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(Duration(milliseconds: 1), (Timer t) => getBack());
  }

  @override
  void dispose() {
    // TODO: implement dispose
    timer.cancel();
    super.dispose();
  }


  void getBack(){
    FirebaseFirestore.instance
        .collection("Users")
        .doc(widget.keyUser)
        .collection("Requests").where("Key",isEqualTo: widget.keyOrder).get().then((QuerySnapshot data){
      if(data.docs.elementAt(0).data()["DinnerStatus"] == "Start"){
        Get.back();
      }else{
        print("Wait...");
      }
    }).catchError((onError){
      print("Error 1");
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              flex: 60,
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    QrImage(
                      data: widget.code,
                      size: 300,
                      version: QrVersions.auto,
                      gapless: true,
                      foregroundColor: Colors.white,
                    ),
                    Text(
                      widget.code,
                      style: size30W500GreyOpacity,
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 5,
              child: Container(
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Get.to(() =>
                              TableListPage(
                                keyOrder: widget.keyOrder,
                                keyUser: widget.keyUser,
                              ));
                        },
                        child: Container(
                          margin: EdgeInsets.only(
                              left: 10, right: 5, top: 5, bottom: 5),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(7.0),
                              border: Border.all(
                                  width: 2, color: editMenuButtonBorder),
                              color: editMenuButtonBackground),
                          child: Center(
                            child: Text(
                              "Change Table",
                              maxLines: 1,
                              style: size20W500,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          customDialog(
                              context,
                              "Not Arrived",
                              "Are you sure to remove this request ?",
                                  () => notArrived(),
                              "Confirm",
                              size20Green);
                        },
                        child: Container(
                          margin: EdgeInsets.only(
                              left: 5, right: 10, top: 5, bottom: 5),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(7.0),
                              border: Border.all(
                                  width: 2, color: deleteMenuButtonBorder),
                              color: deleteMenuButtonBackground),
                          child: Center(
                            child: Text(
                              "Not Arrive",
                              maxLines: 1,
                              style: size20W500,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void notArrived() {
    MyApp().controller.handleSubmit(context);
   MyApp().controller.notArrivedUser(widget.keyOrder);
  }
}

List keyTables = [];

class TableListPage extends StatefulWidget {
  final String keyOrder;
  final String keyUser;

  TableListPage({this.keyOrder, this.keyUser});

  @override
  _TableListPageState createState() => _TableListPageState();
}

class _TableListPageState extends State<TableListPage> {
  List<bool> inputs = new List<bool>();
  int totalTablePerson = 0;
  List tableCapacity = [];

  bool isLoDING = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    keyTables = [];
    for (int i = 1;
    i <= int.parse(MyApp().controller.hotelModel.hotelTables);
    i++) {
      setState(() {
        inputs.add(false);
      });
    }
    showTablePerson();
  }

  Future<void> showTablePerson() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("Users")
        .doc(MyApp().controller.userModel.key1)
        .collection("Tables")
        .get();
    for (int i = 0; i < querySnapshot.docs.length; i++) {
      var a = querySnapshot.docs[i]["Person"];
      setState(() {
        tableCapacity.add(a);
        if (inputs.length == tableCapacity.length) {
          setState(() {
            isLoDING = false;
          });
        }
      });
    }
  }

  void itemChange(bool val, int index) {
    setState(() {
      inputs[index] = val;
    });

    var kString = (index + 1).toString();
    if (kString.length == 1) {
      kString = kString.padLeft(2, '0');
    }

    if (val == true) {
      keyTables.add("KeyTableNumber$kString");
    } else {
      keyTables.remove("KeyTableNumber$kString");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            Expanded(
              flex: 50,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 5),
                child: isLoDING
                    ? Container(
                    child: Center(child: customCircularProcess()))
                    : ListView.builder(
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
                                  title: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      new Text(
                                        'Table No : ${index + 1}',
                                        style: size20,
                                      ),
                                      Text(tableCapacity[index])
                                    ],
                                  ),
                                  controlAffinity:
                                  ListTileControlAffinity.leading,
                                  onChanged: (bool val) {
                                    itemChange(val, index);
                                  }),
                            ],
                          ),
                        ),
                      );
                    }),
              ),
            ),
            Expanded(
              flex: 5,
              child: GestureDetector(
                onTap: () async {
                  if (keyTables.length == 0) {
                    Get.snackbar("Error", "Please select at least 1 table");
                  } else {
                    customDialog(
                        context,
                        "Change table",
                        "Are you sure to change table number ?",
                            () => updateTable(widget.keyUser),
                        "Confirm",
                        size20Green);
                  }
                },
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      stops: [0.1, 0.6, 0.9],
                      colors: [
                        Colors.orange.shade600,
                        Colors.amber,
                        Colors.yellow
                      ],
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Change Table",
                        style: size25BlackW500,
                      ),
                      SizedBox(
                        width: 25,
                      ),
                      Icon(Icons.repeat,color: iconBlack,
                        size: 30,)
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String getTableNumbers() {
    String tableNumber = "";
    for (int i = 0; i < keyTables.length; i++) {
      setState(() {
        String tableNumberSubString = keyTables[i];
        List spitList = tableNumberSubString.split("r");
        String particularTableNumber = spitList[1];
        if (i != (keyTables.length)) {
          if (i > 0) tableNumber = tableNumber + "-";
        }
        tableNumber = tableNumber + particularTableNumber;
      });
    }
    return tableNumber;
  }

  void updateTable(String keyUser) {
    MyApp().controller.handleSubmit(context);
    String newTableNumber = getTableNumbers();
    MyApp().controller.updateTableNumberFromOwnerSide(
        widget.keyOrder, keyUser, newTableNumber, keyTables);
  }
}
