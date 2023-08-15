import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:reserved_table/Constance/Styles.dart';
import 'package:reserved_table/Widgets/Widgets.dart';
import 'package:reserved_table/main.dart';


class NotArriveCustomerPage extends StatefulWidget {
  @override
  _NotArriveCustomerPageState createState() => _NotArriveCustomerPageState();
}

class _NotArriveCustomerPageState extends State<NotArriveCustomerPage> {
  double height = 150.0;
  var customerReference = FirebaseFirestore.instance
      .collection("Users")
      .doc(MyApp().controller.userModel.key1)
      .collection("NotArrive")
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: StreamBuilder<QuerySnapshot>(
          stream: customerReference,
          builder: (BuildContext context,
              AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError)
              return Text("Error : ${snapshot.error}");
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return Container(
                    child: Center(child: customCircularProcess()));
              default:
                return snapshot.data.docs.length != 0
                    ? ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (_, int index) {
                    var date = snapshot.data.docs[index]["Date"];
                    var time = snapshot.data.docs[index]["Time"];
                    var mobile =
                    snapshot.data.docs[index]["MobileNo"];
                    var tableNo =
                    snapshot.data.docs[index]["TableNumber"];
                    var totalPerson =
                    snapshot.data.docs[index]["TotalPerson"];
                    var name =
                    snapshot.data.docs[index]["UserName"];
                    var family = snapshot.data.docs[index]
                    ["FamilyRequest"];
                    var hotelImage =
                        MyApp().controller.hotelModel.hotelImage;
                    return Container(
                      height: height,
                      margin: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                      decoration: BoxDecoration(
                          color: Color(0xFF424242), borderRadius: BorderRadius.circular(7.0)),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          ImageClipRRect(height: height, hotelImage: hotelImage),
                          GradientClipRRect(),
                          Positioned(
                            right: 0,
                            top: 0,
                            child: Container(
                              height: 60,
                              width: 120,
                              decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.7),
                                  borderRadius: borderRadius(0, 7, 0, 7)),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    time,
                                    style: size18,
                                  ),
                                  Text(
                                    date,
                                    style: size18,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            height: height,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: Container(
                                    margin: EdgeInsets.only(left: 20.0, top: 5),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          flex: 2,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 5.0),
                                            child: RichText(
                                              text: TextSpan(children: [
                                                TextSpan(
                                                  text: "Table No : ",
                                                  style: size30W500Grey,
                                                ),
                                                TextSpan(
                                                  text: tableNo,
                                                  style: size30W500Cyan,
                                                ),
                                              ]),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 5,
                                          child: SingleChildScrollView(
                                            child: Column(
                                              children: [
                                                requestData("Name : ", name),
                                                requestData("Mobile No : ", mobile),
                                                requestData("Total Person : ", totalPerson),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          family == "Yes"
                              ? Positioned(
                            right: 0,
                            bottom: 0,
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.6),
                                  borderRadius: borderRadius(7, 0, 7, 0)),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                child: Text(
                                  "In Family",
                                  style: size30W500Amber,
                                ),
                              ),
                            ),
                          )
                              : Container()
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
