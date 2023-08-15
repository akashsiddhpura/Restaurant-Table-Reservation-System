import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:reserved_table/Constance/Colors.dart';
import 'package:reserved_table/Constance/Styles.dart';
import 'package:reserved_table/Constance/Validators.dart';
import 'package:reserved_table/Constance/Strings.dart';
import 'package:reserved_table/GetX/Controller.dart';
import 'package:reserved_table/Widgets/Widgets.dart';
import '../../main.dart';
import 'package:reserved_table/Login%20&%20Sign%20Up/Login/Login.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart' as Path;

class SignUpForUserPage extends StatefulWidget {
  final String email;
  final String userType;

  SignUpForUserPage({this.email, this.userType});

  @override
  _SignUpForUserPageState createState() => _SignUpForUserPageState();
}

class _SignUpForUserPageState extends State<SignUpForUserPage> {


  firebase_storage.Reference ref;
  final databaseReference = FirebaseFirestore.instance;

  final _formKey = GlobalKey<FormState>();
  TextEditingController _name = new TextEditingController();
  TextEditingController _mobile = new TextEditingController();
  TextEditingController _newPassword = new TextEditingController();
  TextEditingController _confirmPassword = new TextEditingController();

  bool isLoading = false;


  Future<bool> _willPopCallback() {
    return
    customDialog(context,"Are you sure","Sign Up Again ... ?",()=>Get.offAll(()=>LoginPage()),"Yes",size20Green) ?? false;

  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _willPopCallback,
      child: Scaffold(
        body: Container(
          child: Stack(
            fit: StackFit.expand,
            children: [
              Container(
                child: Image.asset(signUpUserImage, fit: BoxFit.cover),
              ),
              Container(
                height: double.infinity,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: blackWithOpacity6
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                      flex: 5,
                      child: Container()),
                  Expanded(
                      flex: 23,
                      child: Container(
                        child:Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text("Sign Up For User",style: size30W500Orange,),
                            Text(
                              widget.email,
                              style: size20Yellow,
                            ),
                          ],
                        ),
                      ),
                  ),
                  Expanded(
                    flex: 90,
                    child: Center(
                      child: Container(
                        child: Form(
                          key: _formKey,
                          autovalidateMode: AutovalidateMode.disabled,
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Stack(
                                  children: [
                                    GestureDetector(
                                      onTap: (){
                                        FocusScope.of(context).requestFocus(FocusNode());
                                        pickOwnerImage();
                                      },
                                      child: Container(
                                        height: 150,
                                        width: 150,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10.0),
                                          border: Border.all(width: 3,color: signUpOwnerImageBorder),
                                        ),
                                        child: _imageUserFile == null ? Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(7.0),
                                            color: Colors.black87,
                                          ),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Icon(Icons.person_outline,color: Colors.white,size: 40,),
                                              SizedBox(height: 5.0),
                                              Text("User",style: size20)
                                            ],
                                          ),
                                        ) :
                                        Container(
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(7.0),
                                              image: DecorationImage(image: FileImage(_imageUserFile),fit: BoxFit.cover)
                                          ),
                                        ),

                                      ),
                                    ),
                                    Positioned(
                                        bottom: 3,
                                        right: 3,
                                        child: GestureDetector(
                                          child: Container(width: 27, height: 27,
                                              decoration: BoxDecoration(
                                                  color: Colors.black54,
                                                  borderRadius: BorderRadius.circular(7.0)
                                              ),
                                              child: Icon(
                                                  Icons.close)),
                                          onTap: () {
                                            setState(() {
                                              _imageUserFile = null;
                                            });
                                          },
                                        )
                                    ),
                                  ],
                                ),
                                SizedBox(height: 15,),
                                customTextFormField(_name,"Enter name",nameValidator,30,TextInputType.text,Container(width: 0,height: 0,),false),
                                customTextFormField(_mobile,"Enter mobile number",mobileValidator,10,TextInputType.number,Container(width: 0,height: 0,),false),
                                customTextFormField(_newPassword,"New password",passwordValidator,30,TextInputType.text,GestureDetector(
                                  onTap: () {
                                    MyApp().controller.toggle();
                                    setState(() {});
                                  },
                                  child:
                                  GetBuilder<StateManagementController>(
                                      init: StateManagementController(),
                                      builder: (controller) {
                                        return controller.obscureText
                                            ? Icon(
                                            Icons.visibility_outlined,color:textFieldIcon)
                                            : Icon(Icons
                                            .visibility_off_outlined,color:textFieldIcon);
                                      }),
                                ),MyApp().controller.obscureText),
                                customTextFormField(_confirmPassword,"Confirm password",(val) {
                                  if(val.isEmpty)
                                    return "Password should not empty";
                                  else if (val != _newPassword.text)
                                    return "Password not match";
                                  else
                                    return null;
                                },30,TextInputType.text,GestureDetector(
                                  onTap: () {
                                    MyApp().controller.toggle2();
                                    setState(() {});
                                  },
                                  child:
                                  GetBuilder<StateManagementController>(
                                      init: StateManagementController(),
                                      builder: (controller) {
                                        return controller.obscureText2
                                            ? Icon(
                                            Icons.visibility_outlined,color:textFieldIcon,)
                                            : Icon(Icons
                                            .visibility_off_outlined,color:textFieldIcon);
                                      }),
                                ),MyApp().controller.obscureText2),

                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 10,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: (){
                            Get.offAll(()=>LoginPage());
                          },
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 20),
                            decoration:BoxDecoration(
                                borderRadius: BorderRadius.circular(5.0),
                                border: Border.all(width: 1,color: signUpOwnerLogin)
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                              child: Text("Login",style: size20,),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            FocusScope.of(context).requestFocus(FocusNode());
                            if (_formKey.currentState.validate()) {
                              _formKey.currentState.save();
                              if (_mobile.text.isNotEmpty &&
                                  _newPassword.text.isNotEmpty) {
                                if(_imageUserFile != null)
                                {
                                  uploadFile();
                                }else{
                                  Get.snackbar("Something Miss Out", "Please Select Your Image");
                                }

                              }
                            }
                          },
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 20),
                            decoration: BoxDecoration(
                                color: signUpOwnerNext,
                                borderRadius: BorderRadius.circular(5.0)
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                              child: Row(
                                children: [
                                  Text(
                                    "Next",
                                    style: size20BlackW500,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Icon(Icons.arrow_forward_rounded,color: signUpOwnerNextText)
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

            ],
          ),
        ),
      ),
    );
  }

  final picker = ImagePicker();
  File _imageUserFile;
  String userImageUrl = "";

  Future<void> pickOwnerImage() async {
    final pickedOwnerFile = await picker.getImage(source: ImageSource.gallery,imageQuality: 50);
    setState(() {
      _imageUserFile = File(pickedOwnerFile.path);
    });
  }

  Future<void> uploadFile() async {
    MyApp().controller.handleSubmit(context);

    ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child('images/${Path.basename(_imageUserFile.path)}');
    await ref.putFile(_imageUserFile).whenComplete(() async {
      await ref.getDownloadURL().then((value) {
        print('Url is => ' + value);
        setState(() {
          userImageUrl = value;
        });
      });
    });
    MyApp().controller.registerUserAccount(userImageUrl,_name.text.capitalizeFirstOfEach,widget.email,_mobile.text,_newPassword.text,widget.userType);
  }

}

