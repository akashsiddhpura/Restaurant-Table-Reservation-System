import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reserved_table/Constance/Colors.dart';
import 'package:reserved_table/Constance/Strings.dart';
import 'package:reserved_table/Constance/Styles.dart';
import 'package:reserved_table/Hotel%20Owner/MangeEvents/ManageEventPage.dart';
import 'package:reserved_table/Hotel%20Owner/RattingPage.dart';
import 'package:reserved_table/Widgets/CommonMenuPage.dart';
import 'package:reserved_table/main.dart';
import 'package:reserved_table/Hotel%20Owner/OnlineCustomerPage.dart';
import 'package:reserved_table/Hotel Owner/ProfilePage.dart';
import 'package:shimmer/shimmer.dart';

double heightDivider = 1.0;
double thicknessDivider = 1.0;
Color colorDivider = Colors.grey;

Divider customDivider() {
  return Divider(
    height: 1.0,
    color: colorDivider,
    thickness: thicknessDivider,
  );
}

Row profileDataRow(
    String title, TextEditingController controller, String hintText) {
  return Row(
    children: [
      Expanded(
          flex: 5,
          child: Container(
              height: 60,
              margin: EdgeInsets.only(top: 10, left: 10, right: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: Card(
                  elevation: 5.0,
                  shadowColor: cardShadow,
                  child: Center(child: Text(title))))),
      Expanded(
        flex: 10,
        child: Container(
          margin: EdgeInsets.only(top: 10, left: 10, right: 10),
          height: 60,
          child: Card(
            elevation: 5.0,
            shadowColor: cardShadow,
            child: Center(
              child: TextFormField(
                // validator: (value) {
                //   return Validators().mobileValidator(value);
                // },
                controller: controller,
                style: size20,
                decoration: InputDecoration(
                  hintText: hintText,
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                ),
              ),
            ),
          ),
        ),
      ),
    ],
  );
}

Row buildRow(String title, String description) {
  return Row(
    children: [
      Expanded(
        flex: 50,
        child: Container(
          margin: EdgeInsets.only(top: 15),
          child: Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Text(
              title,
              style: size18,
            ),
          ),
        ),
      ),
      Expanded(
        flex: 100,
        child: Container(
          margin: EdgeInsets.only(top: 15),
          child: Text(
            description.toString(),
            style: size18,
          ),
        ),
      ),
    ],
  );
}

Row buildRow2(
    String title,
    TextEditingController controller,
    String hintText,
    TextInputType textInputType,
    String Function(String) validator,
    int length) {
  return Row(
    children: [
      Expanded(
        flex: 50,
        child: Container(
          child: Padding(
            padding: const EdgeInsets.only(left: 15),
            child: text20(title),
          ),
        ),
      ),
      Expanded(
        flex: 100,
        child: Container(
          margin: EdgeInsets.only(top: 7),
          child: TextFormField(
            controller: controller,
            keyboardType: textInputType,
            style: size20,
            maxLength: length,
            validator: validator,
            decoration:
                InputDecoration(hintText: hintText, counter: Offstage()),
          ),
        ),
      ),
    ],
  );
}

BoxShadow customBoxShadow = new BoxShadow(
  color: grey,
  blurRadius: 20.0,
);

GestureDetector drawerItems(String title, IconData icon, Function navigator) {
  return GestureDetector(
    onTap: navigator,
    child: Container(
      width: 250,
      height: 60,
      margin: EdgeInsets.only(right: 70, top: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [0.1, 1],
            colors: [drawerButtonShade1, drawerButtonShade2]),
        border: Border.all(color: blueDrawerButtonBorder, width: 2),
        borderRadius: borderRadius(0, 100.0, 100.0, 0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Text(
              title,
              style: size23WhiteW400,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Icon(
              icon,
              color: drawerButtonIcon,
            ),
          )
        ],
      ),
    ),
  );
}

GestureDetector drawerItemsReverse(
    String title, IconData icon, Function navigator) {
  return GestureDetector(
    onTap: navigator,
    child: Container(
      width: 250,
      height: 60,
      decoration: BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [0.1, 1],
            colors: [drawerButtonShade2, drawerButtonShade1]),
        border: Border.all(color: blueDrawerButtonBorder, width: 2),
        borderRadius: borderRadius(100.0, 0, 0, 100.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Text(
              title,
              style: size23WhiteW400,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Icon(
              icon,
              color: drawerButtonIcon,
            ),
          )
        ],
      ),
    ),
  );
}

class Dialogs {
  static Future<void> showLoadingDialog(
      BuildContext context, GlobalKey key) async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new WillPopScope(
            onWillPop: () async => false,
            child: MyCustomLoadingDialog(
              globalKey: key,
            ),
          );
        });
  }
}

