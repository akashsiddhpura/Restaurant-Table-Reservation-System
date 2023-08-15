import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';
import 'package:reserved_table/Constance/Colors.dart';
import 'package:reserved_table/Constance/Styles.dart';
import 'package:reserved_table/Widgets/Widgets.dart';
import 'package:reserved_table/main.dart';

class RattingPage extends StatefulWidget {
  @override
  _RattingPageState createState() => _RattingPageState();
}

class _RattingPageState extends State<RattingPage> {

  var rattingReference = FirebaseFirestore.instance
      .collection("Users")
      .doc(MyApp().controller.userModel.key1)
      .collection("Ratting");


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar("Ratting"),
      body: Container(
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
                        child: customCircularProcess()));
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
                                        horizontal: 7, vertical: 7),
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
                                    padding: const EdgeInsets.only(
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
                                              overflow: TextOverflow
                                                  .ellipsis,
                                            ),
                                            SizedBox(height: 5),
                                            userRatting == 0.5
                                                ? rate05()
                                                : userRatting == 1.0
                                                ? rate1()
                                                : userRatting == 1.5
                                                ? rate15()
                                                : userRatting == 2.0
                                                ? rate2()
                                                : userRatting == 2.5
                                                ? rate25()
                                                : userRatting == 3.0
                                                ? rate3()
                                                : userRatting == 3.5
                                                ? rate35()
                                                : userRatting == 4.0
                                                ? rate4()
                                                :  userRatting == 4.5
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
                                  flex:230,
                                  child: Container(),),
                                Expanded(
                                  flex:1000,
                                  child: Container(
                                    padding: EdgeInsets.only(left: 15),
                                    child: ReadMoreText(
                                      userDescription,
                                      colorClickableText: rattingMore,
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
    );
  }
}
