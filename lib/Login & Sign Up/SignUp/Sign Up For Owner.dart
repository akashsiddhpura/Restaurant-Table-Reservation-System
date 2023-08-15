import 'dart:async';
import 'dart:io';
import 'package:day_night_time_picker/day_night_time_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as Path;
import 'package:reserved_table/Constance/Colors.dart';
import 'package:reserved_table/Constance/Styles.dart';
import 'package:reserved_table/Constance/Validators.dart';
import 'package:reserved_table/Constance/Strings.dart';
import 'package:reserved_table/GetX/Controller.dart';
import 'package:reserved_table/Login%20&%20Sign%20Up/Login/Login.dart';
import 'package:reserved_table/Widgets/Widgets.dart';
import 'package:reserved_table/main.dart';

class SignUpForOwnerPage extends StatefulWidget {
  final String email;
  final String userType;

  SignUpForOwnerPage({this.email, this.userType});

  @override
  _SignUpForOwnerPageState createState() => _SignUpForOwnerPageState();
}

class _SignUpForOwnerPageState extends State<SignUpForOwnerPage> {

  final _formKey = GlobalKey<FormState>();

  firebase_storage.Reference ref;
  TextEditingController _name = new TextEditingController();
  TextEditingController _mobile = new TextEditingController();
  TextEditingController _newPassword = new TextEditingController();
  TextEditingController _confirmPassword = new TextEditingController();
  TextEditingController _hotelName = new TextEditingController();
  TextEditingController _hotelEmail = new TextEditingController();
  TextEditingController _hotelMobileNo = new TextEditingController();
  TextEditingController _hotelAddress = new TextEditingController();
  TextEditingController _hotelPersonCapacity = new TextEditingController();
  TextEditingController _hotelTotalTables = new TextEditingController();
  TextEditingController _hotelAddressPinCode = new TextEditingController();


  String openTime = "Select";
  String closeTime = "Select";
  String uploadHotelImageUrl = "";
  String reRequested = "No";

  bool uploading = false;
  bool isLoading = false;

  double val = 0;
  List<File> _image = [];

  Future<bool> _willPopCallback() {
        return customDialog(context,"Re-Enter Data","Do you want to Re-Enter your data ?",()=>Get.offAll(()=>LoginPage()),"Yes",size20Green) ?? false;
  }

