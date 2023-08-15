import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:day_night_time_picker/lib/daynight_timepicker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:get/get.dart';
import 'package:path/path.dart' as Path;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:reserved_table/Constance/Styles.dart';
import 'package:reserved_table/Constance/Validators.dart';
import 'package:reserved_table/GetX/Shared%20Preferences.dart';
import 'package:reserved_table/Widgets/Widgets.dart';
import 'package:reserved_table/main.dart';


class ChangeOwnerDataPage extends StatefulWidget {
  @override
  _ChangeOwnerDataPageState createState() => _ChangeOwnerDataPageState();
}

class _ChangeOwnerDataPageState extends State<ChangeOwnerDataPage> {

  firebase_storage.Reference ref;

  final _formKey = GlobalKey<FormState>();

  TextEditingController _name = new TextEditingController()
    ..text = MyApp().controller.userModel.userName;
  TextEditingController _mobile = new TextEditingController()
    ..text = MyApp().controller.userModel.userMobileNo;
  TextEditingController _hotelName = new TextEditingController()
    ..text = MyApp().controller.hotelModel.hotelName;
  TextEditingController _hotelEmail = new TextEditingController()
    ..text = MyApp().controller.hotelModel.hotelEmail;
  TextEditingController _hotelMobileNo = new TextEditingController()
    ..text = MyApp().controller.hotelModel.hotelMobileNo;
  TextEditingController _hotelAddress = new TextEditingController()
    ..text = MyApp().controller.hotelModel.hotelAddress;
  TextEditingController _hotelPersonCapacity = new TextEditingController()
    ..text = MyApp().controller.hotelModel.hotelCapacity;
  TextEditingController _hotelTotalTables = new TextEditingController()
    ..text = MyApp().controller.hotelModel.hotelTables;
  TextEditingController _hotelPinCode = new TextEditingController()
    ..text = MyApp().controller.hotelModel.hotelPinCode;


  TimeOfDay _openTime = TimeOfDay.now();
  TimeOfDay _closeTime = TimeOfDay.now();
  String openTime = MyApp().controller.hotelModel.hotelOpen;
  String closeTime = MyApp().controller.hotelModel.hotelClose;



