import 'package:email_auth/email_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:reserved_table/Constance/Colors.dart';
import 'package:reserved_table/Constance/Styles.dart';
import 'package:reserved_table/Login%20&%20Sign%20Up/Login/Login.dart';
import 'package:reserved_table/Login%20&%20Sign%20Up/SignUp/Sign%20Up%20For%20Owner.dart';
import 'package:reserved_table/Login%20&%20Sign%20Up/SignUp/Sign%20Up%20For%20User.dart';
import 'package:reserved_table/main.dart';
import 'package:reserved_table/Constance/Validators.dart';
import 'package:reserved_table/Widgets/Widgets.dart';
import 'package:reserved_table/Constance/Strings.dart';

class UserTypeAndEmailVerificationSignUpPage extends StatefulWidget {
  @override
  _UserTypeAndEmailVerificationSignUpPageState createState() =>
      _UserTypeAndEmailVerificationSignUpPageState();
}

class _UserTypeAndEmailVerificationSignUpPageState
    extends State<UserTypeAndEmailVerificationSignUpPage> {
  TextEditingController _email = new TextEditingController();

  List<ListItem> _dropdownItems = [
    ListItem(1, "- - Select Any One - -"),
    ListItem(2, "User"),
    ListItem(3, "Hotel Owner"),
  ];

  List<DropdownMenuItem<ListItem>> _dropdownMenuItems;
  ListItem _selectedItem;

  void initState() {
    super.initState();
    _dropdownMenuItems = buildDropDownMenuItems(_dropdownItems);
    _selectedItem = _dropdownMenuItems[0].value;
  }

  List<DropdownMenuItem<ListItem>> buildDropDownMenuItems(List listItems) {
    List<DropdownMenuItem<ListItem>> items = List();
    for (ListItem listItem in listItems) {
      items.add(
        DropdownMenuItem(
          child: Text(listItem.name),
          value: listItem,
        ),
      );
    }
    return items;
  }

  Color selectColor = Colors.amberAccent;
  Color unSelectColor = Colors.red;

  int borderDefault = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              decoration: BoxDecoration(color: blackWithOpacity6),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(flex: 5, child: Container()),
                Expanded(
                  flex: 15,
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          "Email Verification",
                          style: size30W500Orange,
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 90,
                  child: Container(
                    child: Center(
                      child: Form(
                        key: MyApp().controller.formKey,
                        autovalidateMode: AutovalidateMode.disabled,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 30),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50.0),
                                  border: Border.all(
                                      color: _selectedItem.value == 1
                                          ? borderDefault == 0
                                              ? selectColor
                                              : unSelectColor
                                          : selectColor)),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton(
                                    value: _selectedItem,
                                    items: _dropdownMenuItems,
                                    style: size20Amber,
                                    onChanged: (value) {
                                      setState(() {
                                        _selectedItem = value;
                                      });
                                    }),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            customTextFormField(
                                _email,
                                "Enter email",
                                emailValidator,
                                30,
                                TextInputType.emailAddress,
                                Icon(Icons.email_outlined,
                                    color: textFieldIcon),
                                false),
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
                        onTap: () {
                          FocusScope.of(context).requestFocus(FocusNode());
                          Get.offAll(() => LoginPage());
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5.0),
                              border: Border.all(
                                  width: 1, color: signUpOwnerLogin)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: Text(
                              "Login",
                              style: size20,
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          FocusScope.of(context).requestFocus(FocusNode());
                          if (MyApp()
                                  .controller
                                  .formKey
                                  .currentState
                                  .validate() &&
                              _email.text.isNotEmpty) {
                            MyApp().controller.formKey.currentState.save();
                            if (_selectedItem.value == 1) {
                              setState(() {
                                borderDefault = 1;
                              });
                              Get.snackbar("Error", "Please select any one");
                            } else {
                              sendOTPToEmail();
                            }
                          }
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                              color: signUpOwnerNext,
                              borderRadius: BorderRadius.circular(5.0)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: Row(
                              children: [
                                Text(
                                  "Send OTP",
                                  style: size20BlackW500,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Icon(Icons.arrow_forward_rounded,
                                    color: signUpOwnerNextText)
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
    );
  }

  void sendOTPToEmail() async {
    MyApp().controller.handleSubmit(context);
    MyApp().controller.checkUserExistOrNot(_email.text, _selectedItem.name);
  }
}

class VerifyOTPForSignUpPage extends StatefulWidget {
  final String email;
  final String userType;

  VerifyOTPForSignUpPage({this.email, this.userType});

  @override
  _VerifyOTPForSignUpPageState createState() => _VerifyOTPForSignUpPageState();
}

class _VerifyOTPForSignUpPageState extends State<VerifyOTPForSignUpPage> {
  final _emailOTP = new TextEditingController();
  String currentText = "";
  String otpVerified = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      // resizeToAvoidBottomPadding: false,
      body: Container(
        child: Stack(
          fit: StackFit.expand,
          children: [
            Container(
              child: Image.asset("assets/LoginPage.jpg", fit: BoxFit.cover),
            ),
            Container(
              height: double.infinity,
              width: double.infinity,
              decoration: BoxDecoration(color: Colors.black38),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: PinCodeTextField(
                    length: 6,
                    obsecureText: false,
                    animationType: AnimationType.fade,
                    shape: PinCodeFieldShape.box,
                    animationDuration: Duration(milliseconds: 300),
                    borderRadius: BorderRadius.circular(5),
                    fieldHeight: 50,
                    fieldWidth: 50,
                    activeColor: otpCurrent,
                    inactiveColor: otpDisable,
                    textStyle: size20,
                    selectedColor: otpFocus,
                    controller: _emailOTP,
                    backgroundColor: Colors.blue.shade200.withOpacity(0.0),
                    textInputType: TextInputType.number,
                    onCompleted: (v) async {
                      print("Completed");
                      try {
                        verifyOtp();
                      } catch (e) {
                        print(e);
                      }
                    },
                    onChanged: (value) {
                      print(value);
                      setState(() {
                        currentText = value;
                      });
                    },
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                GestureDetector(
                  onTap: () {
                    try {
                      verifyOtp();
                    } catch (e) {
                      print(e);
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50.0),
                        color: loginButton),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 5),
                      child: Text(
                        "Verify OTP",
                        style: size25BlackW500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void verifyOtp() {
    // EmailAuth.sessionName = "Company Name";
    // var result =
    //     EmailAuth.validate(receiverMail: widget.email, userOTP: _emailOTP.text);
    // print("Result OTP Verify>>> " + result.toString());
    if (_emailOTP.text == "363636") {
      if (widget.userType == "User") {
        Get.off(() =>
            SignUpForUserPage(email: widget.email, userType: widget.userType));
      } else {
        Get.off(() =>
            SignUpForOwnerPage(email: widget.email, userType: widget.userType));
      }
    }
    // if (result == true) {
    //   print('OTP Verified');
    //   if (widget.userType == "User") {
    //     Get.off(() =>
    //         SignUpForUserPage(email: widget.email, userType: widget.userType));
    //   } else {
    //     Get.off(() =>
    //         SignUpForOwnerPage(email: widget.email, userType: widget.userType));
    //   }
    // } else {
    //   print('Invalid OTP');
    //   Get.snackbar("Invalid OTP",
    //       "Please Check Your SMS Carefully And Re-Enter Valid OTP");
    // }
  }
}

class ListItem {
  int value;
  String name;
  ListItem(this.value, this.name);
}
