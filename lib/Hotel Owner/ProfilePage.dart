import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:day_night_time_picker/lib/daynight_timepicker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:reserved_table/Constance/Colors.dart';
import 'package:reserved_table/Constance/Validators.dart';
import 'package:reserved_table/Hotel%20Owner/My%20Hotel.dart';
import 'package:reserved_table/Widgets/Widgets.dart';
import 'package:reserved_table/main.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart' as Path;
import 'package:reserved_table/Constance/Styles.dart';

class HotelProfilePage extends StatefulWidget {
  @override
  _HotelProfilePageState createState() => _HotelProfilePageState();
}

class _HotelProfilePageState extends State<HotelProfilePage> {
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

  TextEditingController _delete = new TextEditingController();

  TimeOfDay _openTime = TimeOfDay.now();
  TimeOfDay _closeTime = TimeOfDay.now();
  String openTime = MyApp().controller.hotelModel.hotelOpen;
  String closeTime = MyApp().controller.hotelModel.hotelClose;

  Future<bool> _willPopCallback() {
    return customDialog(context,"Are you sure ?","Are you sure to leave this page ?",()=>Get.offAll(HotelHomePage()),"Yes",size20Green)
        ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _willPopCallback,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Profile",style: size25B,),backgroundColor: black,centerTitle: true,
          actions: [
            MaterialButton(
              minWidth: 5,
              onPressed: () {
                FocusScope.of(context).requestFocus(FocusNode());
                if (_formKey.currentState.validate()) {
                  _formKey.currentState.save();
                  customDialog(context,"Update Detail","Are You Sure Update Profile ?",()=>uploadProfileData(),"Update",size20Green);
                } else {
                  Get.snackbar("Error",
                      "Something went wrong or miss out something.Please check and try again");
                }
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.save,
                    size: 25,
                  ),
                  Text("Save",style: size12White70,)
                ],
              ),
            )
          ],
        ),
        body: Container(
          child: Column(
            children: [
              Expanded(
                child: Container(
                  child: Stack(
                    children: [
                      Container(
                        height: 500,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            stops: [0.2, 0.9],
                            end: Alignment.bottomCenter,
                            colors: [Colors.black, Color(0x00424242)],
                          ),
                        ),
                      ),
                      Column(
                        children: [
                          Expanded(
                            flex:1000,
                            child: Container(
                              margin: EdgeInsets.symmetric(vertical: 5),
                                child: Form(
                              key: _formKey,
                              autovalidateMode: AutovalidateMode.disabled,
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Container(
                                          height: 160,
                                          width: 160,
                                          child: Card(
                                            elevation: 5,
                                            shadowColor: black,
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(15)),
                                            child: Stack(
                                              fit: StackFit.expand,
                                              children: [
                                                ClipRRect(
                                                  borderRadius: BorderRadius.circular(15.0),
                                                  child: _updateOwnerImageFile == null
                                                      ?CustomNetworkImage(image:

                                                  MyApp()
                                                      .controller
                                                      .userModel
                                                      .userImage,

                                                  )
                                                      : Image.file(
                                                    _updateOwnerImageFile,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                                Positioned(
                                                  right: 0,
                                                  bottom: 0,
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      pickOwnerUpdatedImage();
                                                    },
                                                    child: Container(
                                                      height: 40,
                                                      width: 40,
                                                      decoration: BoxDecoration(
                                                          color: Colors.black87,
                                                          borderRadius: borderRadius(7.0,0.0,15.0,0.0)),
                                                      child: Icon(Icons.camera_alt,color: iconAmber,),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                        Container(
                                          height: 160,
                                          width: 160,
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
                                                  child: _updateHotelImageFile == null
                                                      ? CustomNetworkImage( image:
                                                  MyApp()
                                                      .controller
                                                      .hotelModel
                                                      .hotelImage,

                                                  )
                                                      : Image.file(
                                                    _updateHotelImageFile,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                                Positioned(
                                                  right: 0,
                                                  bottom: 0,
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      pickHotelUpdatedImage();
                                                    },
                                                    child: Container(
                                                      height: 40,
                                                      width: 40,
                                                      decoration: BoxDecoration(
                                                          color: Colors.black87,
                                                          borderRadius: borderRadius(7.0,0.0,15.0,0.0)),
                                                      child: Icon(Icons.camera_alt,color: iconAmber,),
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
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(left: 15.0),
                                          child: Text(
                                            "Owner Info",
                                            style: size30W500Amber,
                                          ),
                                        ),
                                      ],
                                    ),
                                    buildRow2("Name", _name, "Enter name",
                                        TextInputType.text, nameValidator, 30),
                                    buildRow2(
                                        "Mobile No",
                                        _mobile,
                                        "Enter mobile number",
                                        TextInputType.phone,
                                        mobileValidator,
                                        10),
                                    Row(
                                      children: [
                                        Expanded(
                                          flex: 50,
                                          child: Container(
                                            margin: EdgeInsets.only(top: 15),
                                            child: Padding(
                                              padding: EdgeInsets.only(left: 15,bottom: 15,top: 5),
                                              child: text20(
                                                "Email",
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 100,
                                          child: Container(
                                            padding: EdgeInsets.only(bottom: 15,top: 5),
                                            margin: EdgeInsets.only(top: 15,left: 35),
                                            child: text20(
                                                MyApp().controller.userModel.userEmail
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(left: 15.0),
                                          child: Text(
                                            "Hotel Info",
                                            style: size30W500Amber,
                                          ),
                                        ),
                                      ],
                                    ),
                                    buildRow2("Name", _hotelName, "Enter name",
                                        TextInputType.text, nameValidator, 30),
                                    buildRow2(
                                        "Telephone",
                                        _hotelMobileNo,
                                        "Enter telephone number",
                                        TextInputType.phone,
                                        mobileValidator,
                                        10),
                                    buildRow2("Email", _hotelEmail, "Enter email",
                                        TextInputType.text, emailValidator, 50),
                                    buildRow2("Address", _hotelAddress, "Enter address",
                                        TextInputType.text, addressValidator, 80),
                                    buildRow2("PinCode", _hotelPinCode, "Enter pincode",
                                        TextInputType.number, pinCodeValidator, 6),
                                    Row(
                                      children: [
                                        Expanded(
                                            flex: 50,
                                            child: Container(
                                                margin: EdgeInsets.only(top: 15,bottom: 5),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(left: 15,bottom: 10,top: 5),
                                                  child: Text(
                                                    "Open At",
                                                    style: size20,
                                                  ),
                                                ),),),
                                        Expanded(
                                          flex: 100,
                                          child: Padding(
                                            padding: const EdgeInsets.only(left: 26),
                                            child: TextButton(
                                              onPressed: () {
                                                FocusScope.of(context).requestFocus(FocusNode());
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
                                                  Text(openTime,
                                                      style: size20),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  Icon(Icons.arrow_drop_down_sharp)
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                            flex: 50,
                                            child: Container(
                                                margin: EdgeInsets.only(top: 15,bottom: 5),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(left: 15,bottom: 10,top: 5),
                                                  child: Text(
                                                    "Close At",
                                                    style: size20,
                                                  ),
                                                ),),),
                                        Expanded(
                                          flex: 100,
                                          child: Padding(
                                            padding: const EdgeInsets.only(left: 26),
                                            child: TextButton(
                                              onPressed: () {
                                                FocusScope.of(context).requestFocus(FocusNode());
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
                                                  Text(closeTime,
                                                      style: size20),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  Icon(Icons.arrow_drop_down_sharp)
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    buildRow2(
                                        "Tables",
                                        _hotelTotalTables,
                                        "Enter total tables",
                                        TextInputType.number,
                                        tableValidator,
                                        2),
                                    buildRow2(
                                        "Capacity",
                                        _hotelPersonCapacity,
                                        "Enter capacity at a time",
                                        TextInputType.number,
                                        capacityValidator,
                                        3),
                                    GestureDetector(
                                      onTap: () {
                                        FocusScope.of(context).requestFocus(FocusNode());
                                        deleteDialog(context);
                                      },
                                      child: Container(
                                        height: 60,
                                        margin: EdgeInsets.all(10.0),
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(5.0),
                                            color: Colors.redAccent),
                                        child: Center(
                                          child: Text(
                                            "Delete",
                                            style: TextStyle(fontSize: 25),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),),
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
  File _updateOwnerImageFile;
  File _updateHotelImageFile;
  String updateOwnerImageUrl = "";
  String updateHotelImageUrl = "";

  Future pickOwnerUpdatedImage() async {
    final pickedOwnerUpdatedFile =
        await picker.getImage(source: ImageSource.gallery,imageQuality: 50);
    setState(() {
      _updateOwnerImageFile = File(pickedOwnerUpdatedFile.path);
    });
    print(_updateOwnerImageFile.toString());
  }

  Future pickHotelUpdatedImage() async {
    final pickedHotelUpdatedFile =
        await picker.getImage(source: ImageSource.gallery,imageQuality: 50);
    setState(() {
      _updateHotelImageFile = File(pickedHotelUpdatedFile.path);
    });
    print(_updateHotelImageFile.toString());
  }

  Future uploadProfileData() async {
    MyApp().controller.handleSubmit(context);
    if (_updateOwnerImageFile == null && _updateHotelImageFile == null) {
      saveProfileData();
    } else if (_updateOwnerImageFile != null && _updateHotelImageFile == null) {
      ref = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('images/${Path.basename(_updateOwnerImageFile.path)}');
      await ref.putFile(_updateOwnerImageFile).whenComplete(() async {
        await ref.getDownloadURL().then((value) {
          print('Url is => ' + value);
          setState(() {
            updateOwnerImageUrl = value;
          });
        }).catchError((onError) {
          Get.snackbar("Error while Update Profile ", onError.message);
        });
      }).catchError((onError) {
        Get.snackbar("Error while Update Profile ", onError.message);
      });
      saveProfileData();
    } else if (_updateHotelImageFile != null && _updateOwnerImageFile == null) {
      ref = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('images/${Path.basename(_updateHotelImageFile.path)}');
      await ref.putFile(_updateHotelImageFile).whenComplete(() async {
        await ref.getDownloadURL().then((value) {
          print('Url is => ' + value);
          setState(() {
            updateHotelImageUrl = value;
          });
        }).catchError((onError) {
          Get.snackbar("Error while Update Profile ", onError.message);
        });
      }).catchError((onError) {
        Get.snackbar("Error while Update Profile ", onError.message);
      });
      saveProfileData();
    } else if (_updateOwnerImageFile != null && _updateHotelImageFile != null) {
      ref = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('images/${Path.basename(_updateOwnerImageFile.path)}');
      await ref.putFile(_updateOwnerImageFile).whenComplete(() async {
        await ref.getDownloadURL().then((value) {
          print('Url is => ' + value);
          setState(() {
            updateOwnerImageUrl = value;
          });
        }).catchError((onError) {
          Get.snackbar("Error while Update Profile ", onError.message);
        });
      }).catchError((onError) {
        Get.snackbar("Error while Update Profile ", onError.message);
      });
      ref = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('images/${Path.basename(_updateHotelImageFile.path)}');
      await ref.putFile(_updateHotelImageFile).whenComplete(() async {
        await ref.getDownloadURL().then((value) {
          print('Url is => ' + value);
          setState(() {
            updateHotelImageUrl = value;
          });
        }).catchError((onError) {
          Get.snackbar("Error while Update Profile ", onError.message);
        });
      }).catchError((onError) {
        Get.snackbar("Error while Update Profile ", onError.message);
      });
      saveProfileData();
    }
  }

  void saveProfileData() {
    MyApp().controller.updateOwnerHotelData(
          MyApp().controller.userModel.key1,
          updateOwnerImageUrl,
          _name.text.capitalizeFirstOfEach,
          _mobile.text,
          MyApp().controller.userModel.userEmail,
          updateHotelImageUrl,
          _hotelName.text.capitalizeFirstOfEach,
          _hotelMobileNo.text,
          _hotelEmail.text,
          _hotelAddress.text.capitalizeFirstOfEach,
          _hotelPinCode.text,
          openTime,
          closeTime,
        );
  }

  Future<void> deleteDialog(BuildContext context) {
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8.0))),
            title: Text("Delete Account"),
            content: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Are You Sure To Delete Your Account or Hotel?"),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    MyApp().controller.userModel.userEmail,
                    style: TextStyle(fontSize: 20, color: Colors.blueAccent),
                  ),
                  TextField(
                    controller: _delete,
                    decoration:
                        InputDecoration(hintText: "Enter above email here"),
                  ),
                ],
              ),
            ),
            actions: [
              MaterialButton(
                  onPressed: () {
                    Get.back();
                  },
                  child: Text("Cancel")),
              MaterialButton(
                  onPressed: () {
                    if (_delete.text ==
                        MyApp().controller.userModel.userEmail) {
                      deleteAccount();
                    } else {
                      Get.snackbar("Opps", "Enter Given Email Properly.");
                    }
                  },
                  child: Text("Delete")),
            ],
          );
        });
  }

  void deleteAccount() {
    MyApp().controller.handleSubmit(context);
    FirebaseFirestore.instance
        .collection('Users').where("Key",isEqualTo: MyApp().controller.userModel.key1).get().then((QuerySnapshot value2) {
      MyApp().controller.deleteUserAccount(value2.docs.elementAt(0).data()["UserEmail"],value2.docs.elementAt(0).data()["UserPassword"]);
    }).catchError((onError){});

  }
}
