import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reserved_table/Constance/Colors.dart';
import 'package:reserved_table/Login%20&%20Sign%20Up/Login/Login.dart';
import 'package:reserved_table/main.dart';
import 'package:reserved_table/Constance/Validators.dart';
import 'package:reserved_table/Constance/Strings.dart';
import 'package:reserved_table/Constance/Styles.dart';
import 'package:reserved_table/Widgets/Widgets.dart';

class ForgotPasswordPage extends StatefulWidget {
  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController _email = new TextEditingController();

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
              child: Image.asset(forgotImage, fit: BoxFit.cover),
            ),
            Container(
              height: double.infinity,
              width: double.infinity,
              decoration: BoxDecoration(color: Colors.black54),
            ),
            Column(
              children: [
                Expanded(flex: 5, child: Container()),
                Expanded(
                  flex: 15,
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          "Forgot Password",
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
                        key: _formKey,
                        autovalidateMode: AutovalidateMode.disabled,
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
                            SizedBox(height: 40),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                  "We are sending link on mail to reset password",
                                  style: size18Amber),
                            )
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
                          if (_formKey.currentState.validate()) {
                            _formKey.currentState.save();
                            if (_formKey.currentState.validate()) {
                              _formKey.currentState.save();
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
                                  "Next",
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
    MyApp().controller.sendPasswordResetEmail(_email.text);
  }

  // void sendOTPToEmail() async {
  //   controller.handleSubmit(context);
  //   controller.resetPassword(_email.text,_selectedItem.name );
  // }

}
