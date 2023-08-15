import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:reserved_table/Constance/Strings.dart';
import 'package:reserved_table/Constance/Colors.dart';
import 'package:reserved_table/Constance/Styles.dart';
import 'package:reserved_table/User/SearchHotelTablesPage.dart';
import 'package:reserved_table/Widgets/Widgets.dart';
import 'package:reserved_table/main.dart';
import 'package:search_page/search_page.dart';

class SearchHotelPage extends StatefulWidget {
  @override
  _SearchHotelPageState createState() => _SearchHotelPageState();
}

class _SearchHotelPageState extends State<SearchHotelPage> {

  static List<SearchData> searchListItem = [];
  List fetchSearchList = MyApp().controller.list;
  double height = 150.0;
  var newList = [];

  Timer timer;
  String timeString;
  String timeStringWithSplit;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(
        Duration(seconds: 1), (Timer t) => searchList());
  }

  searchList() {
    FirebaseFirestore.instance
        .collection('Users')
        .where('UserType', isEqualTo: "Hotel Owner")
        .where("HotelTableCreated", isEqualTo: "Yes")
        .snapshots()
        .listen((data) {
      newList.clear();
      data.docs.forEach((doc) {
        newList.add(doc.data());
      });
      fetchSearchList = newList;
    });
    searchListItem.clear();
    for (int i = 0; i < fetchSearchList.length; i++) {
      searchListItem.add(SearchData(fetchSearchList[i]["HotelName"], i));
    }
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: appBar,
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () => showSearch(
                context: context,
                delegate: SearchPage<SearchData>(
                    searchLabel: 'Search Hotels',
                    builder: (contact){
                      String hotelImage =  MyApp().controller.list[contact.index]["HotelImage"];

                      return GestureDetector(
                        onTap: () {
                          FocusScope.of(context).requestFocus(FocusNode());
                          Get.to(() => ShowSearchHotelTablesPage(
                            index: contact.index,
                          ));
                        },
                        child: Container(
                          height: height,
                          margin: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                          decoration: BoxDecoration(
                              color: Color(0xFF424242),
                              borderRadius: BorderRadius.circular(7.0)),
                          child: Stack(
                            children: [
                              ImageClipRRect(height: height, hotelImage: hotelImage),
                              GradientClipRRect(),
                              Container(
                                height: height,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(left: 20),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            height: 35,
                                            width: 35,
                                            margin: EdgeInsets.only(right: 10),
                                            child: Image.asset(hotelIcon,
                                                fit: BoxFit.cover),
                                          ),
                                          text20(contact.hotelName),
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
                                          Container(
                                            height: 35,
                                            width: 35,
                                            margin: EdgeInsets.only(right: 10),
                                            child: Image.asset(
                                                hotelLocationIcon,
                                                fit: BoxFit.cover),
                                          ),
                                          text20(
                                            MyApp().controller.list[contact.index]["HotelAddress"]
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Positioned(
                                top: 0,
                                right: 0,
                                child: Container(
                                  width: 70,
                                  decoration: BoxDecoration(
                                      color: black,
                                      borderRadius: BorderRadius.circular(5.0)
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 7,vertical: 5),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Icon(Icons.star,size: 20,color: ratting,),
                                        Text(MyApp().controller.list[contact.index]["HotelRatting"],style: size14W500Amber,),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    filter: (contact) => [
                      contact.hotelName,
                      contact.index.toString(),
                    ],
                    suggestion: Container(
                        margin: EdgeInsets.symmetric(horizontal: 5.0),
                        child: StaggeredGridView.countBuilder(
                          crossAxisCount: 4,
                          itemCount: searchListItem.length,
                          itemBuilder: (BuildContext context, int index) {
                            final SearchData contacts = searchListItem[index];
                            return searchContainer(contacts.index);
                          },

                          staggeredTileBuilder: (int index) =>
                          new StaggeredTile.count(2, 2),
                          crossAxisSpacing: 4.0,
                          mainAxisSpacing: 4.0,
                        )
                    ),
                    items: searchListItem,
                    failure: Center(
                      child: Container(
                        child: Center(child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.emoji_emotions_outlined,size: 70,color: Colors.grey,),
                            SizedBox(height: 20,),
                            Text("No More Data",style: size30W500Grey,),
                          ],
                        )),
                      ),
                    )
                )
            ),
          )
        ],
        title: Text('Search Bar'),
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 5.0),
        child:StaggeredGridView.countBuilder(
          crossAxisCount: 4,
          itemCount: MyApp().controller.list.length,
          itemBuilder: (BuildContext context, int index) =>
              searchContainer(index),
          staggeredTileBuilder: (int index) =>
          new StaggeredTile.count(2, 2),
          crossAxisSpacing: 4.0,
          mainAxisSpacing: 4.0,
        )
      ) ,
    );
  }

  GestureDetector searchContainer(int index) {
    return GestureDetector(
              onTap: () {
                FocusScope.of(context).requestFocus(FocusNode());
                Get.to(() => ShowSearchHotelTablesPage(
                  index: index,
                ));
              },
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0)),
                child: Card(
                  elevation: 10.0,
                  shadowColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: CustomNetworkImage(image:
                          MyApp().controller.list[index]["HotelImage"]
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            stops: [0.3, 0.9],
                            colors: [
                              Colors.black.withOpacity(0.9),
                              Colors.black.withOpacity(0.3)
                            ],
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 10, right: 5),
                        child: Column(
                          children: [
                            Expanded(
                                flex:300,
                                child: Container()),
                            Expanded(
                              flex: 160,
                              child: Column(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceEvenly,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 20,
                                        child: Image.asset(
                                          hotelIcon,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      Expanded(
                                        flex: 130,
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 7),
                                          child: text20(
                                            MyApp().controller.list[index]
                                            ["HotelName"]
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 20,
                                        child: Image.asset(
                                          hotelLocationIcon,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      Expanded(
                                        flex: 130,
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 7),
                                          child: text20(
                                            MyApp().controller.list[index]
                                            ["HotelAddress"]
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: Container(
                          decoration: BoxDecoration(
                            color: black,
                            borderRadius: BorderRadius.circular(5.0)
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 7,vertical: 5),
                            child: Row(
                              children: [
                                Icon(Icons.star,size: 20,color: ratting,),
                                SizedBox(width: 5),
                                Text(MyApp().controller.list[index]["HotelRatting"],style: size14W500Amber,),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
  }
}

class SearchData {
  final String hotelName;
  final int index;

  SearchData(this.hotelName, this.index);
}
