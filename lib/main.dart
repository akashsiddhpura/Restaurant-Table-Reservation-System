import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:reserved_table/Constance/Strings.dart';
import 'package:reserved_table/Constance/Theme.dart';
import 'package:reserved_table/GetX/Shared%20Preferences.dart';
import 'package:reserved_table/Hotel%20Owner/My%20Hotel.dart';
import 'package:reserved_table/Hotel%20Owner/Status%20Page.dart';
import 'package:reserved_table/Login%20&%20Sign%20Up/Login/Login.dart';
import 'package:reserved_table/Model/HotelModel.dart';
import 'package:reserved_table/Model/UserModel.dart';
import 'package:reserved_table/User/HomePage.dart';
import 'package:responsive_framework/responsive_wrapper.dart';
import 'package:responsive_framework/utils/scroll_behavior.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'GetX/Controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}


class MyApp extends StatefulWidget {
  final StateManagementController controller =
      Get.put(StateManagementController());

  @override
  _MyAppState createState() => _MyAppState();
}
class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }

  @override
  dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Color(0x00FFFFFF),
    ));

    return GetMaterialApp(
      builder: (context, widget) => ResponsiveWrapper.builder(
          BouncingScrollWrapper.builder(context, widget),
          maxWidth: 1200,
          minWidth: 450,
          defaultScale: true,
          breakpoints: [
            ResponsiveBreakpoint.resize(450, name: MOBILE),
            ResponsiveBreakpoint.autoScale(800, name: TABLET),
            ResponsiveBreakpoint.autoScale(1000, name: TABLET),
            ResponsiveBreakpoint.resize(1200, name: DESKTOP),
            ResponsiveBreakpoint.autoScale(2460, name: "4K"),
          ],
          background: Container(color: Color(0xFFF5F5F5))),
      // home: SignUpForUserPage(email:"dis",userType:"scii"),
      home: MyHomePage(),
      theme: theme(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 3),(){autoLogIn();});
    MyApp().controller.addHotelInSearch();
  }


  void autoLogIn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String userData = prefs.getString("UserData");
    if (userData != null) {
      UserModel userData = await Preferences.getUser();
      MyApp().controller.userModel = userData;
      if (userData.userType != null) {
        if (userData.userType == "User") {
          Get.offAll(() => UserHomePage());
        } else if (userData.userType == "Hotel Owner") {
          HotelModel ownerData = await Preferences.getOwner();
          MyApp().controller.hotelModel = ownerData;
          if (ownerData.hotelTableCreated == "Yes") {
            Get.offAll(() => HotelHomePage());
          } else {
            Get.offAll(() => StatusPageForOwner());
          }
        }
      } else {
        Get.offAll(() => LoginPage());
        print("Null => 11");
      }
      return;
    } else {
      Get.offAll(() => LoginPage());
      print("Null => 22");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
          fit:StackFit.expand,
          children: [
            Container(child: Image.asset(splashImage,fit:BoxFit.fitHeight))
          ],
        ),
    );
  }
}

extension CapExtension on String {
  String get inCaps => this.length > 0 ?'${this[0].toUpperCase()}${this.substring(1)}':'';
  String get allInCaps => this.toUpperCase();
  String get capitalizeFirstOfEach => this.replaceAll(RegExp(' +'), ' ').split(" ").map((str) => str.inCaps).join(" ");
}

//FocusScope.of(context).requestFocus(FocusNode());