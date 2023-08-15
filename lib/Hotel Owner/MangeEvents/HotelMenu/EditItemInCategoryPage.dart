import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
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

class EditItemInCategoryPage extends StatefulWidget {
  final int index;
  final String image;
  final String name;
  final String price;
  final String type;
  final String keyItem;
  final String keyCategory;

  EditItemInCategoryPage(
      {this.index,
      this.keyItem,
      this.keyCategory,
      this.name,
      this.price,
      this.type,
      this.image});

  @override
  _EditItemInCategoryPageState createState() => _EditItemInCategoryPageState();
}

class _EditItemInCategoryPageState extends State<EditItemInCategoryPage> {
  TextEditingController price;
  TextEditingController itemName;

  firebase_storage.Reference ref;
  List type = ["Veg", "Non-Veg"];
  int selectedIndex ;
  String selectedType;

  @override
  void initState() {
    super.initState();
    if (widget.type == "Veg") {
      setState(() {
        selectedIndex = 0;
        selectedType = type[0];
      });
    } else {
      setState(() {
        selectedIndex = 1;
        selectedType = type[1];
      });
    }
    price = TextEditingController()..text = widget.price;
    itemName = TextEditingController()..text = widget.name;
    setState(() {});
  }



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
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    flex: 100,
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      child: Form(
                        key: MyApp().controller.formKey,
                        autovalidateMode: AutovalidateMode.disabled,
                        child: ListView(
                          shrinkWrap: true,
                          primary: false,
                          children: [
                            Stack(
                              children: [
                                _itemImageFile == null
                                    ? Stack(
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(10.0),
                                            child: Container(
                                              height: 300,
                                              width: double.infinity,
                                              child: CustomNetworkImage(image: widget.image,)
                                            ),
                                          ),
                                          imageFromGallery(),
                                        ],
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
                                          imageFromGallery(),
                                        ],
                                      ),
                              ],
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
                                      controller: itemName,
                                      keyboardType: TextInputType.text,
                                      validator: nameValidator,
                                      style: size25,
                                      decoration: InputDecoration(
                                          hintText: "Enter name",
                                          hintStyle: size25Grey,
                                          counter: Offstage()),
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
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 15),
                                      child: Text(
                                        "Price",
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
                                      controller: price,
                                      keyboardType: TextInputType.number,
                                      validator: priceValidator,
                                      maxLength: 5,
                                      style: size25,
                                      decoration: InputDecoration(
                                          hintText: "Enter price",
                                          hintStyle: size25Grey,
                                          counter: Offstage()),
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
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 15),
                                      child: Text(
                                        "Type",
                                        style: size25,
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 100,
                                  child: Center(
                                    child: Container(
                                      height: 50,
                                      margin: EdgeInsets.only(top: 7),
                                      child: ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          itemCount: type.length,
                                          shrinkWrap: true,
                                          itemBuilder: (context, index) {
                                            return Padding(
                                              padding: const EdgeInsets.all(5.0),
                                              child: GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    selectedIndex = index;
                                                    selectedType =
                                                        type[index].toString();
                                                  });
                                                },
                                                child: Container(
                                                    child: index == selectedIndex
                                                        ? Container(
                                                            width: 100,
                                                            decoration: BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5.0),
                                                                color: amberVeg),
                                                            child: Center(
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .symmetric(
                                                                        horizontal:
                                                                            10.0),
                                                                child: Text(
                                                                  type[index],
                                                                  style:
                                                                      size20BlackW500,
                                                                ),
                                                              ),
                                                            ),
                                                          )
                                                        : Container(
                                                            width: 100,
                                                            decoration: BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5.0),
                                                                color: grey),
                                                            child: Center(
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .symmetric(
                                                                        horizontal:
                                                                            10.0),
                                                                child: Text(
                                                                  type[index],
                                                                  style: size18Black,
                                                                ),
                                                              ),
                                                            ),
                                                          ),),
                                              ),
                                            );
                                          },),
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
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              FocusScope.of(context).requestFocus(FocusNode());
                              customDialog(context,"Edit","Are you sure to Edit this ?",()=>editMenuData(),"Edit",size20Green);
                            },
                            child: Container(
                              width: double.infinity,
                              margin: EdgeInsets.only(left:10,right:5,top:5,bottom:5),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(7.0),
                                border: Border.all(width: 2, color: editMenuButtonBorder),
                                color: editMenuButtonBackground
                              ),
                              child: Center(
                                child: Text(
                                  "Save",
                                  style: size25,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              FocusScope.of(context).requestFocus(FocusNode());
                              customDialog(context,"Delete","Are you sure to delete this ?",()=>deleteFromMenu(widget.index),"Delete",size20Red);
                            },
                            child: Container(
                              width: double.infinity,
                              margin: EdgeInsets.only(left:5,right:10,top:5,bottom:5),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(7.0),
                                border: Border.all(width: 2, color: deleteMenuButtonBorder),
                                color: deleteMenuButtonBackground
                              ),
                              child: Center(
                                child: Text(
                                  "Delete",
                                  style: size25,
                                ),
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
          ],
        ),
      ),
    );
  }

  Positioned imageFromGallery() {
    return Positioned(
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
                                  );
  }

  final picker = ImagePicker();
  File _itemImageFile;
  String itemImageUrl = "";

  Future pickItemImage() async {
    final pickedItemFile = await picker.getImage(source: ImageSource.gallery,imageQuality: 50);
    setState(() {
      _itemImageFile = File(pickedItemFile.path);
    });
    print(_itemImageFile.toString());
  }

  void editMenuData(){
    if(_itemImageFile == null){
      uploadInMenu();
    }else{
      withImageUploadInMenu();
    }
  }

  Future<void> uploadInMenu() async {
    MyApp().controller.handleSubmit(context);
    FirebaseFirestore.instance
        .collection("Users")
        .doc(MyApp().controller.userModel.key1)
        .collection("Menu")
        .doc(widget.keyCategory)
        .collection("Items")
        .doc(widget.keyItem)
        .update({
      "ItemPrice": price.text,
      "ItemName": itemName.text[0].toUpperCase()+itemName.text.substring(1),
      "ItemType": selectedType,
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
  }

  Future<void> withImageUploadInMenu() async {
    MyApp().controller.handleSubmit(context);

    ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child('images/${Path.basename(_itemImageFile.path)}');
    await ref.putFile(_itemImageFile).whenComplete(() async {
      await ref.getDownloadURL().then((value) {
        print('Url is => ' + value);
        setState(() {
          itemImageUrl = value;
        });
        FirebaseFirestore.instance
            .collection("Users")
            .doc(MyApp().controller.userModel.key1)
            .collection("Menu")
            .doc(widget.keyCategory)
            .collection("Items")
            .doc(widget.keyItem)
            .update({
          "ItemPrice": price.text,
          "ItemName": itemName.text.capitalizeFirstOfEach,
          "ItemType": selectedType,
          "ItemImage": itemImageUrl
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

  Future<void> deleteFromMenu(int index) async {
    MyApp().controller.handleSubmit(context);
    CollectionReference categoryItemReference =  FirebaseFirestore.instance
        .collection("Users")
        .doc(MyApp().controller.userModel.key1)
        .collection("Menu")
        .doc(widget.keyCategory)
        .collection("Items");
    QuerySnapshot qs = await categoryItemReference.get();
    qs.docs[index].reference.delete().then((value) {
      Navigator.of(MyApp().controller.globalKey.currentContext, rootNavigator: true).pop();
      Get.back();
    }).catchError((onError){
      Navigator.of(MyApp().controller.globalKey.currentContext, rootNavigator: true).pop();
      Get.snackbar("Error", onError.message);
    });
  }
}
