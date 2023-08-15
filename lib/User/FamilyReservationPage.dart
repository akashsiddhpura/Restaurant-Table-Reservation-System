import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reserved_table/Constance/Colors.dart';
import 'package:reserved_table/Constance/Styles.dart';
import 'package:reserved_table/Constance/Validators.dart';
import 'package:reserved_table/Widgets/Widgets.dart';
import 'package:day_night_time_picker/day_night_time_picker.dart';
import 'package:reserved_table/main.dart';

class FamilyReservationPage extends StatefulWidget {
  final int index;
  final String date;
  final String code;

  FamilyReservationPage({this.index, this.date, this.code});

  @override
  _FamilyReservationPageState createState() => _FamilyReservationPageState();
}

class _FamilyReservationPageState extends State<FamilyReservationPage> {
  TextEditingController _name = TextEditingController()
    ..text = MyApp().controller.userModel.userName;
  TextEditingController _mobile = TextEditingController()
    ..text = MyApp().controller.userModel.userMobileNo;
  List items = [
    "12",
    "13",
    "14",
    "15",
    "16",
    "17",
    "18",
    "19",
    "20",
    "21",
    "22",
    "23",
    "24",
    "25",
  ];
  int selectedIndex = 1;
  String persons;

  @override
  void initState() {
    super.initState();
    persons = items[1];
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      // resizeToAvoidBottomPadding: false,
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
                    flex: 90,
                    child: Column(
                      children: [
                        SizedBox(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Family Request",
                              style: size50W500Orange,
                            )
                          ],
                        ),
                        SizedBox(height: 30),
                        Form(
                          key: MyApp().controller.formKey,
                          autovalidateMode: AutovalidateMode.disabled,
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(7.0),
                                          border: Border.all(
                                              width: 2,
                                              color: buttonBorderAmber)),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          widget.date,
                                          style: size20,
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        FocusScope.of(context)
                                            .requestFocus(FocusNode());
                                        Navigator.of(context).push(
                                          showPicker(
                                            accentColor: timePicker,
                                            context: context,
                                            value: _time,
                                            onChange: onOpenTimeChanged,
                                            is24HrFormat: false,
                                          ),
                                        );
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(7.0),
                                            border: Border.all(
                                                width: 2,
                                                color: buttonBorderAmber)),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            children: [
                                              Text(
                                                time,
                                                style: size20,
                                              ),
                                              SizedBox(
                                                width: 7,
                                              ),
                                              Icon(Icons.arrow_drop_down_sharp)
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 30),
                                buildRow2("Name", _name, "Enter name",
                                    TextInputType.text, nameValidator, 30),
                                buildRow2(
                                    "Mobile No",
                                    _mobile,
                                    "Enter mobile number",
                                    TextInputType.phone,
                                    mobileValidator,
                                    10),
                                Row(
                                  children: [
                                    Expanded(
                                      flex: 50,
                                      child: Container(
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 15),
                                          child: Text(
                                            "Total Person",
                                            style: size20,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 100,
                                      child: Center(
                                        child: Container(
                                          height: 100,
                                          margin: EdgeInsets.only(top: 7),
                                          child: ListView.builder(
                                              scrollDirection: Axis.horizontal,
                                              itemCount: items.length,
                                              shrinkWrap: true,
                                              itemBuilder: (context, index) {
                                                return Padding(
                                                  padding:
                                                      const EdgeInsets.all(5.0),
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      FocusScope.of(context)
                                                          .requestFocus(
                                                              FocusNode());
                                                      setState(() {
                                                        selectedIndex = index;
                                                        persons = items[index]
                                                            .toString();
                                                      });
                                                    },
                                                    child: Container(
                                                      child: index ==
                                                              selectedIndex
                                                          ? CircleAvatar(
                                                              backgroundColor:
                                                                  Colors.amber
                                                                      .shade300,
                                                              radius: 30,
                                                              child: Text(
                                                                items[index],
                                                                style: size25B,
                                                              ),
                                                            )
                                                          : CircleAvatar(
                                                              backgroundColor:
                                                                  Colors.grey,
                                                              radius: 20,
                                                              child: Text(
                                                                  items[index]),
                                                            ),
                                                    ),
                                                  ),
                                                );
                                              }),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(7.0),
                                      border: Border.all(
                                          width: 2, color: buttonBorderAmber)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(widget.code,
                                        style: size27W500YellowOpacity4),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 10,
                    child: GestureDetector(
                      onTap: () {
                        FocusScope.of(context).requestFocus(FocusNode());
                        if (MyApp()
                            .controller
                            .formKey
                            .currentState
                            .validate()) {
                          MyApp().controller.formKey.currentState.save();
                          if (time == "Select") {
                            Get.snackbar(
                                "Error", "Time is empty,Please select time");
                          } else {
                            reserveFamilyRequest();
                          }
                        }
                      },
                      child: Container(
                        margin: EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.0),
                          gradient: customLinearGradient(),
                        ),
                        child: Center(
                          child: Text(
                            "Reservation  Request",
                            style: size25BlackW500,
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
    );
  }

  void reserveFamilyRequest() {
    MyApp().controller.handleSubmit(context);
    MyApp().controller.mackFamilyRequest(
        widget.index,
        _name.text.capitalizeFirstOfEach,
        _mobile.text,
        persons,
        widget.date,
        time,
        widget.code);
  }

  TimeOfDay _time = TimeOfDay.now();
  String time = "Select";

  void onOpenTimeChanged(TimeOfDay newTime) {
    setState(() {
      time = newTime.format(context).toString();
    });
  }
}
