import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

TextStyle size12White70 = TextStyle(fontSize: 12,color: Colors.white70);
TextStyle size13White = TextStyle(fontSize: 13,color: Colors.white);
TextStyle size14Black = TextStyle(fontSize: 14,color: Colors.black);
TextStyle size14White70 = TextStyle(fontSize: 14,color: Colors.white70);
TextStyle size14W500Amber = TextStyle(fontSize: 14,fontWeight: FontWeight.w500,color: Colors.amber);
TextStyle size16Grey = TextStyle(fontSize: 16,color: Colors.grey);
TextStyle size16 = TextStyle(fontSize: 16);
TextStyle size17DeepOrangeAccent = TextStyle(fontSize: 17,color: Colors.deepOrangeAccent);
TextStyle size18 = TextStyle(fontSize: 18);
TextStyle size18Red = TextStyle(fontSize: 18,color: Colors.redAccent);
TextStyle size18Black = TextStyle(fontSize: 18,color: Colors.black);
TextStyle size18Amber = TextStyle(fontSize: 18,color: Colors.amber);
TextStyle size20 = TextStyle(fontSize: 20);
TextStyle size20W500 = TextStyle(fontSize: 20,fontWeight: FontWeight.w500);
TextStyle size20Green = TextStyle(fontSize: 20,color: Colors.green);
TextStyle size20Amber = TextStyle(fontSize: 20,color: Colors.amber);
TextStyle size20AmberShade800 = TextStyle(fontSize: 20,color: Colors.amber.shade800);
TextStyle size20AmberW500 = TextStyle(fontSize: 20,color: Colors.amber,fontWeight: FontWeight.w500);
TextStyle size20Yellow = TextStyle(fontSize: 20,color: Colors.yellow);
TextStyle size20OrangeW500 = TextStyle(fontSize: 20,color: Colors.orange,fontWeight: FontWeight.w500,decoration: TextDecoration.underline,height: 2.0,);
TextStyle size20AmberOpacity = TextStyle(fontSize: 20,color: Colors.amber.withOpacity(0.5));
TextStyle size20Blue = TextStyle(fontSize: 20,color: Colors.blue);
TextStyle size20Red = TextStyle(fontSize: 20,color: Colors.red);
TextStyle size20BlackW500 = TextStyle(fontSize: 20,color: Colors.black,fontWeight: FontWeight.w500);
TextStyle size23W500 = TextStyle(fontSize: 23,fontWeight: FontWeight.w500);
TextStyle size23CyanW500 = TextStyle(fontSize: 23,color: Colors.cyan,fontWeight: FontWeight.w500);
TextStyle size23WhiteW400 = TextStyle(fontSize: 23,color: Colors.white,fontWeight: FontWeight.w400);
TextStyle size25Grey = TextStyle(fontSize: 25,color: Colors.grey);
TextStyle size25GreenW500 = TextStyle(fontSize: 25,color: Colors.green,fontWeight: FontWeight.w500);
TextStyle size25YellowW500 = TextStyle(fontSize: 25,color: Colors.yellow,fontWeight: FontWeight.w500);
TextStyle size25BlackW500 = TextStyle(fontSize: 25,color: Colors.black,fontWeight: FontWeight.w500);
TextStyle size25 = TextStyle(fontSize: 25,fontWeight: FontWeight.w500);
TextStyle size25B = TextStyle(fontSize: 25,fontWeight: FontWeight.bold);
TextStyle size27BW500 = TextStyle(fontSize: 27,fontWeight: FontWeight.w500);
TextStyle size27W500Black = TextStyle(fontSize: 27,fontWeight: FontWeight.w500,color: Colors.black);

TextStyle size30W500 = TextStyle(fontSize: 30,fontWeight: FontWeight.w500);
TextStyle size30W500Cyan = TextStyle(fontSize: 30,fontWeight: FontWeight.w500,color: Colors.cyan);
TextStyle size35W500Cyan = TextStyle(fontSize: 35,fontWeight: FontWeight.w500,color: Colors.cyan);
TextStyle size30W500Grey = TextStyle(fontSize: 30,fontWeight: FontWeight.w500,color: Colors.grey);
TextStyle size30W500Amber = TextStyle(fontSize: 30,fontWeight: FontWeight.w500,color: Colors.amber);
TextStyle size30W500Orange = TextStyle(fontSize: 30,fontWeight: FontWeight.w500,color: Colors.orange);
TextStyle size30W500Black = TextStyle(fontSize: 30,fontWeight: FontWeight.w500,color: Colors.black);
TextStyle size30W500GreyOpacity = TextStyle(fontSize: 30,fontWeight: FontWeight.w500,color: Colors.grey.shade900.withOpacity(0.5));
TextStyle size27W500YellowOpacity4 = TextStyle(fontSize: 27,fontWeight: FontWeight.w500,color: Colors.yellow.withOpacity(0.4));
TextStyle size30W500Green = TextStyle(fontSize: 30,fontWeight: FontWeight.w500,color: Colors.green);
TextStyle size50W500Cyan = TextStyle(fontSize: 50,fontWeight: FontWeight.w500,color: Colors.cyan);
TextStyle size50W500Orange = TextStyle(fontSize: 50,fontWeight: FontWeight.w500,color: Colors.orange);
TextStyle size40W500Orange = TextStyle(fontSize: 40,fontWeight: FontWeight.w500,color: Colors.orange);
TextStyle size40AmberW500 = TextStyle(fontSize: 40,fontWeight: FontWeight.w500,color: Colors.amber);




text20(String title){
  return Text(title,style: size20,maxLines: 1,overflow: TextOverflow.ellipsis,);
}

borderRadius(double a,double b,double c,double d,){
  return BorderRadius.only(topLeft: Radius.circular(a),topRight: Radius.circular(b),bottomRight: Radius.circular(c),bottomLeft: Radius.circular(d));
}

