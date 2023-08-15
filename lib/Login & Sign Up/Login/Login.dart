import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:reserved_table/Constance/Colors.dart';
import 'package:reserved_table/Constance/Strings.dart';
import 'package:reserved_table/Constance/Styles.dart';
import 'package:reserved_table/Constance/Validators.dart';
import 'package:reserved_table/GetX/Controller.dart';
import 'package:reserved_table/Login%20&%20Sign%20Up/Login/Forgot%20Password.dart';
import 'package:reserved_table/Login%20&%20Sign%20Up/SignUp/Email%20Verification.dart';
import 'package:reserved_table/Widgets/Widgets.dart';
import 'package:reserved_table/main.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _email = new TextEditingController();
  TextEditingController _password = new TextEditingController();

  @override
  void dispose() {
    _email?.dispose();
    _password?.dispose();
    super.dispose();
  }

  Future<bool> _willPopCallback() {
    return customDialog(context, "Exit", "Do you want to exit the app ?",
            () => SystemNavigator.pop(), "Exit", size20Green) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _willPopCallback,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        // resizeToAvoidBottomPadding: false,
        body: Stack(
          fit: StackFit.expand,
          children: [
            Container(
              child: Image.asset(loginImage, fit: BoxFit.cover),
            ),
            Container(
              height: double.infinity,
              width: double.infinity,
              decoration: BoxDecoration(color: Colors.black54),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  height: MediaQuery.of(context).padding.top,
                ),
                Container(
                  height: MediaQuery.of(context).size.height -
                      MediaQuery.of(context).padding.top,
                  child: Form(
                    key: _formKey,
                    autovalidateMode: AutovalidateMode.disabled,
                    child: Column(
                      children: <Widget>[
                        Expanded(
                          flex: 400,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Login",
                                style: size40W500Orange,
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 190,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
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
                        Expanded(
                          flex: 190,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              customTextFormField(
                                  _password,
                                  "Enter password",
                                  passwordValidator,
                                  30,
                                  TextInputType.text,
                                  GestureDetector(
                                    onTap: () {
                                      MyApp().controller.toggle();
                                      setState(() {});
                                    },
                                    child: GetBuilder<
                                            StateManagementController>(
                                        init: StateManagementController(),
                                        builder: (controller) {
                                          return controller.obscureText
                                              ? Icon(Icons.visibility_outlined,
                                                  color: textFieldIcon)
                                              : Icon(
                                                  Icons.visibility_off_outlined,
                                                  color: textFieldIcon);
                                        }),
                                  ),
                                  MyApp().controller.obscureText),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 100,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  FocusScope.of(context)
                                      .requestFocus(FocusNode());
                                  Get.to(() => ForgotPasswordPage());
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 30),
                                  child: Text("Forgot Password ?",
                                      style: size17DeepOrangeAccent),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 200,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                    onTap: () async {
                                      FocusScope.of(context)
                                          .requestFocus(FocusNode());
                                      if (_formKey.currentState.validate()) {
                                        _formKey.currentState.save();
                                        if (_email.text.isNotEmpty &&
                                            _password.text.isNotEmpty) {
                                          _login();
                                        }
                                      }
                                    },
                                    child: Container(
                                      width: 200,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(50.0),
                                          color: loginButton),
                                      child: Center(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 50, vertical: 8),
                                          child: Text(
                                            "Login",
                                            style: size27W500Black,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 500,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "New user ? ",
                                style: size20Yellow,
                              ),
                              GestureDetector(
                                onTap: () {
                                  FocusScope.of(context)
                                      .requestFocus(FocusNode());
                                  Get.to(() =>
                                      UserTypeAndEmailVerificationSignUpPage());
                                },
                                child: Text(
                                  "Sign Up ",
                                  style: size20OrangeW500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
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

  void _login() {
    MyApp().controller.handleSubmit(context);
    MyApp().controller.login(_email.text, _password.text);
  }
}
