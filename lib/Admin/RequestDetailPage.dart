import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';
import 'package:reserved_table/Constance/Strings.dart';
import 'package:reserved_table/Widgets/Widgets.dart';

class RequestInDetailPage extends StatefulWidget {
  final int index;
  final AsyncSnapshot<QuerySnapshot> snapshot;

  RequestInDetailPage({this.snapshot, this.index});

  @override
  _RequestInDetailPageState createState() => _RequestInDetailPageState();
}

class _RequestInDetailPageState extends State<RequestInDetailPage> {
  int _current = 0;

  @override
  Widget build(BuildContext context) {
    List l =[
      widget.snapshot.data.docs[widget.index]
      ["UserImage"],
      widget.snapshot.data.docs[widget.index]
      ["UserProofImage"],
      widget.snapshot.data.docs[widget.index]
      ["HotelImage"]
    ];
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).padding.top,
            ),
            Container(
              height: MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top,
              child: SingleChildScrollView(
                child: Stack(
                  children: [
                    Column(
                      children: [
                        Container(
                          height: 300,
                          margin: EdgeInsets.only(left: 5, right: 5),
                          decoration: BoxDecoration(
                              color: Color(0xFF424242),
                              borderRadius: BorderRadius.circular(7.0)),
                          child: Builder(
                            builder: (context) {
                              return Column(
                                children: [
                                  CarouselSlider(
                                    options: CarouselOptions(
                                        enlargeCenterPage: true,
                                        autoPlayInterval: Duration(seconds: 2),
                                        aspectRatio: 1.6,
                                        autoPlayAnimationDuration:
                                            Duration(milliseconds: 2000),
                                        scrollDirection: Axis.horizontal,
                                        onPageChanged: (index, reason) {
                                          setState(() {
                                            _current = index;
                                          });
                                        }),
                                    items: l
                                        .map((item) => Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 30.0, bottom: 30.0),
                                              child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(10.0),
                                                  child: GestureDetector(
                                                    onTap:(){
                                                      print("sd");
                                                      Get.to(()=>FullImagePage(index: widget.index,indexOfImage: l.indexOf(item),snapshot: widget.snapshot,));
                                                    },
                                                    child: CustomNetworkImage(image:
                                                      item,
                                                    ),
                                                  ),),
                                            ),)
                                        .toList(),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: l.map((url) {
                                      int index = l.indexOf(url);
                                      return Container(
                                        width: 8.0,
                                        height: 8.0,
                                        margin: EdgeInsets.symmetric(
                                            vertical: 5.0, horizontal: 2.0),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: _current == index
                                              ? Color(0xFFc7bfbf)
                                              : Color(0x80969393),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        widget.snapshot.data.docs[widget.index]
                                    ["HotelRequestStatus"] ==
                                "Rejected"
                            ? Container(
                                height: 70,
                                decoration: BoxDecoration(
                                    color: Colors.red.withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(7.0)),
                                margin: EdgeInsets.all(5.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 5,
                                      child: Container(
                                        child: Padding(
                                          padding: const EdgeInsets.only(left: 15),
                                          child: Text(
                                            "Reason",
                                            style: TextStyle(fontSize: 18),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 10,
                                      child: Container(
                                        child: SingleChildScrollView(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                widget.snapshot.data
                                                        .docs[widget.index]
                                                    ["HotelRequestRejectReason"],
                                                style: TextStyle(fontSize: 18),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : Container(
                                height: 0,
                              ),
                        SizedBox(
                          height: 10,
                        ),
                        Text("Owner Detail",
                            style: TextStyle(
                                fontSize: 25,
                                color: Colors.green,
                                fontWeight: FontWeight.w500)),
                        buildRow("Name",
                            widget.snapshot.data.docs[widget.index]["UserName"]),
                        buildRow("Email",
                            widget.snapshot.data.docs[widget.index]["UserEmail"]),
                        buildRow("Mobile",
                            widget.snapshot.data.docs[widget.index]["UserMobileNo"]),
                        SizedBox(height: 10),
                        Text("Hotel Detail",
                            style: TextStyle(
                                fontSize: 25,
                                color: Colors.green,
                                fontWeight: FontWeight.w500)),
                        buildRow("Name",
                            widget.snapshot.data.docs[widget.index]["HotelName"]),
                        buildRow(
                            "Telephone",
                            widget.snapshot.data.docs[widget.index]
                                ["HotelTelephoneNo"]),
                        buildRow("Email",
                            widget.snapshot.data.docs[widget.index]["HotelEmail"]),
                        buildRow("Address",
                            widget.snapshot.data.docs[widget.index]["HotelAddress"]),
                        buildRow("PinCode",
                            widget.snapshot.data.docs[widget.index]["HotelPinCode"]),
                        buildRow(
                            "Capacity",
                            widget.snapshot.data.docs[widget.index]
                                ["HotelPersonsCapacity"]),
                        buildRow(
                            "Tables",
                            widget.snapshot.data.docs[widget.index]
                                ["HotelTotalNumbersOfTables"]),
                        buildRow("Opening",
                            widget.snapshot.data.docs[widget.index]["HotelOpenTime"]),
                        buildRow(
                            "Closing",
                            widget.snapshot.data.docs[widget.index]
                                ["HotelCloseTime"]),
                      ],
                    ),
                    Positioned(
                      top: 275,
                      right: 5,
                      child: Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(),
                        child: widget.snapshot.data.docs[widget.index]
                                    ["HotelRequestStatus"] ==
                                "Rejected"
                            ? Image.asset(rejectedImage, fit: BoxFit.cover)
                            : widget.snapshot.data.docs[widget.index]
                                        ["HotelRequestStatus"] ==
                                    "Accepted"
                                ? Image.asset(approvalImage, fit: BoxFit.cover)
                                : Container(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}




class FullImagePage extends StatefulWidget {

  final int index;
  final int indexOfImage;

  final AsyncSnapshot<QuerySnapshot> snapshot;

  FullImagePage({this.snapshot,this.indexOfImage, this.index});

  @override
  _FullImagePageState createState() => _FullImagePageState();
}

class _FullImagePageState extends State<FullImagePage> {
  List l;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.indexOfImage);
    l = [
      widget.snapshot.data.docs[widget.index]
      ["UserImage"],
      widget.snapshot.data.docs[widget.index]
      ["UserProofImage"],
      widget.snapshot.data.docs[widget.index]
      ["HotelImage"]
    ];
  }


  @override
  Widget build(BuildContext context) {
    int current = widget.indexOfImage;
    final double height = MediaQuery.of(context).size.height;

    return Scaffold(
      body:Container(
        child:  CarouselSlider.builder(
          itemCount: l.length,
          options: CarouselOptions(
              height: height,
              enlargeCenterPage: false,viewportFraction: 1.0,
              initialPage: widget.indexOfImage,
              autoPlayInterval: Duration(seconds: 2),
              autoPlayAnimationDuration: Duration(milliseconds: 2000),
              scrollDirection: Axis.horizontal,
              onPageChanged: (index, reason) {
                setState(() {
                  current = index;
                  print(current);
                });
              }
          ),
          itemBuilder: (context, index,i) {
            return PhotoView(
              imageProvider: NetworkImage(l[index]),loadingBuilder: (BuildContext context,
                ImageChunkEvent loadingProgress){
              return shimmerEffect();
            },
            );
          },
        )
      )
    );
  }
}