class MyCustomLoadingDialog extends StatelessWidget {
  final GlobalKey<State> globalKey;

  MyCustomLoadingDialog({this.globalKey});

  @override
  Widget build(BuildContext context) {
    Duration insetAnimationDuration = const Duration(milliseconds: 100);
    Curve insetAnimationCurve = Curves.decelerate;

    RoundedRectangleBorder _defaultDialogShape = RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20.0)));

    return AnimatedPadding(
      key: globalKey,
      padding: MediaQuery.of(context).viewInsets +
          const EdgeInsets.symmetric(horizontal: 40.0, vertical: 24.0),
      duration: insetAnimationDuration,
      curve: insetAnimationCurve,
      child: MediaQuery.removeViewInsets(
        removeLeft: true,
        removeTop: true,
        removeRight: true,
        removeBottom: true,
        context: context,
        child: Center(
          child: SizedBox(
            width: 170,
            height: 170,
            child: Material(
              elevation: 24.0,
              color: blackWithOpacity8,
              type: MaterialType.card,
              //Modify to the widget we want to display here, the external properties are consistent with other Dialogs.
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  customCircularProcess(),
                  Text(
                    "Loading...",
                    style: size18Amber,
                  ),
                ],
              ),
              shape: _defaultDialogShape,
            ),
          ),
        ),
      ),
    );
  }
}


Padding requestData(String title, String description) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      children: [
        Expanded(flex: 300, child: text20(title)),
        Expanded(flex: 500, child: text20(description)),
      ],
    ),
  );
}

Widget customDrawer(BuildContext context) {
  void logOut() {
    MyApp().controller.handleSubmit(context);
    MyApp().controller.signOut();
  }

  CollectionReference menuReference = FirebaseFirestore.instance
      .collection("Users")
      .doc(MyApp().controller.userModel.key1)
      .collection("Menu");
  return Theme(
    data: Theme.of(context).copyWith(
      canvasColor: Colors.transparent,
    ),
    child: Drawer(
      child: Column(
        children: [
          Expanded(
            flex: 850,
            child: Container(
                child: Stack(
              children: [
                Container(
                  child: Image.network(MyApp().controller.hotelModel.hotelImage,fit: BoxFit.cover,width: double.infinity,height: double.infinity,),
                ),
                Container(
                  height: double.infinity,
                  width: double.infinity,
                  decoration:
                      BoxDecoration(color: Colors.black.withOpacity(0.7)),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: MediaQuery.of(context).padding.top,
                    ),

                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.amber.shade500.withOpacity(0.3),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              image: DecorationImage(
                                  image: NetworkImage(
                                      MyApp().controller.hotelModel.hotelImage),
                                  fit: BoxFit.cover),
                              border: Border.all(color: hotelImageBorder, width: 3)),
                        ),
                      ),
                    ),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 20, top: 10),
                          child: text20(
                            MyApp().controller.hotelModel.hotelName,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 20, top: 10),
                          child: text20(
                            MyApp().controller.hotelModel.hotelMobileNo,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 20, top: 10, bottom: 10),
                          child: text20(
                            MyApp().controller.hotelModel.hotelEmail,
                          ),
                        )
                      ],
                    ),

                  ],
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: MaterialButton(
                    minWidth: 5,
                    onPressed: () {
                      Get.to(() => HotelProfilePage());
                    },
                    child: Icon(Icons.edit),
                  ),
                ),
              ],
            )),
          ),
          Expanded(
            flex: 1500,
            child: Container(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    drawerItems(
                        "Hotel Menu",
                        Icons.restaurant_menu,
                        () => Get.to(() =>
                            CommonMenuPage(menuReference: menuReference))),
                    drawerItems("Hotel Ratting", Icons.star,
                        () => Get.to(() => RattingPage())),
                    drawerItems("Online History", Icons.history,
                        () => Get.to(() => OnlineCustomerPage())),
                    drawerItems("Manage Events", Icons.settings,
                        () => Get.to(() => EventManagesPage())),
                    drawerItems("Sign Out", Icons.logout, () => logOut()),
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

Widget noMoreData() {
  return Container(
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            sadIcon,
            height: 70,
            width: 70,
            fit: BoxFit.cover,
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            "No More Data",
            style: size30W500Grey,
          ),
        ],
      ),
    ),
  );
}

class GradientClipRRect extends StatelessWidget {
  const GradientClipRRect({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(7.0),
      child: Container(
        margin: EdgeInsets.only(left: 100),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            stops: [0.2, 0.9],
            end: Alignment.centerRight,
            colors: [Color(0xFF424242), Color(0x30424242)],
          ),
        ),
      ),
    );
  }
}

