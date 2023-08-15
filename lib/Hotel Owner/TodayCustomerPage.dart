import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reserved_table/Constance/Colors.dart';
import 'package:reserved_table/Constance/Styles.dart';
import 'package:reserved_table/Hotel%20Owner/QrCodePage.dart';
import 'package:reserved_table/Widgets/Widgets.dart';
import 'package:reserved_table/main.dart';
import 'package:search_page/search_page.dart';
import 'package:intl/intl.dart';

class TodayCustomerPage extends StatefulWidget {
  @override
  _TodayCustomerPageState createState() => _TodayCustomerPageState();
}

class _TodayCustomerPageState extends State<TodayCustomerPage> {
  double height = 150.0;

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      MyApp().controller.allCustomer();
    });
    Future.delayed(Duration.zero, () {
      searchList();
    });
    super.initState();
  }

  static List<SearchCustomers> searchCustomerListItem = [];

  searchList() {
    searchCustomerListItem.clear();
    for (int i = 0; i < MyApp().controller.customers.length; i++) {
      searchCustomerListItem.add(SearchCustomers(
        MyApp().controller.customers[i]["Key"],
        MyApp().controller.customers[i]["KeyUser"],
        MyApp().controller.customers[i]["HotelImage"],
        MyApp().controller.customers[i]["TableNumber"],
        MyApp().controller.customers[i]["UserName"],
        MyApp().controller.customers[i]["MobileNo"],
        MyApp().controller.customers[i]["TotalPerson"],
        MyApp().controller.customers[i]["Date"],
        MyApp().controller.customers[i]["Time"],
        MyApp().controller.customers[i]["FamilyRequest"],
        MyApp().controller.customers[i]["Code"],
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    var customerReference = FirebaseFirestore.instance
        .collection("Users")
        .doc(MyApp().controller.userModel.key1)
        .collection("Accepted")
        .where("DinnerStatus", isEqualTo: "Pending")
        .where("Date", isEqualTo: '${customFormat.format(selectedDate)}')
        .where("Arrived", isEqualTo: "")
        .snapshots();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          MyApp().controller.hotelModel.hotelName,
          style: size25,
        ),
        elevation: 0.0,
        backgroundColor: Color(0x00FFFFFF),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () => showSearch(
              context: context,
              delegate: SearchPage<SearchCustomers>(
                  searchLabel: 'Search Customers',
                  builder: (customer) {
                    return searchCustomer(
                        customer.keyUser,
                        customer.keyOrder,
                        customer.tableNo,
                        customer.name,
                        customer.mobileNo,
                        customer.totalPerson,
                        customer.date,
                        customer.time,
                        customer.family,
                        customer.code,
                        customer.hotelImage);
                  },
                  filter: (customer) => [
                        customer.name,
                      ],
                  suggestion: Container(
                    child: ListView.builder(
                        itemCount: searchCustomerListItem.length,
                        itemBuilder: (BuildContext context, int index) {
                          final SearchCustomers customers =
                              searchCustomerListItem[index];
                          return searchCustomer(
                            customers.keyUser,
                            customers.keyOrder,
                            customers.tableNo,
                            customers.name,
                            customers.mobileNo,
                            customers.totalPerson,
                            customers.date,
                            customers.time,
                            customers.family,
                            customers.code,
                            customers.hotelImage,
                          );
                        }),
                  ),
                  items: searchCustomerListItem,
                  failure: noMoreData()),
            ),
          ),
        ],
      ),
      drawer: customDrawer(context),
      body: Container(
        child: Column(
          children: [
            Expanded(
              flex: 5,
              child: Container(
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 300,
                      child: Center(
                        child: Text(
                          "Show By Date : ",
                          style: size25,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 200,
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
            ),
            Expanded(
              flex: 60,
              child: Container(
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
                                  var code = snapshot.data.docs[index]["Code"];
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
                                  var keyOrder =
                                      snapshot.data.docs[index]["Key"];
                                  var keyUser =
                                      snapshot.data.docs[index]["KeyUser"];
                                  return searchCustomer(
                                      keyUser,
                                      keyOrder,
                                      tableNo,
                                      name,
                                      mobile,
                                      totalPerson,
                                      date,
                                      time,
                                      family,
                                      code,
                                      hotelImage);
                                },
                              )
                            : noMoreData();
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

  DateTime selectedDate = DateTime.now();
  var customFormat = DateFormat('dd/MM/yyyy');

  Future<Null> showPicker(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2021),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  Container searchCustomer(
      String keyUser,
      String keyOrder,
      String tableNo,
      String name,
      String mobile,
      String totalPerson,
      String date,
      String time,
      String family,
      String code,
      String hotelImage) {
    return Container(
      height: height,
      margin: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      decoration: BoxDecoration(
          color: Color(0xFF424242), borderRadius: BorderRadius.circular(7.0)),
      child: Stack(
        fit: StackFit.expand,
        children: [
          ImageClipRRect(height: height, hotelImage: MyApp().controller.hotelModel.hotelImage),
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
          Container(
            height: height,
            child: GestureDetector(
              onTap: () {
                print(code);
                Get.to(() => QrCodePage(
                      code: code,
                      keyOrder: keyOrder,
                      keyUser: keyUser,
                    ),);
              },
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
  }
}

class SearchCustomers {
  final String keyOrder;
  final String keyUser;
  final String hotelImage;
  final String tableNo;
  final String name;
  final String mobileNo;
  final String totalPerson;
  final String date;
  final String time;
  final String family;
  final String code;

  SearchCustomers(
      this.keyUser,
      this.keyOrder,
      this.hotelImage,
      this.tableNo,
      this.name,
      this.mobileNo,
      this.totalPerson,
      this.date,
      this.time,
      this.family,
      this.code);
}
