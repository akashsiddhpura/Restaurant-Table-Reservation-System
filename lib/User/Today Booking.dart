import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reserved_table/Constance/Colors.dart';
import 'package:reserved_table/Constance/Styles.dart';
import 'package:reserved_table/Widgets/Widgets.dart';
import 'package:reserved_table/main.dart';
import 'package:reserved_table/User/ScannerPage.dart';

class TodayBookings extends StatefulWidget {
  @override
  _TodayBookingsState createState() => _TodayBookingsState();
}

class _TodayBookingsState extends State<TodayBookings> {
  CollectionReference userRequestReference = FirebaseFirestore.instance
      .collection("Users")
      .doc(MyApp().controller.userModel.key1)
      .collection("Requests");

  double height = 210;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Today Booking",
          style: size25,
        ),
        elevation: 0.0,
        backgroundColor: appBar,
        centerTitle: true,
      ),
      body: Container(
        child: StreamBuilder<QuerySnapshot>(
          stream: userRequestReference.snapshots(),
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
                          var hotelName =
                              snapshot.data.docs[index]["HotelName"];
                          var hotelImage =
                              snapshot.data.docs[index]["HotelImage"];
                          var tableNo =
                              snapshot.data.docs[index]["TableNumber"];
                          var username = snapshot.data.docs[index]["UserName"];
                          var date = snapshot.data.docs[index]["Date"];
                          var time = snapshot.data.docs[index]["Time"];
                          var status =
                              snapshot.data.docs[index]["RequestStatus"];
                          var totalPerson =
                              snapshot.data.docs[index]["TotalPerson"];
                          var reason =
                              snapshot.data.docs[index]["RejectionMessage"];
                          var code = snapshot.data.docs[index]["Code"];
                          var key = snapshot.data.docs[index]["Key"];
                          var keyHotel = snapshot.data.docs[index]["KeyHotel"];
                          var keyTable = snapshot.data.docs[index]["KeyTable"];
                          var family =
                              snapshot.data.docs[index]["FamilyRequest"];
                          var arrive = snapshot.data.docs[index]["Arrived"];
                          var keyTableArray =
                              snapshot.data.docs[index]["KeyTableArray"];
                          void cancelReservation() {
                            if (status == "Pending") {
                              MyApp().controller.handleSubmit(context);
                              MyApp()
                                  .controller
                                  .cancelReservationIfPending(key, keyHotel);
                            } else {
                              MyApp().controller.handleSubmit(context);
                             MyApp()
                                .controller.
                              cancelReservationIfAccepted(
                                  key, keyHotel, keyTableArray);
                            }
                          }

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
                                ImageClipRRect(
                                    height: height, hotelImage: hotelImage),
                                GradientClipRRect(),
                                Container(
                                  height: height,
                                  margin: EdgeInsets.only(left: 20),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        flex: 9,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 5.0),
                                          child: Text(
                                            hotelName,
                                            style: size30W500Grey,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: status == "Rejected" ? 40 : 30,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            requestData("Name : ", username),
                                            requestData("Table No : ", tableNo),
                                            requestData(
                                                "Total Person : ", totalPerson),
                                            requestData("Date : ", date),
                                            requestData("Time : ", time),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: status == "Pending"
                                            ? Colors.black.withOpacity(0.7)
                                            : status == "Rejected"
                                                ? Color(0xFF821f1f)
                                                    .withOpacity(0.8)
                                                : Color(0xFF228731)
                                                    .withOpacity(0.8),
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(7.0),
                                            bottomRight: Radius.circular(7.0))),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 5),
                                      child: Text(
                                        status,
                                        style: size20,
                                      ),
                                    ),
                                  ),
                                ),
                                status == "Accepted"
                                    ? Container(
                                        height: height,
                                        margin: EdgeInsets.only(left: 20),
                                        child: GestureDetector(
                                          onTap: () {
                                            Get.to(() => ScannerPage(
                                                  index: index,
                                                  code: code,
                                                  customerKey: key,
                                                  hotelKey: keyHotel,
                                                  family: family,
                                                  tableKey: family == "Yes"
                                                      ? "NoKeyNeeded"
                                                      : keyTable,
                                                  tableNo: tableNo,
                                                ));
                                          },
                                        ),
                                      )
                                    : Container(),
                                family == "Yes"
                                    ? Positioned(
                                        top: 0,
                                        right: 0,
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: Colors.purpleAccent
                                                  .withOpacity(0.6),
                                              borderRadius:
                                                  borderRadius(0, 7, 0, 7)),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 5),
                                            child: Text(
                                              "In Family",
                                              style: size20,
                                            ),
                                          ),
                                        ),
                                      )
                                    : Container(),
                                arrive == "Not" || status == "Rejected"
                                    ? Container(
                                        height: height,
                                        decoration: BoxDecoration(
                                            color:
                                                Colors.black.withOpacity(0.7),
                                            borderRadius:
                                                BorderRadius.circular(7.0)),
                                        child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 5),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                status == "Rejected"
                                                    ? Container(
                                                        margin: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 20),
                                                        child: Text(
                                                          reason,
                                                          style: size20Amber,
                                                          maxLines: 3,
                                                        ),
                                                      )
                                                    : Container(
                                                        margin: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 20),
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceEvenly,
                                                          children: [
                                                            Text(
                                                              "Your reservation cancel by hotel.",
                                                              style:
                                                                  size20Amber,
                                                            ),
                                                            SizedBox(
                                                              height: 20,
                                                            ),
                                                            Text(
                                                              "Due to time delay.",
                                                              style:
                                                                  size20Amber,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                GestureDetector(
                                                  onTap: () async {
                                                    QuerySnapshot qs =
                                                        await userRequestReference
                                                            .get();
                                                    qs.docs[index].reference
                                                        .delete()
                                                        .then((value) {
                                                      print("delete");
                                                    }).catchError((onError) {
                                                      Get.snackbar("Error",
                                                          onError.message);
                                                    });
                                                  },
                                                  child: Container(
                                                    height: 40,
                                                    width: 100,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(7.0),
                                                        border: Border.all(
                                                            width: 2,
                                                            color: Colors.red),
                                                        color: Colors.red
                                                            .withOpacity(0.2)),
                                                    child: Center(
                                                        child: Text(
                                                      "Ok",
                                                      style: size25,
                                                    )),
                                                  ),
                                                ),
                                              ],
                                            )),
                                      )
                                    : Container(),
                                status != "Rejected" && arrive != "Not"
                                    ? Positioned(
                                        left: 0,
                                        top: 0,
                                        child: GestureDetector(
                                          onTap: () {
                                            customDialog(
                                                context,
                                                "Cancel Reservation",
                                                "Are you sure to cancel your reservation ?",
                                                () => cancelReservation(),
                                                "Confirm",
                                                size20Green);
                                          },
                                          child: Icon(
                                            Icons.close,
                                            size: 18,
                                            color: iconRed,
                                          ),
                                        ),
                                      )
                                    : Container(),
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


}


