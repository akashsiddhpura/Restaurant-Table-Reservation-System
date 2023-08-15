import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reserved_table/Admin/RequestDetailPage.dart';
import 'package:reserved_table/Constance/Strings.dart';
import 'package:reserved_table/Constance/Styles.dart';
import 'package:reserved_table/Widgets/Widgets.dart';
import 'package:reserved_table/main.dart';

class RejectedHotelListPage extends StatefulWidget {
  @override
  _RejectedHotelListPageState createState() => _RejectedHotelListPageState();
}

class _RejectedHotelListPageState extends State<RejectedHotelListPage> {

  double height = 150.0;

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
                  stream: MyApp().controller.ownerRejectedReference.snapshots(),
                  builder:
                      (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) return Text("Error : ${snapshot.error}");
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return Container(child: Center(child: customCircularProcess()));
                      default:
                        return snapshot.data.docs.length != 0 ? ListView.builder(
                          itemCount: snapshot.data.docs.length,
                          itemBuilder: (_, int index) {
                            var hotelAddress = snapshot.data.docs[index]["HotelAddress"];
                            var hotelName = snapshot.data.docs[index]["HotelName"];
                            var hotelImage = snapshot.data.docs[index]["HotelImage"];
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

                                  Positioned(
                                    top: 5,
                                    right: 5,
                                    child: Container(
                                      height: 60,
                                      width: 60,
                                      decoration: BoxDecoration(
                                          boxShadow: [BoxShadow(
                                              color: Colors.black,
                                              blurRadius: 80.0,spreadRadius: 27.0
                                          )]
                                      ),
                                      child: Image.asset(rejectedImage,
                                          fit: BoxFit.cover),
                                    ),
                                  ),
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
                                                  child: Image.asset(
                                                      hotelIcon,
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
                                        SizedBox(),
                                      ],
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Get.to(()=>RequestInDetailPage(
                                          snapshot: snapshot, index: index));
                                    },
                                    child: Container(
                                      height: height,
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
            ),
          ],
        ),
      ),
    );
  }

}
