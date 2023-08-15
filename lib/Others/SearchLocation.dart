// import 'dart:async';
//
// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:flutter_google_places/flutter_google_places.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:google_maps_webservice/places.dart';
//
//
// class GoogleMapsDemo extends StatefulWidget {
//   @override
//   _GoolgeMapsDemoState createState() => _GoolgeMapsDemoState();
// }
//
// class _GoolgeMapsDemoState extends State<GoogleMapsDemo> {
//   Completer<GoogleMapController> _controller = Completer();
//   final Map<String, Marker> _markers = {};
//   Prediction prediction;
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: const Text('Locations'),
//           backgroundColor: Colors.green[500],
//           actions: [
//             Padding(
//               padding: EdgeInsets.only(right: 20),
//               child: InkResponse(
//                 child: Icon(Icons.search),
//                 onTap: predictions,
//               ),
//             )
//           ],
//         ),
//         body: Column(
//           children: [
//             Expanded(
//               flex: 9,
//               child: GoogleMap(
//                 mapType: MapType.normal,
//                 initialCameraPosition: _kGooglePlex,
//                 onMapCreated: (GoogleMapController controller) {
//                   _controller.complete(controller);
//                 },
//                 onTap: (argument) {
//                   _markers.clear();
//                   _goToTheLake(argument.latitude, argument.longitude);
//                   setState(() {
//                     var marker = Marker(
//                         markerId: MarkerId("d"),
//                         position: LatLng(argument.latitude, argument.longitude));
//                     _markers["d"] = marker;
//                   });
//                 },
//                 markers: _markers.values.toSet(),
//               ),
//             ),
//             // Expanded(
//             //     flex: 1,
//             //     child: Text(prediction.description))
//           ],
//         ),
//       ),
//     );
//   }
//
//   static final CameraPosition _kGooglePlex = CameraPosition(
//     target: LatLng(20.593683, 78.962883),
//     zoom: 14.4746,
//   );
//
//   static final CameraPosition _kLake = CameraPosition(
//       bearing: 192.8334901395799,
//       target: LatLng(21.28937436, 798.66210938),
//       tilt: 59.440717697143555,
//       zoom: 19.151926040649414);
//
//   Future<void> _goToTheLake(lat, long) async {
//     final GoogleMapController controller = await _controller.future;
//     controller.animateCamera(CameraUpdate.newCameraPosition(
//         CameraPosition(target: LatLng(lat, long), zoom: 14.4746)));
//   }
//
//   predictions() async {
//     prediction = await PlacesAutocomplete.show(
//         context: context,
//         apiKey: 'AIzaSyDJdsa3g6TdmOCfwJs2A5_xZbTWpKjezCk',
//         mode: Mode.fullscreen,
//         // Mode.overlay
//         language: "en",
//         components: [Component(Component.country, "in")]);
//
//     _getLatLng(prediction);
//   }
//
//   void _getLatLng(Prediction prediction) async {
//     GoogleMapsPlaces _places = new GoogleMapsPlaces(
//         apiKey:
//         'AIzaSyDJdsa3g6TdmOCfwJs2A5_xZbTWpKjezCk'); //Same API_KEY as above
//     PlacesDetailsResponse detail =
//     await _places.getDetailsByPlaceId(prediction.placeId);
//     double latitude = detail.result.geometry.location.lat;
//     double longitude = detail.result.geometry.location.lng;
//     String address = prediction.description;
//
//     // _goToTheLake(latitude, longitude);
//
//     setState(() {
//       setState(() {
//         _goToTheLake(latitude, longitude);
//         var marker = Marker(
//             markerId: MarkerId("d"), position: LatLng(latitude, longitude));
//         _markers["d"] = marker;
//       });
//     });
//   }
// }
