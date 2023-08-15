import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:reserved_table/Constance/Colors.dart';
import 'package:reserved_table/Widgets/Widgets.dart';
import '../main.dart';
import 'package:reserved_table/Constance/Styles.dart';
import 'package:get/get.dart';

List tableKeys = [];

class AcceptFamilyRequest extends StatefulWidget {
  final int index;
  final String keyUser;
  final String keyRequest;
  final int totalPerson;

  AcceptFamilyRequest(
      {this.index, this.keyUser, this.keyRequest, this.totalPerson});

  @override
  _AcceptFamilyRequestState createState() => _AcceptFamilyRequestState();
}

class _AcceptFamilyRequestState extends State<AcceptFamilyRequest> {
  List<bool> inputs = new List<bool>();
  int totalTablePerson = 0;
  List tableCapacity = [];

  bool isLoDING = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    tableKeys = [];
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
      tableKeys.add("KeyTableNumber$kString");
    } else {
      tableKeys.remove("KeyTableNumber$kString");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Select Tables",
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
                margin: EdgeInsets.symmetric(horizontal: 5),
                child: isLoDING
                    ? Container(child: Center(child: customCircularProcess()))
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
              flex: 10,
              child: GestureDetector(
                onTap: () async {
                  if (tableKeys.length == 0) {
                    Get.snackbar("Error", "Please select at least 1 table");
                  } else {
                    customDialog(context,"Accept Family Request","Are you sure to accept this family request ?",()=>familyRequest(),"Accept",size20Green);
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
                  child: Center(
                    child: Text(
                      "Accept Family Request",
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


  String getTableNumbers() {
    String tableNumber = "";
    for (int i = 0; i < tableKeys.length; i++) {
      setState(() {
        String tableNumberSubString = tableKeys[i];
        List spitList = tableNumberSubString.split("r");
        String particularTableNumber = spitList[1];
        if (i != (tableKeys.length)) {
          if (i > 0) tableNumber = tableNumber + "-";
        }
        tableNumber = tableNumber + particularTableNumber;
      });
    }
    return tableNumber;
  }

  void familyRequest() {
    MyApp().controller.handleSubmit(context);
    String allTables = getTableNumbers();
    MyApp().controller.acceptFamilyRequest(
        widget.index, widget.keyUser, widget.keyRequest, allTables);
  }
}
