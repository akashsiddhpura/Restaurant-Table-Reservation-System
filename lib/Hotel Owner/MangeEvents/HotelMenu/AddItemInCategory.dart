import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:reserved_table/Constance/Colors.dart';
import 'package:reserved_table/Constance/Styles.dart';
import 'package:reserved_table/Constance/Validators.dart';
import 'package:reserved_table/Hotel%20Owner/MangeEvents/HotelMenu/EditItemInCategoryPage.dart';
import 'package:reserved_table/Widgets/Widgets.dart';
import 'package:reserved_table/main.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart' as Path;



class AddItemsInCategoryPage extends StatefulWidget {
  final String categoryName;
  final String keyCategory;
  AddItemsInCategoryPage({this.categoryName,this.keyCategory});


  @override
  _AddItemsInCategoryPageState createState() => _AddItemsInCategoryPageState();
}

class _AddItemsInCategoryPageState extends State<AddItemsInCategoryPage> {


  double height = 150.0;
  @override
  Widget build(BuildContext context) {
    CollectionReference itemsCategoryReference = FirebaseFirestore.instance
        .collection("Users")
        .doc(MyApp().controller.userModel.key1)
        .collection("Menu").doc(widget.categoryName).collection("Items");
    return Scaffold(
      appBar: customAppBar("Add Items"),
      body: Column(
        children: [
          Expanded(
            flex: 90,
            child: StreamBuilder<QuerySnapshot>(
              stream: itemsCategoryReference.snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError)
                  return Text("Error : ${snapshot.error}");
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return Container(
                        child: Center(child: CircularProgressIndicator()));
                  default:
                    return snapshot.data.docs.length != 0

                        ?  ListView.builder(
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (_, int index) {
                        var image = snapshot.data.docs[index]["ItemImage"];
                        var name = snapshot.data.docs[index]["ItemName"];
                        var price = snapshot.data.docs[index]["ItemPrice"];
                        var type = snapshot.data.docs[index]["ItemType"];
                        var keyItem = snapshot.data.docs[index]["Key"];
                        return GestureDetector(
                          onTap: (){
                           Get.to(()=>EditItemInCategoryPage(index:index,keyCategory:widget.keyCategory,keyItem:keyItem,name:name,price:price,image:image,type:type));
                          },
                          child: Container(
                            height: height,
                            margin: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                            decoration: BoxDecoration(
                                color: containerBackGround,
                                borderRadius: BorderRadius.circular(7.0)),
                            child: Row(
                              children: [
                                Expanded(
                                  flex:1,
                                  child: Container(
                                    height:136,
                                    width: 136,
                                    margin: EdgeInsets.only(left: 7),
                                    child: ClipRRect(
                                      borderRadius:BorderRadius.circular(7.0),
                                      child: CustomNetworkImage(image:image)
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex:2,
                                  child: Container(
                                    margin: EdgeInsets.only(left: 20,top: 7,bottom: 7),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          height: 35,
                                          width: 35,
                                          decoration: BoxDecoration(
                                              border: Border.all(width:2,color: type == "Veg" ? veg : nonVeg,)
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(4.0),
                                            child: CircleAvatar(
                                              backgroundColor: type == "Veg" ? veg : nonVeg,
                                            ),
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            Expanded(  flex:2, child: Text("Name : ",maxLines:1,style: size23W500)),
                                            Expanded(  flex:5,child: Text(name,maxLines:1,style: size23CyanW500,overflow: TextOverflow.ellipsis,)),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Expanded(  flex:2, child: Text("Price : ",maxLines:1,style: size23W500)),
                                            Expanded(  flex:6,child: Text(price+"/-",maxLines:1,style: size23CyanW500,overflow: TextOverflow.ellipsis,)),
                                          ],
                                        ),

                                      ],
                                    ),
                                  ),
                                ),

                              ],
                            ),
                          ),
                        );
                      },
                    )
                        : noMoreData();
                }
              },
            ),
          ),
          Expanded(
            flex: 10,
            child: GestureDetector(
              onTap: () {
                Get.to(() => AddItemInCategoryPage(categoryName:widget.categoryName));
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
                      "Add items in category",
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
    );
  }
}

class AddItemInCategoryPage extends StatefulWidget {
  final String categoryName;
  AddItemInCategoryPage({this.categoryName});