  TimeOfDay _openTime = TimeOfDay.now();
  TimeOfDay _closeTime = TimeOfDay.now();

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
                child: Image.asset(signUpOwnerImage, fit: BoxFit.cover),
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
                          Text("Sign Up For Owner",style: size30W500Orange,),
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
                          child: ListView(

                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Column(
                                    children: [
                                      Stack(
                                        children: [
                                          GestureDetector(
                                            onTap: (){
                                              FocusScope.of(context).requestFocus(FocusNode());
                                              if(_imageHotelFile == null && _imageProofFile == null){
                                                pickOwnerImage();
                                              }else{
                                                Get.snackbar("Error", "Please Select Images In Sequence");
                                              }
                                            },
                                            child: Container(
                                              height: 110,
                                              width: 110,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(10.0),
                                                border: Border.all(width: 3,color: signUpOwnerImageBorder),
                                              ),
                                              child: _imageOwnerFile == null ? Container(
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(7.0),
                                                  color: Colors.black87,
                                                ),
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Icon(Icons.person_outline,color: Colors.white,size: 40,),
                                                    SizedBox(height: 5,),
                                                    Text("User",style: size20)
                                                  ],
                                                ),
                                              ) : Container(
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(7.0),
                                                  image: DecorationImage(image: FileImage(_imageOwnerFile),fit: BoxFit.cover)
                                                ),
                                                ),
                                            ),
                                          ),
                                          Positioned(
                                              bottom: 3,
                                              right: 3,
                                              child:GestureDetector(
                                                child: Container(width: 27, height: 27,decoration: BoxDecoration(
                                                    color: Colors.black54,
                                                    borderRadius: BorderRadius.circular(7.0)
                                                ), child: Icon(Icons.close)),
                                                onTap: () {
                                                  setState(() {
                                                    _imageOwnerFile = null;
                                                    _imageHotelFile = null;
                                                    _imageProofFile = null;
                                                  });
                                                },
                                              )
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Stack(
                                        children: [
                                          GestureDetector(
                                            onTap: (){
                                              FocusScope.of(context).requestFocus(FocusNode());
                                              if(_imageOwnerFile != null && _imageProofFile == null ){
                                                pickHotelImage();
                                              }else{
                                                Get.snackbar("Error", "Please Select Images In Sequence");
                                              }
                                            },
                                            child: Container(
                                              height: 110,
                                              width: 110,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(10.0),
                                                border: Border.all(width: 3,color: signUpOwnerImageBorder),
                                              ),
                                              child: _imageHotelFile == null ? Container(
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(7.0),
                                                  color: Colors.black87,
                                                ),
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Icon(Icons.apartment_sharp,color: Colors.white,size: 40,),
                                                    SizedBox(height: 5.0),
                                                    Text("Hotel",style: size20)
                                                  ],
                                                ),
                                              ) :
                                              Container(
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(7.0),
                                                    image: DecorationImage(image: FileImage(_imageHotelFile),fit: BoxFit.cover)
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
                                                    child: Icon(Icons.close)),
                                                onTap: () {
                                                  setState(() {
                                                    _imageHotelFile = null;
                                                    _imageProofFile = null;
                                                  });
                                                },
                                              ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Stack(
                                        children: [
                                          GestureDetector(
                                            onTap: (){
                                              FocusScope.of(context).requestFocus(FocusNode());
                                              if(_imageOwnerFile != null && _imageHotelFile != null ){
                                                pickProofImage();
                                              }else{
                                                Get.snackbar("Error", "Please Select Images In Sequence");
                                              }
                                            },
                                            child: Container(
                                              height: 110,
                                              width: 110,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(10.0),
                                                border: Border.all(width: 3,color: signUpOwnerImageBorder),
                                              ),
                                              child: _imageProofFile == null ?  Container(
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(7.0),
                                                  color: Colors.black87,
                                                ),
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Icon(Icons.insert_drive_file_outlined,color: Colors.white,size: 40,),
                                                    SizedBox(height: 5.0),
                                                    Text("Proof",style: size20)
                                                  ],
                                                ),
                                              ) : Container(
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(7.0),
                                                    image: DecorationImage(image: FileImage(_imageProofFile),fit: BoxFit.cover)
                                                ),
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                              bottom: 3,
                                              right: 3,
                                              child:GestureDetector(
                                                child: Container(width: 27, height: 27,decoration: BoxDecoration(
                                                    color: Colors.black54,
                                                    borderRadius: BorderRadius.circular(7.0)
                                                ), child: Icon(Icons.close)),
                                                onTap: () {
                                                  setState(() {
                                                    _imageProofFile = null;
                                                  });
                                                },
                                              )
                                          )
                                        ],
                                      ),
                                    ],
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
                                          Icons.visibility_outlined,color:textFieldIcon)
                                          : Icon(Icons
                                          .visibility_off_outlined,color:textFieldIcon);
                                    }),
                              ),MyApp().controller.obscureText2),


                              Container(
                                height: 50,
                                margin: EdgeInsets.symmetric(vertical: 5,horizontal: 30),
                                decoration: BoxDecoration(color: Colors.black87,borderRadius: BorderRadius.circular(50.0)) ,
                                child: Center(
                                  child: Text(
                                    "- - - Fill Up Your Hotel Details - - -",
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ),
                              ),
                              SizedBox(height: 5),
                              customTextFormField(_hotelName,"Enter hotel name",nameValidator,30,TextInputType.text,Container(width: 0,height: 0,),false),
                              customTextFormField(_hotelEmail,"Enter hotel email",emailValidator,30,TextInputType.emailAddress,Container(width: 0,height: 0,),false),
                              customTextFormField(_hotelMobileNo,"Enter hotel telephone number",mobileValidator,10,TextInputType.number,Container(width: 0,height: 0,),false),
                              customTextFormField(_hotelAddress,"Enter hotel address",addressValidator,50,TextInputType.text,Container(width: 0,height: 0,),false),
                              customTextFormField(_hotelAddressPinCode,"Enter pin code",pinCodeValidator,6,TextInputType.number,Container(width: 0,height: 0,),false),
                              customTextFormField(_hotelTotalTables,"Enter total number of tables",tableValidator,2,TextInputType.number,Container(width: 0,height: 0,),false),
                              customTextFormField(_hotelPersonCapacity,"Enter hotel capacity",capacityValidator,3,TextInputType.number,Container(width: 0,height: 0,),false),

                              Container(
                                height: 50,
                                margin: EdgeInsets.symmetric(vertical: 5,horizontal: 30),
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(50.0),border: Border.all(width: 1,color: Colors.amberAccent)) ,
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 30),
                                    child: Row(
                                      children: [
                                        Text("Select Opening Time : ",style: size20Yellow,),
                                        TextButton(
                                          onPressed: () {
                                            FocusScope.of(context).requestFocus(FocusNode());
                                            Navigator.of(context).push(
                                              showPicker(
                                                accentColor: timePicker,
                                                context: context,
                                                value: _openTime,
                                                onChange: onOpenTimeChanged,
                                                is24HrFormat: false,
                                              ),
                                            );
                                          },
                                          child: Row(
                                            children: [
                                              Text(openTime,style: size20AmberShade800),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Icon(Icons.arrow_drop_down_sharp,color: iconOwenRegistration)
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 10,),
                              Container(
                                height: 50,
                                margin: EdgeInsets.symmetric(vertical: 5,horizontal: 30),
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(50.0),border: Border.all(width: 1,color: Colors.amberAccent)) ,
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 30),
                                    child: Row(
                                      children: [
                                        Text("Select Closing Time : ",style: size20Yellow,),
                                        TextButton(
                                          onPressed: () {
                                            FocusScope.of(context).requestFocus(FocusNode());
                                            Navigator.of(context).push(
                                              showPicker(
                                                accentColor: timePicker,
                                                context: context,
                                                value: _closeTime,
                                                onChange: onCloseTimeChanged,
                                                is24HrFormat: false,
                                              ),
                                            );
                                          },
                                          child: Row(
                                            children: [
                                              Text(closeTime,style: size20AmberShade800),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Icon(Icons.arrow_drop_down_sharp,color: iconOwenRegistration)
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
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
                              if (openTime == "Select") {
                                Get.snackbar("Something Miss Out", "Please select hotel opening time");
                              } else if (closeTime == "Select") {
                                Get.snackbar("Something Miss Out", "Please select hotel closing time");
                              }else if(_imageOwnerFile == null ||  _imageHotelFile == null ||  _imageProofFile == null){
                                Get.snackbar("Something Miss Out", "Some images are missing please select proper images");
                              } else {

                                uploadFile();
                              }
                            }else{
                              Get.snackbar("Error", "Please enter valid details.");
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
  File _imageOwnerFile;
  File _imageHotelFile;
  File _imageProofFile;
  String hotelOwnerImageUrl = "";
  String hotelOwnerProofImageUrl = "";
  String hotelImageUrl = "";

  Future pickOwnerImage() async {
    final pickedOwnerFile = await picker.getImage(source: ImageSource.gallery,imageQuality: 50);
    setState(() {
      _imageOwnerFile = File(pickedOwnerFile.path);
      _image.insert(0, File(pickedOwnerFile?.path));
    });
  }

  Future pickHotelImage() async {
    final pickedHotelFile = await picker.getImage(source: ImageSource.gallery,imageQuality: 50);
    setState(() {
      _imageHotelFile = File(pickedHotelFile.path);
      _image.insert(1, File(pickedHotelFile?.path));
    });
  }

  Future pickProofImage() async {
    final pickedProofFile = await picker.getImage(source: ImageSource.gallery,imageQuality: 50);
    setState(() {
      _imageProofFile = File(pickedProofFile.path);
      _image.insert(2, File(pickedProofFile?.path));
    });
  }

  Future uploadFile() async {
    MyApp().controller.handleSubmit(context);

    print(">>>" + _image.length.toString());
    int i = 0;
    for (var img in _image) {
      setState(() {
        val = i / _image.length;
      });
      ref = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('images/${Path.basename(img.path)}');
      await ref.putFile(img).whenComplete(() async {
        await ref.getDownloadURL().then((value) {
          print('Url $i is => ' + value);
          setState(() {
            if (i == 0) {
              hotelOwnerImageUrl = value;
            } else if (i == 1) {
              hotelImageUrl = value;
            } else if (i == 2) {
              hotelOwnerProofImageUrl = value;
            }
          });
          i++;
        });
      });
    }
    createUserAccount();
  }

  void createUserAccount() {
    MyApp().controller.registerOwnerAccount(
        _name.text.capitalizeFirstOfEach,
        widget.email,
        _mobile.text,
        _newPassword.text,
        widget.userType,
        hotelOwnerImageUrl,
        hotelOwnerProofImageUrl,
        hotelImageUrl,
        _hotelName.text.capitalizeFirstOfEach,
        _hotelMobileNo.text,
        _hotelEmail.text,
        _hotelAddress.text.capitalizeFirstOfEach,
        _hotelAddressPinCode.text,
        _hotelTotalTables.text,
        _hotelPersonCapacity.text,
        openTime,
        closeTime,"No");
  }

}
