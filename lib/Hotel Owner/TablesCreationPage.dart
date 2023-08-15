import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reserved_table/main.dart';
import 'package:reserved_table/Constance/Styles.dart';

class TableCreationPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return TableCreationPageState();
  }
}

class TableCreationPageState extends State<TableCreationPage> {
  List<String> selectedItemValue = List<String>();
  final GlobalKey<State> globalKey = new GlobalKey<State>();

  var items = int.parse(MyApp().controller.hotelModel.hotelTables);

  final database = FirebaseFirestore.instance
      .collection('Users')
      .doc(MyApp().controller.userModel.key1)
      .collection("Tables");

  List dataList = [];
  Map<String, String> dataMap = Map();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(top: 25),
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 110,
              child: ListView.builder(
                itemCount: items,
                itemBuilder: (BuildContext context, int index) {
                  for (int i = 1; i <= items; i++) {
                    selectedItemValue.add("NONE");
                  }
                  return Container(
                    height: 100,
                    child: Card(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: Text(
                              "Table No : ${index + 1}",
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(right: 20),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                border:
                                Border.all(width: 1, color: Colors.grey)),
                            child: Padding(
                              padding:
                              const EdgeInsets.symmetric(horizontal: 10),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton(
                                  value:
                                  selectedItemValue[index + 1].toString(),
                                  items: _dropDownItem(),
                                  onChanged: (value) {
                                    print(index + 1);
                                    selectedItemValue[index + 1] = value;
                                    setState(() {});
                                  },
                                  hint: Text('Type            '),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Expanded(
              flex: 10,
              child: GestureDetector(
                onTap: () {
                  for (int i = 1; i <= items; i++) {
                    if (selectedItemValue.elementAt(i).toString() == "NONE") {
                      print(i);
                      Get.snackbar("Error", "Tables $i is NONE, Please select value");
                      break;
                    } else{
                         dataMap['TableNumber'] = (i).toString();
                         dataMap['Person'] = selectedItemValue.elementAt(i).toString();
                         createTables();
                         if(i == items){
                           updateTableStatus();
                         }
                    }
                  }
                },
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 7, vertical: 5),
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
                      "Create",
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

  void createTables() {
    dataList.add(dataMap);
    if (dataList.length.toString() ==
        MyApp().controller.hotelModel.hotelTables) {
      for (int k = 1; k <= items; k++) {
        var kString = k.toString();
        if(kString.length == 1)
        {
          kString = kString.padLeft(2,'0'); //RIGHT HERE!!!
        }
        DocumentReference collectionReference =
        database.doc("KeyTableNumber$kString");
        String key = collectionReference.id;
        collectionReference.set({
          "Key": key,
          "TableNumber": (kString).toString(),
          "Person": selectedItemValue.elementAt(k).toString(),
        }).catchError((onError) {
          Get.snackbar("Error", onError.message);
        });
      }
    }
  }

  void updateTableStatus(){
    MyApp().controller.handleSubmit(context);
    MyApp().controller.tableCreatedYes();
  }

}

List<DropdownMenuItem<String>> _dropDownItem() {
  List<String> dropDownList = [
    "NONE",
    "2  Person",
    "4  Person",
    "6  Person",
    "8  Person"
  ];
  return dropDownList
      .map(
        (value) => DropdownMenuItem(
      value: value,
      child: Text(value),
    ),
  )
      .toList();
}