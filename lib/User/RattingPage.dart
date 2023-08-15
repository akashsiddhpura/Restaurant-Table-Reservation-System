import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:rating_bar/rating_bar.dart';
import 'package:readmore/readmore.dart';
import 'package:reserved_table/Constance/Colors.dart';
import 'package:reserved_table/Constance/Styles.dart';
import 'package:reserved_table/Widgets/Widgets.dart';
import 'package:reserved_table/main.dart';

class HotelRattingPage extends StatefulWidget {
  final String keyHotel;

  HotelRattingPage({this.keyHotel});

  @override
  _HotelRattingPageState createState() => _HotelRattingPageState();
}

class _HotelRattingPageState extends State<HotelRattingPage> {
  double ratting1 = 0.0;

  double ratting;
  TextEditingController descriptionRatting;
  bool updateReview = false;
  bool loaded = false;

  double sum = 0.0;
  double avg;
  double avgUpload;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserRatting();
  }

  void getUserRatting() {
    FirebaseFirestore.instance
        .collection("Users")
        .doc(widget.keyHotel)
        .collection("Ratting")
        .where("Key", isEqualTo: MyApp().controller.userModel.key1)
        .get()
        .then((QuerySnapshot value) {
      setState(() {
        updateReview = true;
        loaded = true;
        ratting = double.parse(
            value.docs.elementAt(0).data()["UserRatting"].toString());
        descriptionRatting = TextEditingController()
          ..text = value.docs.elementAt(0).data()["UserDescription"];
      });
    }).catchError((onError) {
      print("Error 1");
      setState(() {
        updateReview = false;
        loaded = true;
        ratting = 0.0;
        descriptionRatting = TextEditingController();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var rattingReference = FirebaseFirestore.instance
        .collection("Users")
        .doc(widget.keyHotel)
        .collection("Ratting");

    return Scaffold(
      // resizeToAvoidBottomPadding: false,
      resizeToAvoidBottomInset: false,
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
                    flex: 40,
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(7.0),
                        color: containerBackGround,
                      ),
                      child: Column(
                        children: [
                          Expanded(
                            flex: 14,
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Expanded(
                                    flex: 50,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Rate this hotel",
                                          style: size23W500,
                                        ),
                                        Text(
                                          "Tell others what you think",
                                          style: size16Grey,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    flex: 12,
                                    child: Container(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 5),
                                                child: GestureDetector(
                                                    onTap: () {
                                                      if (ratting == 0.0) {
                                                        Get.snackbar("Error",
                                                            "Ratting should not empty.");
                                                      } else {
                                                        if (updateReview ==
                                                            true) {
                                                          FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  "Users")
                                                              .doc(widget
                                                                  .keyHotel)
                                                              .collection(
                                                                  "Ratting")
                                                              .doc(MyApp()
                                                                  .controller
                                                                  .userModel
                                                                  .key1)
                                                              .update({
                                                            "UserRatting":
                                                                ratting
                                                                    .toString(),
                                                            "UserDescription":
                                                                descriptionRatting
                                                                    .text,
                                                          }).then((value) {
                                                            FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    "Users")
                                                                .doc(widget
                                                                    .keyHotel)
                                                                .collection(
                                                                    "Ratting")
                                                                .get()
                                                                .then(
                                                                    (QuerySnapshot
                                                                        value) {
                                                              value.docs.forEach(
                                                                  (element) {
                                                                sum = sum +
                                                                    double.parse(
                                                                        element.data()[
                                                                            "UserRatting"]);
                                                              });
                                                              avg = sum /
                                                                  value.docs
                                                                      .length;
                                                              FirebaseFirestore
                                                                  .instance
                                                                  .collection(
                                                                      "Users")
                                                                  .doc(widget
                                                                      .keyHotel)
                                                                  .update({
                                                                "HotelRatting":
                                                                    "${avg.toStringAsFixed(1)}"
                                                              }).then((value) {
                                                                FocusScope.of(
                                                                        context)
                                                                    .requestFocus(
                                                                        FocusNode());
                                                                Get.back();
                                                              }).catchError(
                                                                      (onError) {
                                                                print(
                                                                    "Error 4");
                                                                Get.snackbar(
                                                                    "Error",
                                                                    onError
                                                                        .message);
                                                              });
                                                            }).catchError(
                                                                    (onError) {
                                                              print("Error 11");
                                                              Get.snackbar(
                                                                  "Error",
                                                                  onError
                                                                      .message);
                                                            });

                                                            // FocusScope.of(context).requestFocus(FocusNode());
                                                            // Get.back();
                                                          }).catchError(
                                                                  (onError) {
                                                            print("Error 2");
                                                            Get.snackbar(
                                                                "Error",
                                                                onError
                                                                    .message);
                                                          });
                                                        } else {
                                                          uploadReview();
                                                        }
                                                      }
                                                    },
                                                    child: Text(
                                                      "Post",
                                                      style: size25B,
                                                    )),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 17,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                loaded == true
                                    ? RatingBar(
                                        initialRating: ratting,
                                        onRatingChanged: (rating) {
                                          setState(() {
                                            ratting = rating;
                                          });
                                        },
                                        filledIcon: Icons.star,
                                        emptyIcon: Icons.star_border,
                                        halfFilledIcon: Icons.star_half,
                                        isHalfAllowed: true,
                                        filledColor: Colors.amber,
                                        emptyColor:
                                            Colors.amber.withOpacity(0.7),
                                        size: 50,
                                      )
                                    : Container(),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 20,
                            child: Container(
                              margin: EdgeInsets.only(
                                  left: 10, right: 10, bottom: 10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(7.0),
                                  border: Border.all(
                                      width: 1, color: Colors.amber)),
                              child: TextFormField(
                                decoration: InputDecoration(
                                    hintText: "Description",
                                    hintStyle: size20AmberOpacity,
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 5)),
                                controller: descriptionRatting,
                                maxLines: 3,
                                style: size20Amber,
                                cursorColor: cursorColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 90,
                    child: Container(
                      child: StreamBuilder<QuerySnapshot>(
                        stream: rattingReference.snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.hasError)
                            return Text("Error : ${snapshot.error}");
                          switch (snapshot.connectionState) {
                            case ConnectionState.waiting:
                              return Container(
                                  child: Center(
                                      child: CircularProgressIndicator()));
                            default:
                              return ListView.builder(
                                itemCount: snapshot.data.docs.length,
                                itemBuilder: (_, int index) {
                                  var userImage =
                                      snapshot.data.docs[index]["UserImage"];
                                  var userName =
                                      snapshot.data.docs[index]["UserName"];
                                  var userRatting = double.parse(snapshot
                                      .data.docs[index]["UserRatting"]
                                      .toString());
                                  var userDescription = snapshot
                                      .data.docs[index]["UserDescription"];
                                  return Container(
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 2),
                                    padding: EdgeInsets.only(bottom: 5),
                                    decoration: BoxDecoration(
                                        color: Color(0xFF424242),
                                        borderRadius:
                                            BorderRadius.circular(7.0)),
                                    child: SingleChildScrollView(
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                flex: 230,
                                                child: Container(
                                                  height: 70,
                                                  width: 70,
                                                  margin: EdgeInsets.symmetric(
                                                      horizontal: 7,
                                                      vertical: 7),
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            100.0),
                                                    child: CustomNetworkImage(
                                                        image: userImage),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                flex: 1000,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 15),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceEvenly,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            userName,
                                                            style: size30W500,
                                                            maxLines: 1,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                          SizedBox(height: 5),
                                                          userRatting == 0.5
                                                              ? rate05()
                                                              : userRatting ==
                                                                      1.0
                                                                  ? rate1()
                                                                  : userRatting ==
                                                                          1.5
                                                                      ? rate15()
                                                                      : userRatting ==
                                                                              2.0
                                                                          ? rate2()
                                                                          : userRatting == 2.5
                                                                              ? rate25()
                                                                              : userRatting == 3.0
                                                                                  ? rate3()
                                                                                  : userRatting == 3.5
                                                                                      ? rate35()
                                                                                      : userRatting == 4.0
                                                                                          ? rate4()
                                                                                          : userRatting == 4.5
                                                                                              ? rate45()
                                                                                              : rate5(),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Expanded(
                                                flex: 230,
                                                child: Container(),
                                              ),
                                              Expanded(
                                                flex: 1000,
                                                child: Container(
                                                  padding:
                                                      EdgeInsets.only(left: 15),
                                                  child: ReadMoreText(
                                                    userDescription,
                                                    colorClickableText:
                                                        rattingMore,
                                                    style: size20,
                                                    trimMode: TrimMode.Line,
                                                    trimLines: 2,
                                                    trimCollapsedText: 'More',
                                                    trimExpandedText: 'Less',
                                                    moreStyle: size18Amber,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                          }
                        },
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

  void uploadReview() {
    FirebaseFirestore.instance
        .collection("Users")
        .doc(widget.keyHotel)
        .collection("Ratting")
        .doc(MyApp().controller.userModel.key1)
        .set({
      "Key": MyApp().controller.userModel.key1,
      "UserImage": MyApp().controller.userModel.userImage,
      "UserName": MyApp().controller.userModel.userName,
      "UserEmail": MyApp().controller.userModel.userEmail,
      "UserRatting": ratting.toString(),
      "UserDescription": descriptionRatting.text.capitalizeFirstOfEach,
    }).then((value) {
      FirebaseFirestore.instance
          .collection("Users")
          .doc(widget.keyHotel)
          .collection("Ratting")
          .get()
          .then((QuerySnapshot value) {
        value.docs.forEach((element) {
          sum = sum + double.parse(element.data()["UserRatting"]);
        });
        avg = sum / value.docs.length;
        FirebaseFirestore.instance
            .collection("Users")
            .doc(widget.keyHotel)
            .update({"HotelRatting": "${avg.toStringAsFixed(1)}"}).then(
                (value) {
          FocusScope.of(context).requestFocus(FocusNode());
          Get.back();
        }).catchError((onError) {
          print("Error 4");
          Get.snackbar("Error", onError.message);
        });
      }).catchError((onError) {
        print("Error 11");
        Get.snackbar("Error", onError.message);
      });
      print(">>" + avgUpload.toString());
    }).catchError((onError) {
      print("Error 3");
      Get.snackbar("Error", onError.message);
    });
  }
}
