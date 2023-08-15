import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reserved_table/GetX/Shared%20Preferences.dart';
import 'package:reserved_table/Hotel%20Owner/ChangeOwnerData.dart';
import 'package:reserved_table/Hotel%20Owner/TablesCreationPage.dart';
import 'package:reserved_table/Model/HotelModel.dart';
import 'package:reserved_table/Model/UserModel.dart';
import 'package:reserved_table/main.dart';

class StatusPageForOwner extends StatefulWidget {
  @override
  _StatusPageForOwnerState createState() => _StatusPageForOwnerState();
}

class _StatusPageForOwnerState extends State<StatusPageForOwner> {
  Widget _status(status) {
    if (status == "Pending") {
      return pending();
    } else if (status == "Rejected") {
      return rejected();
    } else if (status == "Accepted") {
      return accepted();
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: RefreshIndicator(
          onRefresh: () async {
            FirebaseFirestore.instance
                .collection('Users')
                .where('Key', isEqualTo: MyApp().controller.userModel.key1)
                .get()
                .then((QuerySnapshot value) {
              print(value.docs.elementAt(0).data());
              MyApp().controller.userModel =
                  UserModel.fromQuerySnapshot(value.docs.elementAt(0));
              MyApp().controller.hotelModel =
                  HotelModel.fromQuerySnapshot(value.docs.elementAt(0));
              Preferences.saveOwner(MyApp().controller.hotelModel);
              Preferences.saveUser(MyApp().controller.userModel);
              setState(() {});
            }).catchError((onError) {
              Get.snackbar("Error", onError.message);
            });
          },
          child: ListView(
            children: [
              _status(MyApp().controller.hotelModel.hotelRequestStatus)
            ],
          ),
        ),
      ),
    );
  }

  Widget pending() {
    return Container(
      height: MediaQuery.of(context).size.height,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Your request in ",
              style: TextStyle(fontSize: 25),
            ),
            SizedBox(
              height: 10,
            ),
            Text("Pending", style: TextStyle(fontSize: 25, color: Colors.cyan)),
            SizedBox(
              height: 100,
            ),
            Text(
              "Pull to refresh for updates",
              style: TextStyle(fontSize: 20, color: Colors.grey.shade700),
            ),
          ],
        ),
      ),
    );
  }

  Widget rejected() {
    return Container(
      height: MediaQuery.of(context).size.height,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Your request was ",
              style: TextStyle(fontSize: 25),
            ),
            SizedBox(
              height: 10,
            ),
            Text("Rejected",
                style: TextStyle(fontSize: 25, color: Colors.redAccent)),
            SizedBox(
              height: 50,
            ),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                      text: "Reason : ",
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.red.shade300)),
                  TextSpan(
                      text: MyApp()
                          .controller
                          .hotelModel
                          .hotelRequestRejectReason,
                      style: TextStyle(fontSize: 20)),
                ],
              ),
            ),
            SizedBox(
              height: 100,
            ),
            MaterialButton(
              onPressed: () {
                Get.to(() => ChangeOwnerDataPage());
              },
              child: Text("Change"),
            )
          ],
        ),
      ),
    );
  }

  Widget accepted() {
    return Container(
      height: MediaQuery.of(context).size.height,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Your request was ",
              style: TextStyle(fontSize: 25),
            ),
            SizedBox(
              height: 10,
            ),
            Text("Approved",
                style: TextStyle(fontSize: 25, color: Colors.green)),
            SizedBox(
              height: 100,
            ),
            MaterialButton(
              onPressed: () {
                Get.to(() => TableCreationPage());
              },
              child: Text("Create Tables"),
            )
          ],
        ),
      ),
    );
  }
}


