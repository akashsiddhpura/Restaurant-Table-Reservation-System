import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:reserved_table/Constance/Colors.dart';
import 'package:reserved_table/Constance/Styles.dart';
import 'package:reserved_table/main.dart';

class ScannerPage extends StatefulWidget {
  final int index;
  final String customerKey;
  final String hotelKey;
  final String tableKey;
  final String family;
  final String code;
  final String tableNo;

  ScannerPage(
      {this.index,
        this.tableKey,
        this.customerKey,
        this.hotelKey,
        this.family,
        this.code,
        this.tableNo});

  @override
  _ScannerPageState createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> {
  String result;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    result = widget.code;
    getTableKeyList();
  }

  List tableKeysFamily = [];

  void getTableKeyList() {
    String s = widget.tableNo;
    List l = s.split("-");
    for (int i = 0; i < l.length; i++) {
      String s2 = "KeyTableNumber" + l[i];
      tableKeysFamily.add(s2);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Container(
        height: 70,
        width:70,
        child: FloatingActionButton(backgroundColor: floatingButtonBackground,
          onPressed: () {
            _scanQR(widget.index, widget.code, widget.customerKey,
                widget.hotelKey, widget.tableKey);
          },
          child: Icon(Icons.qr_code_scanner,size: 40,),
        ),
      ),
      body: Container(
        child: Center(child: Text("Scan, When you reach hotel...",style: size20AmberW500,)),
      ),
    );
  }

  Future _scanQR(int index, String code, String key, String keyHotel,
      String keyTable) async {
    DateTime firstTime = DateTime.now();
    List firstTimeList = firstTime.toString().split(".");
    String startTime = firstTimeList[0];
    DateTime secondTime = DateTime.now().add(Duration(hours: 1));
    List secondTimeList = secondTime.toString().split(".");
    String endTime = secondTimeList[0];

    try {
      String qrResult = await BarcodeScanner.scan();
      setState(() {
        result = qrResult;
      });

      if (result == code) {
        scanDataAndAddHistory(index, key, keyHotel, keyTable,
            startTime.toString(), endTime.toString());
      } else {
        print(">>>>>> not match code");
        Get.snackbar("Error", "Code Not Match..");
      }
    } on PlatformException catch (ex) {
      if (ex.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          result = "Camera permission was denied";
        });
      } else {
        setState(() {
          result = "Unknown Error $ex";
        });
      }
    } on FormatException {
      setState(() {
        result = "You pressed the back button before scanning anything";
      });
    } catch (ex) {
      setState(() {
        result = "Unknown Error $ex";
      });
    }
  }

  void scanDataAndAddHistory(int index, String key, String keyHotel,
      String keyTable, String startTime, String endTime) {
    MyApp().controller.handleSubmit(context);
    MyApp().controller.scanData(index, key, keyHotel, widget.customerKey,
        keyTable, startTime, endTime, widget.family, tableKeysFamily);
  }
}