import 'package:flutter/material.dart';
import 'package:reserved_table/Constance/Styles.dart';

ThemeData theme() {
  return  ThemeData(
      brightness: Brightness.dark,
      inputDecorationTheme: inputDecorationTheme(),
      visualDensity: VisualDensity.adaptivePlatformDensity,
      bottomNavigationBarTheme: BottomNavigationBarThemeData(selectedIconTheme: IconThemeData(color: Colors.amber),selectedItemColor: Colors.amber,selectedLabelStyle: size14W500Amber)
  );
}

InputDecorationTheme inputDecorationTheme() {
  // OutlineInputBorder enabledBorder = OutlineInputBorder(
  //   borderRadius: BorderRadius.all(Radius.circular(28.0)),
  //   borderSide:
  //   BorderSide(color: Colors.grey, width: 1),
  // );
  // OutlineInputBorder focusedBorder = OutlineInputBorder(
  //   borderRadius: BorderRadius.all(Radius.circular(28.0)),
  //   borderSide: BorderSide(color: Colors.teal, width: 3),
  // );
  // OutlineInputBorder errorBorder = OutlineInputBorder(
  //   borderRadius: BorderRadius.all(Radius.circular(28.0)),
  //   borderSide: BorderSide(color: Colors.red,width: 1),
  // );
  // OutlineInputBorder border = OutlineInputBorder(
  //   borderRadius: BorderRadius.all(Radius.circular(28.0)),
  //   borderSide: BorderSide(width: 1),
  // );
  // OutlineInputBorder focusedErrorBorder = OutlineInputBorder(
  //   borderRadius: BorderRadius.all(Radius.circular(28.0)),
  //   borderSide:
  //   BorderSide(color: Colors.red[700], width: 3),
  // );
  TextStyle errorText = TextStyle(fontSize: 14,color: Colors.orange);
  InputBorder border = InputBorder.none;
  return InputDecorationTheme(
    contentPadding: EdgeInsets.only(left: 35,top: 5,bottom: 5,right: 10),
    border: border,
    errorStyle: errorText,
  );
}