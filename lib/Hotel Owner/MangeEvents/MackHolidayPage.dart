import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reserved_table/Constance/Colors.dart';
import 'package:reserved_table/Constance/Styles.dart';
import 'package:reserved_table/main.dart';
import 'package:reserved_table/Widgets/Widgets.dart';
import 'package:intl/intl.dart';

class HolidayPage extends StatefulWidget {
  @override
  _HolidayPageState createState() => _HolidayPageState();
}

class _HolidayPageState extends State<HolidayPage> {
  List reasonList = ["Renovation.", "In Shifting.", "LockDown."];
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

  TextEditingController controller = TextEditingController();


  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar:customAppBar("Select Reasons"),
      body: Container(
        child: Column(
          children: [
            Expanded(
              flex: 7,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                      flex: 350,
                      child: Center(
                          child: Text(
                            "Select Date : ",
                            style: size25,
                          ))),
                  Expanded(
                    flex: 300,
                    child: Container(
                      margin: EdgeInsets.only(right: 20),
                      child: GestureDetector(
                        onTap: () {
                          showPicker(context);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(7.0),border: Border.all(color: buttonBorderAmber),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                  mackHotelHoliday();
                },
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    gradient: customLinearGradient()
                  ),
                  child: Center(
                    child: Text(
                      "Mack Holiday",
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


  void mackHotelHoliday(){

    if (mackReason.length == 0) {
      Get.snackbar("Error", "Please select at least 1 reason");
    } else {
      for (int i = 0; i < mackReason.length; i++) {
        setState(() {
          reason = reason + mackReason[i] + " ";
        });
      }
      MyApp().controller.handleSubmit(context);
      MyApp().controller.hotelHoliday('${customFormat.format(selectedDate)}',reason);
    }
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
}