class ImageClipRRect extends StatelessWidget {
  const ImageClipRRect({
    this.height,
    this.hotelImage,
  });

  final double height;
  final String hotelImage;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(7.0),
      child: Container(
        height: height,
        margin: EdgeInsets.only(left: 110),
        width: double.infinity,
        child: CustomNetworkImage(image: hotelImage),
      ),
    );
  }
}

Widget customAppBar(String title) {
  return AppBar(
    title: Text(
      title,
      style: size25,
    ),
    elevation: 0.0,
    backgroundColor: Color(0x00FFFFFF),
    centerTitle: true,
  );
}

Future<void> customDialog(
    BuildContext context,
    String title,
    String description,
    Function function,
    String actionButtonText,
    TextStyle textStyle) {
  return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8.0))),
          title: Text(title),
          content: Text(description),
          actions: [
            MaterialButton(
                onPressed: () {
                  Get.back();
                },
                child: Text("Cancel")),
            MaterialButton(
                onPressed: () {
                  Get.back();
                  function();
                },
                child: Text(
                  actionButtonText,
                  style: textStyle,
                )),
          ],
        );
      });
}

Future<DateTime> globalDatePicker(BuildContext context) {
  return showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime(2021),
    lastDate: DateTime(2101),
    selectableDayPredicate: _decideWhichDayToEnable,
    builder: (BuildContext context, Widget child) {
      return Theme(
        data: ThemeData.dark().copyWith(
          // cursorColor: Colors.amber,
          colorScheme: ColorScheme.dark(
            primary: Colors.amber,
            onPrimary: Colors.black,
            surface: Colors.amber,
            onSurface: Colors.white,
          ),
        ),
        child: child,
      );
    },
  );
}

bool _decideWhichDayToEnable(DateTime day) {
  if ((day.isAfter(DateTime.now().subtract(Duration(days: 1))) &&
      day.isBefore(DateTime.now().add(Duration(days: 6))))) {
    return true;
  }
  return false;
}

Widget shimmerEffect() {
  return Shimmer.fromColors(
    baseColor: Color(0xff2b2b2b),
    highlightColor: Colors.black,
    child: Container(
      height: double.infinity,
      width: double.infinity,
      color: Color(0x50FFA23A),
    ),
  );
}

class CustomNetworkImage extends StatelessWidget {
  final String image;

  CustomNetworkImage({this.image});

  @override
  Widget build(BuildContext context) {
    return Image.network(
      image,
      fit: BoxFit.cover,
      width: MediaQuery.of(context).size.width,
      loadingBuilder: (BuildContext context, Widget child,
          ImageChunkEvent loadingProgress) {
        if (loadingProgress == null) return child;
        return shimmerEffect();
      },
    );
  }
}

Widget customTextFormField(
    TextEditingController controller,
    String hintText,
    String Function(String) validator,
    int maxLength,
    TextInputType textInputType,
    Widget suffix,
    bool obscureText) {
  return Container(
    margin: EdgeInsets.symmetric(horizontal: 30, vertical: 5),
    child: TextFormField(
      style: size20Amber,
      maxLength: maxLength,
      keyboardType: textInputType,
      controller: controller,
      validator: validator,
      obscureText: obscureText,
      cursorColor: cursorColor,
      decoration: InputDecoration(
        suffixIcon: suffix,
        counter: Offstage(),
        hintText: hintText,
        hintStyle: size20AmberOpacity,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        contentPadding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(28.0)),
          borderSide: BorderSide(color: Colors.amberAccent, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(28.0)),
          borderSide: BorderSide(color: Colors.amber, width: 3),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(28.0)),
          borderSide: BorderSide(color: Colors.deepOrange, width: 1),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(28.0)),
          borderSide: BorderSide(width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(28.0)),
          borderSide: BorderSide(color: Colors.deepOrangeAccent, width: 3),
        ),
      ),
    ),
  );
}

double starSize = 20.0;
IconData fillIcon = Icons.star;
IconData emptyIcon = Icons.star_border;
IconData halfIcon = Icons.star_half_sharp;

