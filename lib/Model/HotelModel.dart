import 'package:cloud_firestore/cloud_firestore.dart';

class HotelModel {
  String userProof;
  String hotelImage;
  String hotelName;
  String hotelMobileNo;
  String hotelEmail;
  String hotelAddress;
  String hotelPinCode;
  String hotelOpen;
  String hotelClose;
  String hotelCapacity;
  String hotelTables;
  String hotelRequestStatus;
  String hotelRequestRejectReason;
  String hotelTableCreated;
  String hotelReRequested;
  String hotelHolidayDate;
  String hotelHolidayReason;
  String hotelRatting;

  HotelModel({
    this.userProof,
    this.hotelImage,
    this.hotelName,
    this.hotelMobileNo,
    this.hotelEmail,
    this.hotelAddress,
    this.hotelPinCode,
    this.hotelOpen,
    this.hotelClose,
    this.hotelCapacity,
    this.hotelTables,
    this.hotelRequestStatus,
    this.hotelRequestRejectReason,
    this.hotelTableCreated,
    this.hotelReRequested,
    this.hotelHolidayDate,
    this.hotelHolidayReason,
    this.hotelRatting
  });

  factory HotelModel.fromJson(Map<String, dynamic> json) {
    return HotelModel(
      userProof: json['UserProofImage'],
      hotelImage: json['HotelImage'],
      hotelName: json['HotelName'],
      hotelMobileNo: json['HotelTelephoneNo'],
      hotelEmail: json['HotelEmail'],
      hotelAddress: json['HotelAddress'],
      hotelPinCode: json['HotelPinCode'],
      hotelOpen: json['HotelOpenTime'],
      hotelClose: json['HotelCloseTime'],
      hotelCapacity: json['HotelPersonsCapacity'],
      hotelTables: json['HotelTotalNumbersOfTables'],
      hotelRequestStatus: json['HotelRequestStatus'],
      hotelRequestRejectReason: json['HotelRequestRejectReason'],
      hotelTableCreated: json['HotelTableCreated'],
      hotelReRequested: json['HotelReRequested'],
      hotelHolidayDate : json['HotelHolidayDate'],
      hotelHolidayReason: json['HotelHolidayReason'],
      hotelRatting: json['HotelRatting'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['UserProofImage'] = this.userProof;
    data['HotelImage'] = this.hotelImage;
    data['HotelName'] = this.hotelName;
    data['HotelTelephoneNo'] = this.hotelMobileNo;
    data['HotelEmail'] = this.hotelEmail;
    data['HotelAddress'] = this.hotelAddress;
    data['HotelPinCode'] = this.hotelPinCode;
    data['HotelOpenTime'] = this.hotelOpen;
    data['HotelCloseTime'] = this.hotelClose;
    data['HotelPersonsCapacity'] = this.hotelCapacity;
    data['HotelTotalNumbersOfTables'] = this.hotelTables;
    data['HotelRequestStatus'] = this.hotelRequestStatus;
    data['HotelRequestRejectReason'] = this.hotelRequestRejectReason;
    data['HotelTableCreated'] = this.hotelTableCreated;
    data['HotelReRequested'] = this.hotelReRequested;
    data['HotelHolidayDate'] = this.hotelHolidayDate;
    data['HotelHolidayReason'] = this.hotelHolidayReason;
    data['HotelRatting'] = this.hotelRatting;
    return data;
  }

  HotelModel.fromQuerySnapshot(QueryDocumentSnapshot snap)
       :
        this.userProof = snap.data()['UserProofImage'],
        this.hotelImage = snap.data()['HotelImage'],
        this.hotelName = snap.data()['HotelName'],
        this.hotelMobileNo = snap.data()['HotelTelephoneNo'],
        this.hotelEmail = snap.data()['HotelEmail'],
        this.hotelAddress = snap.data()['HotelAddress'],
        this.hotelPinCode = snap.data()['HotelPinCode'],
        this.hotelOpen = snap.data()['HotelOpenTime'],
        this.hotelClose = snap.data()['HotelCloseTime'],
        this.hotelCapacity = snap.data()['HotelPersonsCapacity'],
        this.hotelTables = snap.data()['HotelTotalNumbersOfTables'],
        this.hotelRequestStatus = snap.data()['HotelRequestStatus'],
        this.hotelRequestRejectReason = snap.data()['HotelRequestRejectReason'],
        this.hotelTableCreated = snap.data()['HotelTableCreated'],
        this.hotelReRequested = snap.data()['HotelReRequested'],
        this.hotelHolidayDate = snap.data()['HotelHolidayDate'],
        this.hotelHolidayReason = snap.data()['HotelHolidayReason'],
        this.hotelRatting = snap.data()['HotelRatting'];



// UserModel.fromDataSnapshot(QuerySnapshot snap)
//     : this.key = snap.,
//         this.userEmail = snap.value["userEmail"],
//         this.userMobileNo = snap.value["userMobileNo"],
//         this.userName = snap.value["userName"],
//         this.userPassword = snap.value["userPassword"],
//         this.userProfile = snap.value["userProfile"],
//         this.userType = snap.value["userType"];
}

