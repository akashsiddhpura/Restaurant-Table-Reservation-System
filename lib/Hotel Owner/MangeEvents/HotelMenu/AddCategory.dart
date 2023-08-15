import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:reserved_table/Constance/Colors.dart';
import 'package:reserved_table/Constance/Styles.dart';
import 'package:reserved_table/Constance/Validators.dart';
import 'package:reserved_table/Hotel%20Owner/MangeEvents/HotelMenu/AddItemInCategory.dart';
import 'package:reserved_table/Widgets/Widgets.dart';
import 'package:reserved_table/main.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart' as Path;



class AddMenuHotelPage extends StatefulWidget {
  @override
  _AddMenuHotelPageState createState() => _AddMenuHotelPageState();
}

class _AddMenuHotelPageState extends State<AddMenuHotelPage> {
  CollectionReference menuCategoryReference = FirebaseFirestore.instance
      .collection("Users")
      .doc(MyApp().controller.userModel.key1)
      .collection("Menu");

  double height = 150.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar("Add Menu"),
      body: Container(
        child: Column(
          children: [
            Expanded(
              flex: 90,
              child: Container(
                child: StreamBuilder<QuerySnapshot>(
                  stream: menuCategoryReference.snapshots(),
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
                            ? StaggeredGridView.countBuilder(
                          crossAxisCount: 4,
                          itemCount: snapshot.data.docs.length,
                          itemBuilder: (BuildContext context, int index) {
                            var categoryImage = snapshot.data.docs[index]["CategoryImage"];
                            var name = snapshot.data.docs[index]["CategoryName"].toString();
                            var keyCategory = snapshot.data.docs[index]["Key"].toString();

                            return GestureDetector(
                              onTap: () {
                                Get.to(()=>AddItemsInCategoryPage(categoryName:name,keyCategory:keyCategory));
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.0)),
                                child: Card(
                                  elevation: 10.0,
                                  shadowColor: cardShadow,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: Stack(
                                    fit: StackFit.expand,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(8.0),
                                        child: CustomNetworkImage(image:categoryImage)
                                      ),
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          Container(
                                            height: 40,
                                            width: double.infinity,
                                            decoration:BoxDecoration(
                                                borderRadius: borderRadius(0,0,7.0,7.0),
                                                color: blackWithOpacity8
                                            ),
                                            child: Center(
                                              child: Text(
                                                name,
                                                style: size20,overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                          staggeredTileBuilder: (int index) =>
                          new StaggeredTile.count(2, 2),
                          crossAxisSpacing: 4.0,
                          mainAxisSpacing: 4.0,
                        )
                            : noMoreData();
                    }
                  },
                ),
              ),
            ),
            Expanded(
              flex: 10,
              child: GestureDetector(
                onTap: () {
                  Get.to(() => AddCategoriesPage());
                },
                child: Container(
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(7.0),
                      gradient: customLinearGradient(),
                      ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Add Category",
                        style: size25BlackW500,
                      ),
                      SizedBox(
                        width: 25,
                      ),
                      Icon(
                        Icons.add_to_photos_rounded,
                        color: iconBlack,
                        size: 30,
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AddCategoriesPage extends StatefulWidget {
  @override
  _AddCategoriesPageState createState() => _AddCategoriesPageState();
}

class _AddCategoriesPageState extends State<AddCategoriesPage> {
  TextEditingController categoryName = TextEditingController()..text = "";
  firebase_storage.Reference ref;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: ListView(
          children: [
            Container(
              height: MediaQuery.of(context).padding.top,
            ),
            Container(
              height: MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top,
              child: Column(
                children: [
                  Expanded(
                    flex: 90,
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      child: Form(
                        key: MyApp().controller.formKey,
                        child: ListView(
                          primary: false,
                          shrinkWrap: true,
                          children: [
                            Stack(
                              children: [
                                _itemImageFile == null
                                    ? ClipRRect(
                                  borderRadius: BorderRadius.circular(10.0),
                                  child: Container(
                                    height: 300,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                        color: containerBackGround),
                                    child: GestureDetector(
                                        onTap: () {
                                          FocusScope.of(context).requestFocus(FocusNode());
                                          pickItemImage();
                                        },
                                        child: Icon(
                                          Icons.add_circle_outline_outlined,
                                          size: 120,
                                          color: grey,
                                        ),),
                                  ),
                                )
                                    : Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10.0),
                                      child: Container(
                                        height: 300,
                                        width: double.infinity,
                                        child: Image.file(
                                          _itemImageFile,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 5,
                                      right: 5,
                                      child: GestureDetector(
                                        onTap: () {
                                          FocusScope.of(context).requestFocus(FocusNode());
                                          pickItemImage();
                                        },
                                        child: CircleAvatar(
                                          backgroundColor: blackWithOpacity7,
                                          radius: 30,
                                          child: Icon(
                                            Icons.camera_alt,
                                            size: 30,
                                            color: iconAmber,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  flex: 50,
                                  child: Container(
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 15),
                                      child: Text(
                                        "Name",
                                        style: size25,
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 100,
                                  child: Container(
                                    margin: EdgeInsets.only(top: 7),
                                    child: TextFormField(
                                      controller: categoryName,
                                      keyboardType: TextInputType.text,
                                      style: size25,
                                      onChanged: (val) {
                                        setState(() {
                                          present = false;
                                        });
                                      },
                                      validator: nameValidator,
                                      decoration: InputDecoration(
                                          hintText: "Enter category",
                                          hintStyle: size25Grey,
                                          counter: Offstage()),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 10,
                    child: GestureDetector(
                      onTap: () async {
                        FocusScope.of(context).requestFocus(FocusNode());
                        if (MyApp().controller.formKey.currentState.validate()) {
                          MyApp().controller.formKey.currentState.save();
                          if (_itemImageFile == null) {
                            Get.snackbar(
                                "Error", "Image is empty,Please select image");
                          } else {
                            checkExistData();
                          }
                        }
                      },
                      child: Container(
                        width: double.infinity,
                        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(7.0),
                          gradient: customLinearGradient(),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Add category",
                              style: size25BlackW500,
                            ),
                            SizedBox(
                              width: 25,
                            ),
                            Icon(
                              Icons.add_box,
                              color: iconBlack,
                              size: 30,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  final picker = ImagePicker();
  File _itemImageFile;
  String itemImageUrl = "";
  bool present = false;

  Future pickItemImage() async {
    final pickedItemFile = await picker.getImage(source: ImageSource.gallery,imageQuality: 50);
    setState(() {
      _itemImageFile = File(pickedItemFile.path);
    });
    print(_itemImageFile.toString());
  }

  Future<void> uploadInMenu() async {
    ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child('images/${Path.basename(_itemImageFile.path)}');
    await ref.putFile(_itemImageFile).whenComplete(() async {
      await ref.getDownloadURL().then((value) async {
        print('Url is => ' + value);
        setState(() {
          itemImageUrl = value;
        });
        FirebaseFirestore.instance
            .collection("Users")
            .doc(MyApp().controller.userModel.key1)
            .collection("Menu")
            .doc(categoryName.text.capitalizeFirstOfEach)
            .set({
          "Key": categoryName.text.capitalizeFirstOfEach,
          "CategoryName": categoryName.text.capitalizeFirstOfEach,
          "CategoryImage": itemImageUrl
        }).then((value) {
          Navigator.of(MyApp().controller.globalKey.currentContext,
              rootNavigator: true)
              .pop();
          Get.back();
        }).catchError((onError) {
          print("Error 0");
          Navigator.of(MyApp().controller.globalKey.currentContext,
              rootNavigator: true)
              .pop();
          Get.snackbar("Error", onError.message);
        });
      }).catchError((onError) {
        print("Error 1");
        Navigator.of(MyApp().controller.globalKey.currentContext,
            rootNavigator: true)
            .pop();
        Get.snackbar("Error", onError.message);
      });
    }).catchError((onError) {
      print("Error 2");
      Navigator.of(MyApp().controller.globalKey.currentContext,
          rootNavigator: true)
          .pop();
      Get.snackbar("Error", onError.message);
    });
  }

  Future<void> checkExistData() async {
    MyApp().controller.handleSubmit(context);
    String key = categoryName.text;
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("Users")
        .doc(MyApp().controller.userModel.key1)
        .collection("Menu")
        .get();
    for (int i = 0; i < querySnapshot.docs.length; i++) {
      if (key == querySnapshot.docs[i]["Key"]) {
        setState(() {
          present = true;
        });
      } else {
        print("a");
      }
    }

    present ? show() : uploadInMenu();
  }

  void show() {
    Navigator.of(MyApp().controller.globalKey.currentContext,
        rootNavigator: true)
        .pop();
    Get.snackbar(
        "Error", "This category already in menu,Please change the name");
  }
}