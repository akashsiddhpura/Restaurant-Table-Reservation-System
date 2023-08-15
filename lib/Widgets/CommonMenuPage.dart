import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:reserved_table/Constance/Colors.dart';
import 'package:reserved_table/Constance/Styles.dart';
import 'package:reserved_table/Widgets/Widgets.dart';
import 'package:reserved_table/main.dart';

class CommonMenuPage extends StatefulWidget {

  final CollectionReference menuReference;
  final String keyHotelForUserSide;
  CommonMenuPage({this.menuReference,this.keyHotelForUserSide});

  @override
  _CommonMenuPageState createState() => _CommonMenuPageState();
}

class _CommonMenuPageState extends State<CommonMenuPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar("Menu"),
      body: Container(
        child: StreamBuilder<QuerySnapshot>(
          stream: widget.menuReference.snapshots(),
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
                    var categoryName = snapshot
                        .data.docs[index]["CategoryName"]
                        .toString();
                    var categoryImage =
                    snapshot.data.docs[index]["CategoryImage"];
                    var keyHotel = MyApp().controller.userModel.key1;
                    return   Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: double.infinity,
                            margin: EdgeInsets.only(top: 20,left: 10,right: 10),
                            decoration: BoxDecoration(
                                color: containerBackGround,
                                borderRadius: borderRadius(
                                  20.0,
                                  20.0,
                                  0,
                                  0,
                                )),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: Center(
                                child: Text(
                                  categoryName[0].toUpperCase() +
                                      categoryName.substring(1),
                                  style: size40AmberW500,
                                ),
                              ),
                            ),
                          ),
                          ItemList(
                            categoryName: categoryName,
                            categoryImage: categoryImage,
                            keyHotel: keyHotel,
                              keyHotelForUser: widget.keyHotelForUserSide)
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


class ItemList extends StatefulWidget {
  final String categoryName;
  final String categoryImage;
  final String keyHotel;
  final String keyHotelForUser;

  ItemList({this.categoryName, this.categoryImage,this.keyHotel,this.keyHotelForUser});

  @override
  _ItemListState createState() => _ItemListState();
}

class _ItemListState extends State<ItemList> {
  @override
  Widget build(BuildContext context) {
    CollectionReference menuReferenceHotelSide = FirebaseFirestore.instance
        .collection("Users")
        .doc(widget.keyHotel)
        .collection("Menu")
        .doc(widget.categoryName)
        .collection("Items");
    CollectionReference menuReferenceUserSide = FirebaseFirestore.instance
        .collection("Users")
        .doc(widget.keyHotelForUser)
        .collection("Menu")
        .doc(widget.categoryName)
        .collection("Items");
    return StreamBuilder<QuerySnapshot>(
      stream: MyApp().controller.userModel.userType == "User" ? menuReferenceUserSide.snapshots() : menuReferenceHotelSide.snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) return Text("Error : ${snapshot.error}");
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Container(child: Center(child: customCircularProcess()));
          default:
            return snapshot.data.docs.length != 0
                ? Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: NetworkImage(widget.categoryImage),
                    fit: BoxFit.cover),
                borderRadius: borderRadius(0,0,20.0,20.0),
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: borderRadius(0,0,20.0,20.0),
                ),
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (_, int index) {
                    var itemName = snapshot.data.docs[index]["ItemName"];
                    var itemPrice = snapshot.data.docs[index]["ItemPrice"];
                    var itemType = snapshot.data.docs[index]["ItemType"];
                    return Container(
                      margin: EdgeInsets.symmetric(
                          vertical: 5),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 10),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 10,
                              child: itemType != "Veg" ?
                              Container(
                                height: 20,
                                width: 20,
                                decoration: BoxDecoration(
                                    border: Border.all(width:2,color:nonVeg,)
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(3.0),
                                  child: CircleAvatar(
                                    backgroundColor: nonVeg,
                                  ),
                                ),
                              )
                                  : Container(height: 20, width: 20,),
                            ),
                            Expanded(
                                flex: 150,
                                child: Padding(
                                  padding: const EdgeInsets.only(left:8.0),
                                  child: Text(itemName, maxLines: 1,style: size25,overflow: TextOverflow.ellipsis,),
                                )),
                            Expanded(
                              flex: 50,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(itemPrice + "/-",maxLines: 1, style: size25YellowW500),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            )
                : noMoreData();
        }
      },
    );
  }
}


class ShowTableCustomerData extends StatefulWidget {
  final String keyTable;
  final String keyHotel;
  final String date;

  ShowTableCustomerData({this.keyTable, this.keyHotel, this.date});

  @override
  _ShowTableCustomerDataState createState() => _ShowTableCustomerDataState();
}

class _ShowTableCustomerDataState extends State<ShowTableCustomerData> {
  @override
  Widget build(BuildContext context) {

    var tableCustomerBothSide = FirebaseFirestore.instance
        .collection("Users")
        .doc(widget.keyHotel)
        .collection("Tables")
        .doc(widget.keyTable)
        .collection("Customer")
        .where("Date", isEqualTo: widget.date).where("FlagForDinner",isEqualTo: "0")
        .snapshots();

    return Container(
      child: StreamBuilder<QuerySnapshot>(
        stream: tableCustomerBothSide,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) return Text("Error : ${snapshot.error}");
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Container(
                  child: Center(child: customCircularProcess()));
            default:
              return snapshot.data.docs.length == 0
                  ? Center(child: Text("Empty"))
                  : ListView.builder(
                itemCount: snapshot.data.docs.length,
                itemBuilder: (_, int index) {
                  var time = snapshot.data.docs[index]["Time"];
                  var person = snapshot.data.docs[index]["TotalPerson"];
                  var name = snapshot.data.docs[index]["UserName"];
                  var dinnerStatus = snapshot.data.docs[index]["DinnerStatus"];
                  return SingleChildScrollView(
                      child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height:2.0),
                        Container(
                          width: double.infinity,
                          margin: EdgeInsets.only(left: 4.0,right: 4.0,bottom: 2.0,top: 2.0),
                          decoration: BoxDecoration(
                              color: Color(0xFF525252),
                              borderRadius: BorderRadius.circular(5.0)),
                          child: Stack(
                            children: [
                              Positioned(
                                top:5,
                                right: 5,
                                child: CircleAvatar(
                                  radius: 3.0,
                                  backgroundColor : dinnerStatus == "Start" ? Colors.green : Colors.black,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 6, horizontal: 8),
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      flex: 50,
                                      child: Text(
                                        name,
                                        style: size16,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Expanded(
                                      flex: 30,
                                      child: Text(
                                        time,
                                        style: size16,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Expanded(
                                      flex: 9,
                                      child: Row(
                                        children: [
                                          Text(
                                            person,
                                            style: size16Grey,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
          }
        },
      ),
    );
  }
}