  @override
  _AddItemInCategoryPageState createState() => _AddItemInCategoryPageState();
}

class _AddItemInCategoryPageState extends State<AddItemInCategoryPage> {
  TextEditingController price = TextEditingController()..text = "";
  TextEditingController itemName = TextEditingController()..text = "";
  firebase_storage.Reference ref;
  List type = ["Veg","Non-Veg"];
  int selectedIndex = 0;
  String selectedType;

  @override
  void initState() {
    super.initState();
    selectedType = type[0];
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      // resizeToAvoidBottomPadding: false,
      body: Container(
        child:  ListView(
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
                    flex: 90,
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
                                    ? ClipRRect(
                                  borderRadius: BorderRadius.circular(10.0),
                                  child: Container(
                                    height: 300,
                                    width: double.infinity,
                                    decoration:
                                    BoxDecoration(color: containerBackGround),
                                    child: GestureDetector(
                                        onTap: () {
                                          FocusScope.of(context).requestFocus(FocusNode());
                                          pickItemImage();
                                        },
                                        child: Icon(
                                          Icons.add_circle_outline_outlined,
                                          size: 120,
                                          color: grey,
                                        )),
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
                                          hintText: "Enter name",hintStyle: size25Grey, counter: Offstage()),
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
                                          hintText: "Enter price",hintStyle: size25Grey, counter: Offstage()),
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
                                                    selectedType = type[index].toString();
                                                  });
                                                },
                                                child: Container(
                                                    child: index == selectedIndex
                                                        ? Container(
                                                      width: 100,
                                                      decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(5.0),
                                                          color: amberVeg
                                                      ),
                                                      child: Center(
                                                        child: Padding(
                                                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                                          child: Text( type[index],
                                                            style: size20BlackW500,),
                                                        ),
                                                      ),
                                                    )
                                                        : Container(
                                                      width: 100,
                                                      decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(5.0),
                                                          color: grey
                                                      ),
                                                      child: Center(
                                                        child: Padding(
                                                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                                          child: Text( type[index],style: size18Black,),
                                                        ),
                                                      ),
                                                    )
                                                ),
                                              ),
                                            );
                                          }),
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
                      onTap: () {
                        FocusScope.of(context).requestFocus(FocusNode());
                        if (MyApp().controller.formKey.currentState.validate()) {
                          MyApp().controller.formKey.currentState.save();
                          if (_itemImageFile == null) {
                            Get.snackbar("Error", "Image is empty,Please select image");
                          } else {
                            uploadInMenu();
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
                              "Add it",
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
        )
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

  Future<void> uploadInMenu() async {
    MyApp().controller.handleSubmit(context);
    final menuKey = FirebaseFirestore.instance
        .collection("Users")
        .doc(MyApp().controller.userModel.key1)
        .collection("Menu");

    DocumentReference doc = menuKey.doc();
    String key = doc.id;
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
            .doc(widget.categoryName).collection("Items").doc(key)
            .set({
          "Key": key,
          "ItemPrice": price.text,
          "ItemName": itemName.text.capitalizeFirstOfEach,
          "ItemType":selectedType,
          "ItemImage": itemImageUrl
        })
            .then((value) {
          Navigator.of(MyApp().controller.globalKey.currentContext, rootNavigator: true).pop();
          Get.back();
        })
            .catchError((onError) {
          print("Error 0");
          Navigator.of(MyApp().controller.globalKey.currentContext, rootNavigator: true).pop();
          Get.snackbar("Error", onError.message);
        });
      }).catchError((onError) {
        print("Error 1");
        Navigator.of(MyApp().controller.globalKey.currentContext, rootNavigator: true).pop();
        Get.snackbar("Error", onError.message);
      });
    }).catchError((onError) {
      print("Error 2");
      Navigator.of(MyApp().controller.globalKey.currentContext, rootNavigator: true).pop();
      Get.snackbar("Error", onError.message);
    });
  }

}