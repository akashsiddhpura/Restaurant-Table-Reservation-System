import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
    String key;
    String userEmail;
    String userMobileNo;
    String userName;
    String userPassword;
    String userImage;
    String userType;
    String key1;

    UserModel({this.key1, this.userEmail, this.userMobileNo, this.userName, this.userPassword, this.userImage, this.userType});

    factory UserModel.fromJson(Map<String, dynamic> json) {
        return UserModel(
            key1: json['Key'],
            userEmail: json['UserEmail'],
            userMobileNo: json['UserMobileNo'],
            userName: json['UserName'],
            userPassword: json['UserPassword'],
            userImage: json['UserImage'],
            userType: json['UserType'],
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['Key'] = this.key1;
        data['UserEmail'] = this.userEmail;
        data['UserMobileNo'] = this.userMobileNo;
        data['UserName'] = this.userName;
        data['UserPassword'] = this.userPassword;
        data['UserImage'] = this.userImage;
        data['UserType'] = this.userType;
        return data;
    }

    UserModel.fromQuerySnapshot(QueryDocumentSnapshot snap)
        : this.key = snap.id,
            this.key1 = snap.data()['Key'],
            this.userEmail = snap.data()['UserEmail'],
            this.userMobileNo = snap.data()['UserMobileNo'],
            this.userName = snap.data()['UserName'],
            this.userPassword = snap.data()['UserPassword'],
            this.userImage = snap.data()['UserImage'],
            this.userType = snap.data()['UserType'];

    // UserModel.fromDataSnapshot(QuerySnapshot snap)
    //     : this.key = snap.,
    //         this.userEmail = snap.value["userEmail"],
    //         this.userMobileNo = snap.value["userMobileNo"],
    //         this.userName = snap.value["userName"],
    //         this.userPassword = snap.value["userPassword"],
    //         this.userProfile = snap.value["userProfile"],
    //         this.userType = snap.value["userType"];
}