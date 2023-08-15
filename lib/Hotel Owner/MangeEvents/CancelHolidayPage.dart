

import 'package:flutter/material.dart';
import 'package:reserved_table/Constance/Styles.dart';
import 'package:reserved_table/Widgets/Widgets.dart';
import 'package:reserved_table/main.dart';

class HolidayCancelPage extends StatefulWidget {
  @override
  _HolidayCancelPageState createState() => _HolidayCancelPageState();
}

class _HolidayCancelPageState extends State<HolidayCancelPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:customAppBar("Cancel Holiday"),
      body: Container(
        child: MyApp().controller.hotelModel.hotelHolidayDate != "" ? Column(
          children: [
            Expanded(
              flex: 10,
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          flex:3,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text("Date : ",style: size30W500Green),
                            ],
                          ),
                        ),
                        Expanded(
                          flex:5,
                          child: Text(MyApp().controller.hotelModel.hotelHolidayDate,style: size30W500Grey),
                        ),
                      ],
                    ),
                    SizedBox(height: 50,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          flex:1,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text("Reason : ",style: size30W500Green),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex:2,
                          child: Text(MyApp().controller.hotelModel.hotelHolidayReason,style: size30W500Grey),
                        ),
                      ],
                    ),
                  ],
                ),

              ),
            ),
            Expanded(
              flex: 1,
              child: GestureDetector(
                onTap: () {
                  cancelHotelHoliday();
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
                      "Cancel Holiday",
                      style: size25,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ) : noMoreData(),
      ),
    );
  }

  void cancelHotelHoliday(){
    MyApp().controller.handleSubmit(context);
    MyApp().controller.hotelHolidayCancel();
  }

}