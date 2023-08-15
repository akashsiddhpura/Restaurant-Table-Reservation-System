// import 'package:flutter/material.dart';
// import 'file:///D:/flutter_projects/reserved_table/lib/Widgets/Widgets.dart';
// import 'package:reserved_table/main.dart';
//
// class OwnerProfilePage extends StatefulWidget {
//   @override
//   _OwnerProfilePageState createState() => _OwnerProfilePageState();
// }
//
// class _OwnerProfilePageState extends State<OwnerProfilePage> {
//
//   TextEditingController _name = new TextEditingController()..text = MyApp().controller.hotelModel.userName;
//   TextEditingController _mobile = new TextEditingController()..text = MyApp().controller.hotelModel.userMobileNo;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         child: Stack(
//           children: [
//             Container(
//               height: 300,
//               width: double.infinity,
//               child: Image.asset("assets/LoginPage.jpg", fit: BoxFit.cover),
//             ),
//             Positioned(
//               top: 25,
//               right: 10,
//               child: MaterialButton(
//                 minWidth: 5,
//                 onPressed: (){},
//                 child: Icon(Icons.save,size: 40,),
//               ),
//             ),
//             Positioned(
//                 top: 30,
//                 left: 20,
//                 child: Text(MyApp().controller.hotelModel.userEmail,style: TextStyle(fontSize: 20),)
//             ),
//             Column(
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.only(top: 130),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Stack(
//                         children: [
//                           Container(
//                             height: 150,
//                             width: 150,
//                             child: CircleAvatar(
//                               backgroundImage: _updateImageFile == null
//                                   ? NetworkImage(
//                                   MyApp().controller.userModel.userProfile)
//                                   : FileImage(_updateImageFile),
//                             ),
//                           ),
//                           Positioned(
//                               bottom: 0,
//                               right: 0,
//                               child: MaterialButton(
//                                 minWidth: 5,
//                                 color: Colors.black,
//                                 onPressed: () {
//                                   pickUpdatedImage();
//                                 },
//                                 child: Icon(Icons.edit),
//                               ))
//                         ],
//                       )
//                     ],
//                   ),
//                 ),
//                 Expanded(
//                   child: Container(
//                     child: Column(
//                       children: [
//                         buildRow2("Name", _name, "Enter Name"),
//                         buildRow2("Mobile No", _mobile, "Enter Mobile Number"),
//                         Spacer(),
//                         Container(
//                             height: 60,
//                             margin: EdgeInsets.only( top: 10,left: 10,right: 10),
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(5.0),
//                             ),
//                             child: Card(
//                                 elevation: 5.0,shadowColor: Colors.black,color: Colors.redAccent,
//                                 child: Center(child: Text("Delete"))))
//                       ],
//                     ),
//                   ),
//                 )
//               ],
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