  String reRequested = "Yes";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.disabled,
          child: ListView(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    height: 130,
                    width: 130,
                    child: Card(
                      elevation: 5,
                      shadowColor: Colors.black,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(15.0),
                            child: _imageOwnerFile == null
                                ? CustomNetworkImage(image: MyApp().controller.userModel.userImage)
                                : Image.file(
                              _imageOwnerFile,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            right: 0,
                            bottom: 0,
                            child: GestureDetector(
                              onTap: pickOwnerImage,
                              child: Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                    color: Colors.black87,
                                    borderRadius: borderRadius(10.0,0,15.0,0)),
                                child: Icon(Icons.camera_alt),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
                    height: 130,
                    width: 130,
                    child: Card(
                      elevation: 5,
                      shadowColor: Colors.black,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(15.0),
                            child: _imageHotelFile == null
                                ? CustomNetworkImage(image: MyApp().controller.hotelModel.hotelImage)
                                : Image.file(
                              _imageHotelFile,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            right: 0,
                            bottom: 0,
                            child: GestureDetector(
                              onTap: pickHotelImage,
                              child: Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                    color: Colors.black87,
                                    borderRadius: borderRadius(10.0,0,15.0,0)),
                                child: Icon(Icons.camera_alt),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
                    height: 130,
                    width: 130,
                    child: Card(
                      elevation: 5,
                      shadowColor: Colors.black,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(15.0),
                            child: _imageProofFile == null
                                ? CustomNetworkImage(image: MyApp().controller.hotelModel.userProof)
                                : Image.file(
                              _imageProofFile,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            right: 0,
                            bottom: 0,
                            child: GestureDetector(
                              onTap: pickProofImage,
                              child: Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                    color: Colors.black87,
                                    borderRadius: borderRadius(10.0,0,15.0,0)),
                                child: Icon(Icons.camera_alt),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Center(
                child: Text(
                  "Owner Info",
                  style: size25GreenW500,
                ),
              ),
              buildRow2("Name", _name, "Enter name",TextInputType.text,nameValidator,30),
              buildRow2("Mobile No", _mobile, "Enter mobile number",TextInputType.phone,mobileValidator,10),
              SizedBox(
                height: 10,
              ),
              Center(
                child: Text(
                  "Hotel Info",
                  style: size25GreenW500,
                ),
              ),
              buildRow2("Name", _hotelName, "Enter name",TextInputType.text,nameValidator,30),
              buildRow2("Telephone", _hotelMobileNo, "Enter telephone number",TextInputType.phone,mobileValidator,10),
              buildRow2("Email", _hotelEmail, "Enter email",TextInputType.text,emailValidator,50),
              buildRow2("Address", _hotelAddress, "Enter address",TextInputType.text,addressValidator,80),
              buildRow2("PinCode", _hotelPinCode, "Enter pincode",TextInputType.number,pinCodeValidator,6),
              buildRow2("Tables", _hotelTotalTables, "Enter total tables",TextInputType.number,tableValidator,2),
              buildRow2("Capacity", _hotelPersonCapacity, "Enter capacity at a time",TextInputType.number,capacityValidator,3),
              Row(
                children: [
                  Expanded(
                      flex: 5,
                      child: Container(
                          margin: EdgeInsets.only(top: 15),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 15),
                            child: Text(
                              "Open At",
                              style: size20,
                            ),
                          ))),
                  Expanded(
                    flex: 10,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 26,top: 14),
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            showPicker(
                              context: context,
                              value: _openTime,
                              onChange: onOpenTimeChanged,
                              is24HrFormat: false,
                            ),
                          );
                        },
                        child: Row(
                          children: [
                            Text(openTime,style: size20),
                            SizedBox(
                              width: 5,
                            ),
                            Icon(Icons.arrow_drop_down_sharp)
                          ],
                        ),
                      ),
                    ),),
                ],
              ),
              Row(
                children: [
                  Expanded(
                      flex: 5,
                      child: Container(
                          margin: EdgeInsets.only(top: 15),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 15),
                            child: Text(
                              "Close At",
                              style: size20,
                            ),
                          ))),
                  Expanded(
                    flex: 10,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 26,top: 15),
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            showPicker(
                              context: context,
                              value: _closeTime,
                              onChange: onCloseTimeChanged,
                              is24HrFormat: false,
                            ),
                          );
                        },
                        child: Row(
                          children: [
                            Text(closeTime,style: size20),
                            SizedBox(
                              width: 5,
                            ),
                            Icon(Icons.arrow_drop_down_sharp)
                          ],
                        ),
                      ),
                    ),),
                ],
              ),
              SizedBox(height: 10,),
              GestureDetector(
                onTap: () {
                  updateDataDialog(context);
                },
                child: Container(
                  height: 60,
                  margin: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.0),
                      color:Colors.green
                  ),
                  child: Center(
                    child: Text(
                      "Request Again",
                      style: size25,
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

  void onOpenTimeChanged(TimeOfDay newTime) {
    setState(() {
      openTime = newTime.format(context).toString();
    });
  }

  void onCloseTimeChanged(TimeOfDay newTime) {
    setState(() {
      closeTime = newTime.format(context).toString();
    });
  }

  final picker = ImagePicker();
  File _imageOwnerFile;
  File _imageHotelFile;
  File _imageProofFile;
  String hotelOwnerImageUrl = MyApp().controller.userModel.userImage;
  String hotelImageUrl = MyApp().controller.hotelModel.hotelImage;
  String hotelOwnerProofImageUrl = MyApp().controller.hotelModel.userProof;

  Future pickOwnerImage() async {
    final pickedOwnerFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      _imageOwnerFile = File(pickedOwnerFile.path);
    });
  }

  Future pickHotelImage() async {
    final pickedHotelFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      _imageHotelFile = File(pickedHotelFile.path);
    });
  }

  Future pickProofImage() async {
    final pickedProofFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      _imageProofFile = File(pickedProofFile.path);
    });
  }


  Future<void> updateDataDialog(BuildContext context) {
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8.0))),
            title: Text("Send request"),
            content: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Are you sure to send request again ?"),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
            actions: [
              MaterialButton(
                  onPressed: () {
                    Get.back();
                  },
                  child: Text("No")),
              MaterialButton(
                  onPressed: () {
                    changeImageAndDataFile();
                  },
                  child: Text("Yes",style: size20Green)),
            ],
          );
        });
  }

  Future changeImageAndDataFile() async {
    Get.back();
    MyApp().controller.handleSubmit(context);
     if(_imageOwnerFile != null) {
      ref = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('images/${Path.basename(_imageOwnerFile.path)}');
      await ref.putFile(_imageOwnerFile).whenComplete(() async {
        await ref.getDownloadURL().then((value) {
          print('Url Owner is => ' + value);
          setState(() {
            hotelOwnerImageUrl = value;
          });
        }).catchError((onError){
          Get.snackbar("Error while Update Profile ", onError.message);
        });
      }).catchError((onError){
        Get.snackbar("Error while Update Profile ", onError.message);
      });
    }
     if(_imageHotelFile != null){
      ref = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('images/${Path.basename(_imageHotelFile.path)}');
      await ref.putFile(_imageHotelFile).whenComplete(() async {
        await ref.getDownloadURL().then((value) {
          print('Url Hotel is => ' + value);
          setState(() {
            hotelImageUrl = value;
          });
        }).catchError((onError){
          Get.snackbar("Error while Update Profile ", onError.message);
        });
      }).catchError((onError){
        Get.snackbar("Error while Update Profile ", onError.message);
      });
    }
     if(_imageProofFile != null){
      ref = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('images/${Path.basename(_imageProofFile.path)}');
      await ref.putFile(_imageProofFile).whenComplete(() async {
        await ref.getDownloadURL().then((value) {
          print('Url Proof is => ' + value);
          setState(() {
            hotelOwnerProofImageUrl = value;
          });
        }).catchError((onError){
          Get.snackbar("Error while Update Profile ", onError.message);
        });
      }).catchError((onError){
        Get.snackbar("Error while Update Profile ", onError.message);
      });
    }
    deleteAndSendRequest();
  }


  Future<void> deleteAndSendRequest() async {
    User user = MyApp().controller.auth.currentUser;
    AuthCredential credential =
    EmailAuthProvider.credential(email: MyApp().controller.userModel.userEmail, password: MyApp().controller.userModel.userPassword);
    await user.reauthenticateWithCredential(credential).then((value) {
      value.user.delete().then((value) {
        FirebaseFirestore.instance.collection("Users").doc(MyApp().controller.userModel.key1).delete();
        Preferences.clear();
        createUserAccount();
      }).catchError((onError){
        print(">>>>> >>>>"+onError.message);
      });
    });
  }

  void createUserAccount() {
    MyApp().controller.registerOwnerAccount(
        _name.text.capitalizeFirstOfEach,
        MyApp().controller.userModel.userEmail,
        _mobile.text,
        MyApp().controller.userModel.userPassword,
        MyApp().controller.userModel.userType,
        hotelOwnerImageUrl,
        hotelOwnerProofImageUrl,
        hotelImageUrl,
        _hotelName.text.capitalizeFirstOfEach,
        _hotelMobileNo.text,
        _hotelEmail.text,
        _hotelAddress.text.capitalizeFirstOfEach,
        _hotelPinCode.text,
        _hotelTotalTables.text,
        _hotelPersonCapacity.text,
        openTime,
        closeTime,
        reRequested
    );
  }


}