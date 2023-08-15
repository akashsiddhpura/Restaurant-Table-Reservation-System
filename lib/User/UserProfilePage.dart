import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:reserved_table/Constance/Colors.dart';
import 'package:reserved_table/Constance/Styles.dart';
import 'package:reserved_table/Constance/Validators.dart';
import 'package:reserved_table/Widgets/Widgets.dart';
import 'package:reserved_table/main.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart' as Path;

class UserProfilePage extends StatefulWidget {
  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  Widget _simplePopup() => PopupMenuButton<int>(
        child: Padding(
          padding: const EdgeInsets.only(right: 20, left: 20),
          child: Icon(Icons.settings, size: 22),
        ),
        onSelected: (val) {
          if (val == 1) {
            customDialog(context, "Logout ?", "Are you sure to logout ?",
                () => logOut(), "Yes", size20Green);
          } else {
            deleteDialog(context);
          }
        },
        itemBuilder: (context) => [
          PopupMenuItem(
            value: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  "Logout",
                  style: size20,
                ),
                SizedBox(width: 10),
                Icon(Icons.logout)
              ],
            ),
          ),
          PopupMenuItem(
            value: 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  "Delete",
                  style: size20,
                ),
                SizedBox(width: 10),
                Icon(Icons.delete)
              ],
            ),
          ),
        ],
      );

  firebase_storage.Reference ref;

  final _formKey = GlobalKey<FormState>();

  TextEditingController _name = TextEditingController()
    ..text = MyApp().controller.userModel.userName;
  TextEditingController _mobile = TextEditingController()
    ..text = MyApp().controller.userModel.userMobileNo;
  TextEditingController _delete = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomPadding: false,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Profile", style: size25),
        elevation: 3.0,
        shadowColor: Colors.black,
        backgroundColor: Colors.black,
        centerTitle: true,
        actions: [_simplePopup()],
      ),
      body: Container(
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
                  child: Container(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Expanded(
                            flex: 5,
                            child: Container(
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    Container(
                                      margin:
                                          EdgeInsets.symmetric(vertical: 30),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Stack(
                                            children: [
                                              Container(
                                                height: 150,
                                                width: 150,
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          100.0),
                                                  child: _updateImageFile ==
                                                          null
                                                      ? CustomNetworkImage(
                                                          image: MyApp()
                                                              .controller
                                                              .userModel
                                                              .userImage)
                                                      : Image.file(
                                                          _updateImageFile,
                                                          fit: BoxFit.cover),
                                                ),
                                              ),
                                              Positioned(
                                                  bottom: 5,
                                                  right: 5,
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      FocusScope.of(context)
                                                          .requestFocus(
                                                              FocusNode());
                                                      pickUpdatedImage();
                                                    },
                                                    child: CircleAvatar(
                                                      backgroundColor:
                                                          Color(0xFF424242),
                                                      child: Icon(
                                                        Icons.camera_alt,
                                                        color: iconAmber,
                                                        size: 23,
                                                      ),
                                                    ),
                                                  )),
                                            ],
                                          ),
                                        ],
                                      ),
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
                                              padding: const EdgeInsets.only(
                                                  left: 15),
                                              child: text20(
                                                "Email",
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 100,
                                          child: Container(
                                            margin: EdgeInsets.only(
                                                top: 15, left: 35),
                                            child: text20(MyApp()
                                                .controller
                                                .userModel
                                                .userEmail),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
            Positioned(
              top: 15,
              right: 0,
              child: MaterialButton(
                minWidth: 5,
                onPressed: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                  if (_formKey.currentState.validate()) {
                    _formKey.currentState.save();
                    FocusScope.of(context).requestFocus(FocusNode());
                    customDialog(
                        context,
                        "Update Detail ?",
                        "Are you sure update profile ?",
                        () => uploadFile(),
                        "Update",
                        size20Green);
                  } else {
                    Get.snackbar("Error",
                        "Something went wrong or miss out something.Please check and try again");
                  }
                },
                child: Column(
                  children: [
                    Icon(
                      Icons.save,
                      size: 25,
                    ),
                    Text(
                      "Save",
                      style: size14White70,
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
                children: [
                  Text("Are You Sure To Delete Your Account ?"),
                  SizedBox(
                    height: 20,
                  ),
                  Text(MyApp().controller.userModel.userEmail),
                  TextField(
                    controller: _delete,
                    decoration:
                        InputDecoration(hintText: "Enter Above Email Here"),
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
                  child: Text(
                    "Delete",
                    style: size20Red,
                  )),
            ],
          );
        });
  }

  final picker = ImagePicker();
  File _updateImageFile;
  String updateImageUrl = "";

  Future pickUpdatedImage() async {
    final pickedUpdatedFile =
        await picker.getImage(source: ImageSource.gallery, imageQuality: 50);
    setState(() {
      _updateImageFile = File(pickedUpdatedFile.path);
    });
    print(_updateImageFile.toString());
  }

  Future uploadFile() async {
    Get.back();
    MyApp().controller.handleSubmit(context);
    if (_updateImageFile == null) {
      saveProfile();
    } else {
      ref = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('images/${Path.basename(_updateImageFile.path)}');
      await ref.putFile(_updateImageFile).whenComplete(() async {
        await ref.getDownloadURL().then((value) {
          print('Url is => ' + value);
          setState(() {
            updateImageUrl = value;
          });
        }).catchError((onError) {
          Get.snackbar("Error while Update Profile ", onError.message);
        });
      }).catchError((onError) {
        Get.snackbar("Error while Update Profile ", onError.message);
      });
      saveProfile();
    }
  }

  void saveProfile() {
    MyApp().controller.updateUserData(
        _name.text.capitalizeFirstOfEach,
        _mobile.text,
        MyApp().controller.userModel.key1,
        MyApp().controller.userModel.userEmail,
        updateImageUrl);
  }

  void deleteAccount() {
    MyApp().controller.handleSubmit(context);
    MyApp().controller.deleteUserAccount(MyApp().controller.userModel.userEmail,
        MyApp().controller.userModel.userPassword);
  }

  void logOut() {
    MyApp().controller.signOut();
  }
}
