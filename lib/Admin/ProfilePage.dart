import 'package:flutter/material.dart';
import 'package:reserved_table/main.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: MaterialButton(
            onPressed: (){
              logOut();
            },
            child:Text("Log out")
          )
        ),
      ),
    );
  }

  void logOut(){
    MyApp().controller.handleSubmit(context);
    MyApp().controller.signOut();
  }

}