Widget rate05() {
  return Row(
    children: [
      Icon(
        halfIcon,
        size: starSize,
        color: ratting,
      ),
      Icon(emptyIcon, size: starSize, color: emptyRatting),
      Icon(emptyIcon, size: starSize, color: emptyRatting),
      Icon(emptyIcon, size: starSize, color: emptyRatting),
      Icon(emptyIcon, size: starSize, color: emptyRatting),
    ],
  );
}
Widget rate1() {
  return Row(
    children: [
      Icon(
        fillIcon,
        size: starSize,
        color: ratting,
      ),
      Icon(emptyIcon, size: starSize, color: emptyRatting),
      Icon(emptyIcon, size: starSize, color: emptyRatting),
      Icon(emptyIcon, size: starSize, color: emptyRatting),
      Icon(emptyIcon, size: starSize, color: emptyRatting),
    ],
  );
}

Widget rate15() {
  return Row(
    children: [
      Icon(
        fillIcon,
        size: starSize,
        color: ratting,
      ),
      Icon(
        halfIcon,
        size: starSize,
        color: ratting,
      ),
      Icon(emptyIcon, size: starSize, color: emptyRatting),
      Icon(emptyIcon, size: starSize, color: emptyRatting),
      Icon(emptyIcon, size: starSize, color: emptyRatting),
    ],
  );
}
Widget rate2() {
  return Row(
    children: [
      Icon(
        fillIcon,
        size: starSize,
        color: ratting,
      ),
      Icon(
        fillIcon,
        size: starSize,
        color: ratting,
      ),
      Icon(emptyIcon, size: starSize, color: emptyRatting),
      Icon(emptyIcon, size: starSize, color: emptyRatting),
      Icon(emptyIcon, size: starSize, color: emptyRatting),
    ],
  );
}

Widget rate25() {
  return Row(
    children: [
      Icon(
        fillIcon,
        size: starSize,
        color: ratting,
      ),
      Icon(
        fillIcon,
        size: starSize,
        color: ratting,
      ),
      Icon(
        halfIcon,
        size: starSize,
        color: ratting,
      ),
      Icon(emptyIcon, size: starSize, color: emptyRatting),
      Icon(emptyIcon, size: starSize, color: emptyRatting),
    ],
  );
}
Widget rate3() {
  return Row(
    children: [
      Icon(
        fillIcon,
        size: starSize,
        color: ratting,
      ),
      Icon(
        fillIcon,
        size: starSize,
        color: ratting,
      ),
      Icon(
        fillIcon,
        size: starSize,
        color: ratting,
      ),
      Icon(emptyIcon, size: starSize, color: emptyRatting),
      Icon(emptyIcon, size: starSize, color: emptyRatting),
    ],
  );
}

Widget rate35() {
  return Row(
    children: [
      Icon(
        fillIcon,
        size: starSize,
        color: ratting,
      ),
      Icon(
        fillIcon,
        size: starSize,
        color: ratting,
      ),
      Icon(
        fillIcon,
        size: starSize,
        color: ratting,
      ),
      Icon(
        halfIcon,
        size: starSize,
        color: ratting,
      ),
      Icon(emptyIcon, size: starSize, color: emptyRatting),
    ],
  );
}
Widget rate4() {
  return Row(
    children: [
      Icon(
        fillIcon,
        size: starSize,
        color: ratting,
      ),
      Icon(
        fillIcon,
        size: starSize,
        color: ratting,
      ),
      Icon(
        fillIcon,
        size: starSize,
        color: ratting,
      ),
      Icon(
        fillIcon,
        size: starSize,
        color: ratting,
      ),
      Icon(emptyIcon, size: starSize, color: emptyRatting),
    ],
  );
}

Widget rate45() {
  return Row(
    children: [
      Icon(
        fillIcon,
        size: starSize,
        color: ratting,
      ),
      Icon(
        fillIcon,
        size: starSize,
        color: ratting,
      ),
      Icon(
        fillIcon,
        size: starSize,
        color: ratting,
      ),
      Icon(
        fillIcon,
        size: starSize,
        color: ratting,
      ),
      Icon(
        halfIcon,
        size: starSize,
        color: ratting,
      ),
    ],
  );
}
Widget rate5() {
  return Row(
    children: [
      Icon(
        fillIcon,
        size: starSize,
        color: ratting,
      ),
      Icon(
        fillIcon,
        size: starSize,
        color: ratting,
      ),
      Icon(
        fillIcon,
        size: starSize,
        color: ratting,
      ),
      Icon(
        fillIcon,
        size: starSize,
        color: ratting,
      ),
      Icon(
        fillIcon,
        size: starSize,
        color: ratting,
      ),
    ],
  );
}

Widget customCircularProcess() {
  return CircularProgressIndicator(
    valueColor: AlwaysStoppedAnimation<Color>(Colors.amber),
  );
}

Gradient customLinearGradient() {
  return LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    stops: [0.1, 0.6, 0.9],
    colors: [Colors.orange.shade600, Colors.amber, Colors.yellow],
  );
}
