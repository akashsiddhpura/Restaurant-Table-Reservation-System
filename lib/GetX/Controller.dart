import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_auth/email_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:reserved_table/Admin/HomePage.dart';
import 'package:reserved_table/GetX/Shared%20Preferences.dart';
import 'package:reserved_table/Hotel%20Owner/My%20Hotel.dart';
import 'package:reserved_table/Hotel%20Owner/RequestCustomerPage.dart';
import 'package:reserved_table/Hotel%20Owner/Status%20Page.dart';
import 'package:reserved_table/Hotel Owner/AcceptForFamily.dart';
import 'package:reserved_table/Login%20&%20Sign%20Up/Login/Login.dart';
import 'package:reserved_table/Login%20&%20Sign%20Up/SignUp/Email%20Verification.dart';
import 'package:reserved_table/Model/HotelModel.dart';
import 'package:reserved_table/Model/UserModel.dart';
import 'package:reserved_table/User/HomePage.dart';
import 'package:reserved_table/Widgets/Widgets.dart';

class StateManagementController extends GetxController {
  final customerLength = 0.obs;
  final userRequestLength = 0.obs;

  getLengths() {
    FirebaseFirestore.instance
        .collection("Users")
        .doc(userModel.key1)
        .collection("Accepted")
        .where("DinnerStatus", isEqualTo: "Pending")
        .snapshots()
        .listen((QuerySnapshot event) {
      getCustomerLength(event.docs.length);
    });

    FirebaseFirestore.instance
        .collection("Users")
        .doc(userModel.key1)
        .collection("UserRequest")
        .snapshots()
        .listen((QuerySnapshot event) {
      // getUserRequestLength(event.docs.length);
      userRequestLength.value = event.docs.length;
    });
    print('object' + userRequestLength.value.toString());
  }

  getCustomerLength(int length) {
    customerLength.value = length;
  }

  getUserRequestLength(int length) {
    userRequestLength.value = length;
  }

  final formKey = GlobalKey<FormState>();
  final generateCodeCounter = 0.obs;
  var list = [];
  var customers = [];

  @override
  void onInit() {
    firebaseUser.bindStream(auth.authStateChanges());

    super.onInit();
  }

  CollectionReference ownerRequestReference = FirebaseFirestore.instance
      .collection("Users")
      .doc("admin")
      .collection("Owner Request");

  CollectionReference ownerRejectedReference = FirebaseFirestore.instance
      .collection("Users")
      .doc("admin")
      .collection("Rejected Request");

  CollectionReference ownerAcceptedReference = FirebaseFirestore.instance
      .collection("Users")
      .doc("admin")
      .collection("Accepted Request");

  FirebaseAuth auth = FirebaseAuth.instance;
  Rx<User> firebaseUser = Rx<User>();
  UserModel userModel;
  HotelModel hotelModel;

  String get user => firebaseUser.value?.email;
  final GlobalKey<State> globalKey = new GlobalKey<State>();
  var obscureText = true;
  var obscureText2 = true;

  // For User
  final _selectedIndexUser = 0.obs;

  get selectedIndexUser => this._selectedIndexUser.value;

  set selectedIndexUser(index) => this._selectedIndexUser.value = index;

  // For Owner
  final _selectedIndexOwner = 0.obs;

  get selectedIndexOwner => this._selectedIndexOwner.value;

  set selectedIndexOwner(index) => this._selectedIndexOwner.value = index;

  // For Admin
  final _selectedIndexAdmin = 0.obs;

  get selectedIndexAdmin => this._selectedIndexAdmin.value;

  set selectedIndexAdmin(index) => this._selectedIndexAdmin.value = index;

  void toggle() {
    if (obscureText) {
      obscureText = false;
    } else {
      obscureText = true;
    }
    update();
  }

  void toggle2() {
    if (obscureText2) {
      obscureText2 = false;
    } else {
      obscureText2 = true;
    }
    update();
  }

  Future<void> handleSubmit(BuildContext context) async {
    try {
      Dialogs.showLoadingDialog(context, globalKey);
      Navigator.of(globalKey.currentContext, rootNavigator: true).pop();
    } catch (error) {
      print(error);
    }
  }

  void sendOtp(String email, String userType) async {
    EmailAuth.sessionName = "Company Names";
    // var result = await EmailAuth.sendOtp(receiverMail: email,).whenComplete(() {
    //   Navigator.of(globalKey.currentContext, rootNavigator: true).pop();
      Get.to(()=>VerifyOTPForSignUpPage(email: email, userType: userType));
    // });
    // print("Result OTP Send >>> " + result.toString());
    // if (result) {
    //   print('OTP send successfully');
    // } else {
    //   print('OTP not sent ! try again');
    // }
  }

  Future<void> checkUserExistOrNot(String email, String userType) async {
    await FirebaseAuth.instance
        .fetchSignInMethodsForEmail(email)
        .then((List providers) async {
      if (providers[0].toString() == 'password') {
        print('User Found');
        Navigator.of(globalKey.currentContext, rootNavigator: true).pop();
        Get.snackbar(
            "Error while creating account", "This user was already exist..");
      } else
        print('>>User Not Found');
    }).catchError((onError) {
      sendOtp(email, userType);
      print('***User Not Found');
    });
  }

  void registerUserAccount(String userImage, String name, String email,
      String mobileNo, String password, String userType) async {
    final databaseReference = FirebaseFirestore.instance;
    await auth
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((value) async {
      await value.user.updateProfile(displayName: name, photoURL: userImage);
      databaseReference.collection('Users').doc(value.user.uid.toString()).set({
        "Key": value.user.uid.toString(),
        "UserName": name,
        "UserImage": userImage,
        "UserEmail": email,
        "UserMobileNo": mobileNo,
        "UserPassword": password,
        "UserType": userType,
      }).then((value) {
        Navigator.of(globalKey.currentContext, rootNavigator: true).pop();
        FirebaseFirestore.instance
            .collection('Users')
            .where('UserEmail', isEqualTo: email)
            .get()
            .then((QuerySnapshot value2) {
          userModel = UserModel.fromQuerySnapshot(value2.docs.elementAt(0));
          Preferences.saveUser(userModel);

          Get.offAll(() => UserHomePage());
        }).catchError((onError) {
          print('>> 1');
          Navigator.of(globalKey.currentContext, rootNavigator: true).pop();
          Get.snackbar("Error while creating account ", onError.message);
        });
      }).catchError(
        (onError) {
          print('>> 2');
          Navigator.of(globalKey.currentContext, rootNavigator: true).pop();
          Get.snackbar("Error while creating account ", onError.message);
        },
      );
    }).catchError(
      (onError) {
        print('>> 3');
        Navigator.of(globalKey.currentContext, rootNavigator: true).pop();
        Get.snackbar("Error while creating account ", onError.message);
      },
    );
  }

  void registerOwnerAccount(
      String name,
      String email,
      String mobileNo,
      String password,
      String userType,
      String userImage,
      String userProofImage,
      String hotelImage,
      String hotelName,
      String hotelTelephoneNo,
      String hotelEmail,
      String hotelAddress,
      String hotelPinCode,
      String hotelTotalNumbersOfTables,
      String hotelPersonsCapacity,
      String hotelOpenTime,
      String hotelCloseTime,
      String reRequested) async {
    final databaseReference = FirebaseFirestore.instance;
    await auth
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((value) async {
      await value.user.updateProfile(displayName: name, photoURL: userImage);
      databaseReference.collection('Users').doc(value.user.uid.toString()).set({
        "Key": value.user.uid.toString(),
        "UserName": name,
        "UserEmail": email,
        "UserMobileNo": mobileNo,
        "UserPassword": password,
        "UserType": userType,
        "UserImage": userImage,
        "UserProofImage": userProofImage,
        "HotelImage": hotelImage,
        "HotelName": hotelName,
        "HotelTelephoneNo": hotelTelephoneNo,
        "HotelEmail": hotelEmail,
        "HotelAddress": hotelAddress,
        "HotelPinCode": hotelPinCode,
        "HotelTotalNumbersOfTables": hotelTotalNumbersOfTables,
        "HotelPersonsCapacity": hotelPersonsCapacity,
        "HotelOpenTime": hotelOpenTime,
        "HotelCloseTime": hotelCloseTime,
        "HotelRequestStatus": "Pending",
        "HotelRequestRejectReason": "",
        "HotelTableCreated": "No",
        "HotelReRequested": reRequested,
        "HotelHolidayDate": "",
        "HotelHolidayReason": "",
        "HotelRatting": "0.0",
      }).then((value) {
        FirebaseFirestore.instance
            .collection('Users')
            .where('UserEmail', isEqualTo: email)
            .get()
            .then((QuerySnapshot value) {
          hotelModel = HotelModel.fromQuerySnapshot(value.docs.elementAt(0));
          userModel = UserModel.fromQuerySnapshot(value.docs.elementAt(0));
          Preferences.saveUser(userModel);
          Preferences.saveOwner(hotelModel);
          FirebaseFirestore.instance
              .collection('Users')
              .doc('admin')
              .collection("Owner Request")
              .doc(value.docs.elementAt(0).data()["Key"])
              .set(jsonDecode(jsonEncode(value.docs.elementAt(0).data())))
              .then((value3) {
            if (reRequested == "Yes") {
              FirebaseFirestore.instance
                  .collection('Users')
                  .doc('admin')
                  .collection("Rejected Request")
                  .where("UserEmail",
                      isEqualTo: value.docs.elementAt(0)["UserEmail"])
                  .get()
                  .then((QuerySnapshot value4) {
                print(value4.docs.elementAt(0)["Key"]);
                FirebaseFirestore.instance
                    .collection('Users')
                    .doc('admin')
                    .collection("Rejected Request")
                    .doc(value4.docs.elementAt(0)["Key"])
                    .delete()
                    .then((value) {
                  Navigator.of(globalKey.currentContext, rootNavigator: true)
                      .pop();
                  Get.offAll(() => StatusPageForOwner());
                }).catchError((onError) {
                  print(">>> 1 ");
                  Navigator.of(globalKey.currentContext, rootNavigator: true)
                      .pop();
                  Get.snackbar("Error", onError.message);
                });
              }).catchError((onError) {
                print('>> 2 Every Owner Not Re Requested So.....');
                Navigator.of(globalKey.currentContext, rootNavigator: true)
                    .pop();
                Get.snackbar("Error", onError.message);
              });
            } else {
              Navigator.of(globalKey.currentContext, rootNavigator: true).pop();
              Get.offAll(() => StatusPageForOwner());
            }

            // Navigator.of(globalKey.currentContext, rootNavigator: true).pop();
            // Get.offAll(()=>StatusPageForOwner());
          }).catchError((onError) {
            print('>> 3');
            Navigator.of(globalKey.currentContext, rootNavigator: true).pop();
            Get.snackbar("Error", onError.message);
          });
        }).catchError((onError) {
          print('>> 4');
          Navigator.of(globalKey.currentContext, rootNavigator: true).pop();
          Get.snackbar("Error", onError.message);
        });
      }).catchError((onError) {
        print('>> 5');
        Navigator.of(globalKey.currentContext, rootNavigator: true).pop();
        Get.snackbar("Error", onError.message);
      });
    }).catchError(
      (onError) {
        print('>> 6');
        Navigator.of(globalKey.currentContext, rootNavigator: true).pop();
        Get.snackbar("Error while creating account ", onError.message);
      },
    );
  }

  void updateUserData(
      String name, String mobile, String key, String email, String image) {
    if (image == "") {
      FirebaseFirestore.instance
          .collection('Users')
          .doc(key)
          .update({"UserName": name, "UserMobileNo": mobile}).then((value) {
        FirebaseFirestore.instance
            .collection('Users')
            .where('UserEmail', isEqualTo: email)
            .get()
            .then((QuerySnapshot value) {
          userModel = UserModel.fromQuerySnapshot(value.docs.elementAt(0));
          Preferences.saveUser(userModel);
          Navigator.of(globalKey.currentContext, rootNavigator: true).pop();
          Get.offAll(() => UserHomePage());
        }).catchError((onError) {
          print(">> 1");
          Navigator.of(globalKey.currentContext, rootNavigator: true).pop();
          Get.snackbar("Error while Update Profile ", onError.message);
        });
      }).catchError((onError) {
        print(">> 2");
        Navigator.of(globalKey.currentContext, rootNavigator: true).pop();
        Get.snackbar("Error while Update Profile ", onError.message);
      });
    } else {
      FirebaseFirestore.instance.collection('Users').doc(key).update({
        "UserName": name,
        "UserMobileNo": mobile,
        "UserImage": image
      }).then((value) {
        FirebaseFirestore.instance
            .collection('Users')
            .where('UserEmail', isEqualTo: email)
            .get()
            .then((QuerySnapshot value) {
          userModel = UserModel.fromQuerySnapshot(value.docs.elementAt(0));
          Preferences.saveUser(userModel);
          Navigator.of(globalKey.currentContext, rootNavigator: true).pop();
          Get.offAll(() => UserHomePage());
        }).catchError((onError) {
          print(">> 1");
          Navigator.of(globalKey.currentContext, rootNavigator: true).pop();
          print('Data Error' + onError.toString());
        });
      }).catchError((onError) {
        print(">> 2");
        Navigator.of(globalKey.currentContext, rootNavigator: true).pop();
        Get.snackbar("Error while Update Profile ", onError.message);
      });
    }
  }

  void updateOwnerHotelData(
    String key,
    String userImage,
    String userName,
    String userMobile,
    String userEmail,
    String hotelImage,
    String hotelName,
    String hotelMobile,
    String hotelEmail,
    String hotelAddress,
    String hotelPinCode,
    String hotelOpen,
    String hotelClose,
  ) {
    if (userImage == "" && hotelImage == "") {
      FirebaseFirestore.instance.collection('Users').doc(key).update({
        "UserName": userName,
        "UserMobileNo": userMobile,
        "HotelName": hotelName,
        "HotelTelephoneNo": hotelMobile,
        "HotelEmail": hotelEmail,
        "HotelAddress": hotelAddress,
        "HotelPinCode": hotelPinCode,
        "HotelOpenTime": hotelOpen,
        "HotelCloseTime": hotelClose,
      }).then((value) {
        FirebaseFirestore.instance
            .collection('Users')
            .where('UserEmail', isEqualTo: userEmail)
            .get()
            .then((QuerySnapshot value) {
          userModel = UserModel.fromQuerySnapshot(value.docs.elementAt(0));
          hotelModel = HotelModel.fromQuerySnapshot(value.docs.elementAt(0));
          Preferences.saveOwner(hotelModel);
          Preferences.saveUser(userModel);
          Navigator.of(globalKey.currentContext, rootNavigator: true).pop();
          Get.offAll(() => HotelHomePage());
        }).catchError((onError) {
          print(">> 1");
          Navigator.of(globalKey.currentContext, rootNavigator: true).pop();
          print('Data Error' + onError.toString());
        });
      }).catchError((onError) {
        print(">> 2");
        Navigator.of(globalKey.currentContext, rootNavigator: true).pop();
        print('Data Error' + onError.toString());
      });
    } else if (userImage != "" && hotelImage == "") {
      FirebaseFirestore.instance.collection('Users').doc(key).update({
        "UserImage": userImage,
        "UserName": userName,
        "UserMobileNo": userMobile,
        "HotelName": hotelName,
        "HotelTelephoneNo": hotelMobile,
        "HotelEmail": hotelEmail,
        "HotelAddress": hotelAddress,
        "HotelPinCode": hotelPinCode,
        "HotelOpenTime": hotelOpen,
        "HotelCloseTime": hotelClose,
      }).then((value) {
        FirebaseFirestore.instance
            .collection('Users')
            .where('UserEmail', isEqualTo: userEmail)
            .get()
            .then((QuerySnapshot value) {
          userModel = UserModel.fromQuerySnapshot(value.docs.elementAt(0));
          hotelModel = HotelModel.fromQuerySnapshot(value.docs.elementAt(0));
          Preferences.saveOwner(hotelModel);
          Preferences.saveUser(userModel);
          Navigator.of(globalKey.currentContext, rootNavigator: true).pop();
          Get.offAll(() => HotelHomePage());
        }).catchError((onError) {
          print(">> 1");
          Navigator.of(globalKey.currentContext, rootNavigator: true).pop();
          Get.snackbar("Error", onError.message);
        });
      }).catchError((onError) {
        print(">> 2");
        Navigator.of(globalKey.currentContext, rootNavigator: true).pop();
        Get.snackbar("Error", onError.message);
      });
    } else if (hotelImage != "" && userImage == "") {
      FirebaseFirestore.instance.collection('Users').doc(key).update({
        "UserName": userName,
        "UserMobileNo": userMobile,
        "HotelImage": hotelImage,
        "HotelName": hotelName,
        "HotelTelephoneNo": hotelMobile,
        "HotelEmail": hotelEmail,
        "HotelAddress": hotelAddress,
        "HotelPinCode": hotelPinCode,
        "HotelOpenTime": hotelOpen,
        "HotelCloseTime": hotelClose,
      }).then((value) {
        FirebaseFirestore.instance
            .collection('Users')
            .where('UserEmail', isEqualTo: userEmail)
            .get()
            .then((QuerySnapshot value) {
          userModel = UserModel.fromQuerySnapshot(value.docs.elementAt(0));
          hotelModel = HotelModel.fromQuerySnapshot(value.docs.elementAt(0));
          Preferences.saveOwner(hotelModel);
          Preferences.saveUser(userModel);
          Navigator.of(globalKey.currentContext, rootNavigator: true).pop();
          Get.offAll(() => HotelHomePage());
        }).catchError((onError) {
          print(">> 1");
          Navigator.of(globalKey.currentContext, rootNavigator: true).pop();
          Get.snackbar("Error", onError.message);
        });
      }).catchError((onError) {
        print(">> 2");
        Navigator.of(globalKey.currentContext, rootNavigator: true).pop();
        Get.snackbar("Error", onError.message);
      });
    } else if (userImage != "" && hotelImage != "") {
      FirebaseFirestore.instance.collection('Users').doc(key).update({
        "UserImage": userImage,
        "UserName": userName,
        "UserMobileNo": userMobile,
        "HotelImage": hotelImage,
        "HotelName": hotelName,
        "HotelTelephoneNo": hotelMobile,
        "HotelEmail": hotelEmail,
        "HotelAddress": hotelAddress,
        "HotelPinCode": hotelPinCode,
        "HotelOpenTime": hotelOpen,
        "HotelCloseTime": hotelClose,
      }).then((value) {
        FirebaseFirestore.instance
            .collection('Users')
            .where('UserEmail', isEqualTo: userEmail)
            .get()
            .then((QuerySnapshot value) {
          userModel = UserModel.fromQuerySnapshot(value.docs.elementAt(0));
          hotelModel = HotelModel.fromQuerySnapshot(value.docs.elementAt(0));
          Preferences.saveOwner(hotelModel);
          Preferences.saveUser(userModel);
          Navigator.of(globalKey.currentContext, rootNavigator: true).pop();
          Get.offAll(() => HotelHomePage());
        }).catchError((onError) {
          print(">> 1");
          Navigator.of(globalKey.currentContext, rootNavigator: true).pop();
          Get.snackbar("Error", onError.message);
        });
      }).catchError((onError) {
        print(">> 2");
        Navigator.of(globalKey.currentContext, rootNavigator: true).pop();
        Get.snackbar("Error", onError.message);
      });
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    return await auth.sendPasswordResetEmail(email: email).then((value) {
      Navigator.of(globalKey.currentContext, rootNavigator: true).pop();
      Future.delayed(Duration(seconds: 3), () {
        Get.offAll(() => LoginPage());
      });
      Get.snackbar("Password Reset email link is been sent", "Success");
    }).catchError((onError) {
      Navigator.of(globalKey.currentContext, rootNavigator: true).pop();
      Get.snackbar("Error In Email Reset", onError.message);
    });
  }

  void login(String email, String password) async {
    await auth
        .signInWithEmailAndPassword(email: email, password: password)
        .then((value) {
      FirebaseFirestore.instance
          .collection('Users')
          .where('UserEmail', isEqualTo: email)
          .get()
          .then((QuerySnapshot value) {
        FirebaseFirestore.instance
            .collection('Users').doc(value.docs.elementAt(0).data()["Key"]).update({"UserPassword":password}).then((value2){
          if (value.docs.elementAt(0).data()['UserType'] == 'Admin') {
            Navigator.of(globalKey.currentContext, rootNavigator: true).pop();
            Get.offAll(() => AdminHomePage());
          } else if (value.docs.elementAt(0).data()['UserType'] == 'User') {
            userModel = UserModel.fromQuerySnapshot(value.docs.elementAt(0));
            Preferences.saveUser(userModel);
            Navigator.of(globalKey.currentContext, rootNavigator: true).pop();
            Get.offAll(() => UserHomePage());
          } else if (value.docs.elementAt(0).data()['UserType'] ==
              'Hotel Owner') {
            userModel = UserModel.fromQuerySnapshot(value.docs.elementAt(0));
            hotelModel = HotelModel.fromQuerySnapshot(value.docs.elementAt(0));
            Preferences.saveOwner(hotelModel);
            Preferences.saveUser(userModel);

            if (value.docs.elementAt(0).data()['HotelRequestStatus'] ==
                'Pending') {
              Navigator.of(globalKey.currentContext, rootNavigator: true).pop();
              Get.offAll(() => StatusPageForOwner());
            } else if (value.docs.elementAt(0).data()['HotelRequestStatus'] ==
                'Rejected') {
              Navigator.of(globalKey.currentContext, rootNavigator: true).pop();
              Get.offAll(() => StatusPageForOwner());
            } else if (value.docs.elementAt(0).data()['HotelRequestStatus'] ==
                'Accepted') {
              if (value.docs.elementAt(0).data()['HotelTableCreated'] == 'Yes') {
                Navigator.of(globalKey.currentContext, rootNavigator: true).pop();
                Get.offAll(() => HotelHomePage());
              } else {
                Navigator.of(globalKey.currentContext, rootNavigator: true).pop();
                Get.offAll(() => StatusPageForOwner());
              }
              // print(value.docs.elementAt(0));
            }
          }
        }).catchError((onError){
          print(">> 0");
          Navigator.of(globalKey.currentContext, rootNavigator: true).pop();
          Get.snackbar("Error", onError.message);
        });

      }).catchError((onError) {
        print(">> 1");
        Navigator.of(globalKey.currentContext, rootNavigator: true).pop();
        Get.snackbar("Error", onError.message);
      });
    }).catchError((onError) {
      print(">> 2");
      Navigator.of(globalKey.currentContext, rootNavigator: true).pop();
      Get.snackbar("Error while sign in ", onError.message);
    });
  }

  void signOut() async {
    await auth.signOut().then((value) {
      Preferences.clear();
      Get.offAll(() => LoginPage());
      Get.snackbar("LogOut", "You are logged out successfully");
    }).catchError((onError) {
      Navigator.of(globalKey.currentContext, rootNavigator: true).pop();
      Get.snackbar("Credential Error", onError.message);
    });
  }

  void deleteUserAccount(String email, String pass) async {
    User user = auth.currentUser;
    AuthCredential credential =
        EmailAuthProvider.credential(email: email, password: pass);
    await user.reauthenticateWithCredential(credential).then((value) {
      value.user.delete().then((res) {
        Preferences.clear();
        Navigator.of(globalKey.currentContext, rootNavigator: true).pop();
        Get.offAll(() => LoginPage());
        Get.snackbar("Account Deleted", "Your Account Deleted Successfully.");
      }).catchError((onError) {
        print(">> 1");
        Navigator.of(globalKey.currentContext, rootNavigator: true).pop();
        Get.snackbar("Credential Error", onError.message);
      });
    }).catchError((onError) {
      print(">> 2");
      Navigator.of(globalKey.currentContext, rootNavigator: true).pop();
      Get.snackbar("Credential Error", onError.message);
    });
  }

  Future<void> rejectOwnerRequest(
      int index, String key, String rejectReason) async {
    QuerySnapshot qs = await ownerRequestReference.get();
    await ownerRequestReference.doc(key).get().then((value) {
      FirebaseFirestore.instance
          .collection('Users')
          .doc(value.data()["Key"])
          .update({
        "HotelRequestStatus": "Rejected",
        "HotelRequestRejectReason": rejectReason,
      }).then((value) {
        FirebaseFirestore.instance
            .collection("Users")
            .where("Key", isEqualTo: key)
            .get()
            .then((QuerySnapshot querySnapshot) {
          FirebaseFirestore.instance
              .collection('Users')
              .doc("admin")
              .collection("Rejected Request")
              .doc(key)
              .set(querySnapshot.docs.elementAt(0).data())
              .then((value) {
            qs.docs[index].reference.delete().then((value) {
              Navigator.of(globalKey.currentContext, rootNavigator: true).pop();
              Get.back();
              Get.snackbar("Rejected",
                  "${querySnapshot.docs.elementAt(0).data()["HotelName"]} is rejected successfully.");
            }).catchError((onError) {
              print(">> 1");
              Navigator.of(globalKey.currentContext, rootNavigator: true).pop();
              Get.snackbar("Error", onError.message);
            });
          }).catchError((onError) {
            print(">> 2");
            Navigator.of(globalKey.currentContext, rootNavigator: true).pop();
            Get.snackbar("Error", onError.message);
          });
        }).catchError((onError) {
          print(">> 3");
          Navigator.of(globalKey.currentContext, rootNavigator: true).pop();
          Get.snackbar("Error", onError.message);
        });
      }).catchError((onError) {
        print(">> 4");
        Navigator.of(globalKey.currentContext, rootNavigator: true).pop();
        Get.snackbar("Error", onError.message);
      });
    });
  }

  Future<void> acceptRequest(int index, String key) async {
    QuerySnapshot qs = await ownerRequestReference.get();
    await ownerRequestReference.doc(key).get().then((value) {
      FirebaseFirestore.instance.collection('Users').doc(key).update({
        "HotelRequestStatus": "Accepted",
      }).then((value) {
        FirebaseFirestore.instance
            .collection("Users")
            .where("Key", isEqualTo: key)
            .get()
            .then((QuerySnapshot querySnapshot) {
          FirebaseFirestore.instance
              .collection('Users')
              .doc("admin")
              .collection("Accepted Request")
              .doc(key)
              .set(querySnapshot.docs.elementAt(0).data())
              .then((value) {
            qs.docs[index].reference.delete().then((value) {
              Navigator.of(globalKey.currentContext, rootNavigator: true).pop();
              Get.snackbar("Accepted",
                  "${querySnapshot.docs.elementAt(0).data()["HotelName"]} is accepted successfully.");
            }).catchError((onError) {
              print(">> 1");
              Navigator.of(globalKey.currentContext, rootNavigator: true).pop();
              Get.snackbar("Error", onError.message);
            });
          }).catchError((onError) {
            print(">> 2");
            Navigator.of(globalKey.currentContext, rootNavigator: true).pop();
            Get.snackbar("Error", onError.message);
          });
        }).catchError((onError) {
          print(">> 3");
          Navigator.of(globalKey.currentContext, rootNavigator: true).pop();
          Get.snackbar("Error", onError.message);
        });
      }).catchError((onError) {
        print(">> 4");
        Navigator.of(globalKey.currentContext, rootNavigator: true).pop();
        Get.snackbar("Error", onError.message);
      });
    });
  }

  void tableCreatedYes() {
    FirebaseFirestore.instance
        .collection("Users")
        .doc(userModel.key1)
        .update({"HotelTableCreated": "Yes"}).then((value) {
      FirebaseFirestore.instance
          .collection('Users')
          .where('Key', isEqualTo: userModel.key1)
          .get()
          .then((QuerySnapshot value) {
        print(value.docs.elementAt(0).data());
        userModel = UserModel.fromQuerySnapshot(value.docs.elementAt(0));
        hotelModel = HotelModel.fromQuerySnapshot(value.docs.elementAt(0));
        Preferences.saveOwner(hotelModel);
        Preferences.saveUser(userModel);
        Navigator.of(globalKey.currentContext, rootNavigator: true).pop();
        Get.offAll(() => HotelHomePage());
      }).catchError((onError) {
        print(">> 1");
        Navigator.of(globalKey.currentContext, rootNavigator: true).pop();
        Get.snackbar("Error", onError.message);
      });
    }).catchError((onError) {
      print(">> 2");
      Navigator.of(globalKey.currentContext, rootNavigator: true).pop();
      Get.snackbar("Error", onError.message);
    });
  }

  void addHotelInSearch() {

    FirebaseFirestore.instance
        .collection('Users')
        .where('UserType', isEqualTo: "Hotel Owner")
        .where("HotelTableCreated", isEqualTo: "Yes")
        .snapshots()
        .listen((data) {
      list.clear();
      data.docs.forEach((doc) {
        list.add(doc.data());
      });
      // print(list);
      print(list.length);
        });
  }

  allCustomer() async {
    FirebaseFirestore.instance
        .collection("Users")
        .doc(userModel.key1)
        .collection("Accepted")
        .snapshots()
        .listen((data) {
      customers.clear();
      data.docs.forEach((doc) {
        customers.add(doc.data());
      });
    });
  }

  void mackRequest(
      int index,
      String keyTable,
      String tableNo,
      String name,
      String mobile,
      String totalPerson,
      String date,
      String time,
      String code) {
    final userRequest = FirebaseFirestore.instance
        .collection('Users')
        .doc(list[index]["Key"])
        .collection("UserRequest");
    DocumentReference collectionReference = userRequest.doc();
    String key = collectionReference.id;

    FirebaseFirestore.instance
        .collection("Users")
        .doc(userModel.key1)
        .collection("Requests")
        .doc(key)
        .set({
      "Key": key,
      "KeyUser": userModel.key1,
      "KeyHotel": list[index]["Key"],
      "KeyTable": keyTable,
      "HotelName": list[index]["HotelName"],
      "HotelImage": list[index]["HotelImage"],
      "HotelTotalNumbersOfTables": list[index]["HotelTotalNumbersOfTables"],
      "TableNumber": tableNo,
      "UserName": name,
      "MobileNo": mobile,
      "TotalPerson": totalPerson,
      "Time": time,
      "Date": date,
      "Code": code,
      "RejectionMessage": "",
      "RequestStatus": "Pending",
      "DinnerStatus": "Pending",
      "FamilyRequest": "No",
      "Arrived": "",
      "KeyTableArray": []
    }).then((value) {
      FirebaseFirestore.instance
          .collection('Users')
          .doc(list[index]["Key"])
          .collection("UserRequest")
          .doc(key)
          .set({
        "Key": key,
        "KeyUser": userModel.key1,
        "KeyHotel": list[index]["Key"],
        "KeyTable": keyTable,
        "HotelName": list[index]["HotelName"],
        "HotelImage": list[index]["HotelImage"],
        "HotelTotalNumbersOfTables": list[index]["HotelTotalNumbersOfTables"],
        "TableNumber": tableNo,
        "UserName": name,
        "MobileNo": mobile,
        "TotalPerson": totalPerson,
        "Time": time,
        "Date": date,
        "Code": code,
        "RejectionMessage": "",
        "RequestStatus": "Pending",
        "DinnerStatus": "Pending",
        "FamilyRequest": "No",
        "Arrived": "",
        "KeyTableArray": []
      }).then((value) {
        Navigator.of(globalKey.currentContext, rootNavigator: true).pop();
        Get.offAll(() => UserHomePage());
      }).catchError((onError) {
        print(">> 1");
        Navigator.of(globalKey.currentContext, rootNavigator: true).pop();
        Get.snackbar("Error", onError.message);
      });
    }).catchError((onError) {
      print(">> 2");
      Navigator.of(globalKey.currentContext, rootNavigator: true).pop();
      Get.snackbar("Error", onError.message);
    });
  }

  Future<void> mackFamilyRequest(int index, String name, String mobile,
      String person, String date, String time, String code) async {
    final userRequest = FirebaseFirestore.instance
        .collection('Users')
        .doc(list[index]["Key"])
        .collection("UserRequest");
    DocumentReference collectionReference = userRequest.doc();
    String key = collectionReference.id;

    FirebaseFirestore.instance
        .collection("Users")
        .doc(userModel.key1)
        .collection("Requests")
        .doc(key)
        .set({
      "Key": key,
      "KeyUser": userModel.key1,
      "KeyHotel": list[index]["Key"],
      "HotelName": list[index]["HotelName"],
      "HotelImage": list[index]["HotelImage"],
      "HotelTotalNumbersOfTables":
          list[index]["HotelTotalNumbersOfTables"].toString(),
      "UserName": name,
      "MobileNo": mobile,
      "TotalPerson": person,
      "TableNumber": "Wait...",
      "KeyTable": "",
      "Time": time,
      "Date": date,
      "Code": code,
      "RejectionMessage": "",
      "RequestStatus": "Pending",
      "DinnerStatus": "Pending",
      "FamilyRequest": "Yes",
      "Arrived": "",
      "KeyTableArray": []
    }).then((value) {
      FirebaseFirestore.instance
          .collection('Users')
          .doc(list[index]["Key"])
          .collection("UserRequest")
          .doc(key)
          .set({
        "Key": key,
        "KeyUser": userModel.key1,
        "KeyHotel": list[index]["Key"],
        "HotelName": list[index]["HotelName"],
        "HotelImage": list[index]["HotelImage"],
        "HotelTotalNumbersOfTables":
            list[index]["HotelTotalNumbersOfTables"].toString(),
        "UserName": name,
        "MobileNo": mobile,
        "TotalPerson": person,
        "TableNumber": "Wait...",
        "KeyTable": "",
        "Time": time,
        "Date": date,
        "Code": code,
        "RejectionMessage": "",
        "RequestStatus": "Pending",
        "DinnerStatus": "Pending",
        "FamilyRequest": "Yes",
        "Arrived": "",
        "KeyTableArray": []
      }).then((value) {
        Navigator.of(globalKey.currentContext, rootNavigator: true).pop();
        Get.offAll(() => UserHomePage());
      }).catchError((onError) {
        print(">> 1");
        Navigator.of(globalKey.currentContext, rootNavigator: true).pop();
        Get.snackbar("Error", onError.message);
      });
    }).catchError((onError) {
      print(">> 2");
      Navigator.of(globalKey.currentContext, rootNavigator: true).pop();
      Get.snackbar("Error", onError.message);
    });
  }

  Future<void> rejectUserRequest(int index, String key, String keyUser,
      String keyHotel, String rejectReason) async {
    QuerySnapshot qs = await userRequestToOwnerReference.get();
    qs.docs[index].reference.delete();

    final rejectedData = FirebaseFirestore.instance
        .collection('Users')
        .doc(keyHotel)
        .collection("Rejected");

    final userData = FirebaseFirestore.instance
        .collection('Users')
        .doc(keyUser)
        .collection("Requests");

    userData.doc(key).update({
      "RequestStatus": "Rejected",
      "RejectionMessage": rejectReason
    }).then((value) {
      userData.where("Key", isEqualTo: key).get().then((QuerySnapshot value2) {
        DocumentReference rejectedDataReference = rejectedData.doc(key);
        rejectedDataReference.set({
          "Key": key,
          "UserName": value2.docs.elementAt(0).data()["UserName"],
          "TotalPerson": value2.docs.elementAt(0).data()["TotalPerson"],
          "Date": value2.docs.elementAt(0).data()["Date"],
          "Time": value2.docs.elementAt(0).data()["Time"],
          "Code": value2.docs.elementAt(0).data()["Code"],
          "MobileNo": value2.docs.elementAt(0).data()["MobileNo"],
          "TableNumber": value2.docs.elementAt(0).data()["TableNumber"],
          "RequestStatus": value2.docs.elementAt(0).data()["RequestStatus"],
        }).then((value) {
          qs.docs[index].reference.delete().then((value) {
            Navigator.of(globalKey.currentContext, rootNavigator: true).pop();
            Get.back();
          }).catchError((onError) {
            print(">> 1");
            Navigator.of(globalKey.currentContext, rootNavigator: true).pop();
            Get.snackbar("Error", onError.message);
          });
        }).catchError((onError) {
          print(">> 2");
          Navigator.of(globalKey.currentContext, rootNavigator: true).pop();
          Get.snackbar("Error", onError.message);
        });
      }).catchError((onError) {
        print(">> 3");
        Navigator.of(globalKey.currentContext, rootNavigator: true).pop();
        Get.snackbar("Error", onError.message);
      });
    }).catchError((onError) {
      print(">> 4");
      Navigator.of(globalKey.currentContext, rootNavigator: true).pop();
      Get.snackbar("Error", onError.message);
    });
  }

  Future<void> acceptUserRequest(
      int index, String key, String keyUser, String keyHotel) async {
    QuerySnapshot qs = await userRequestToOwnerReference.get();

    final acceptedData = FirebaseFirestore.instance
        .collection('Users')
        .doc(keyHotel)
        .collection("Accepted");

    final userData = FirebaseFirestore.instance
        .collection('Users')
        .doc(keyUser)
        .collection("Requests");

    final tableData = FirebaseFirestore.instance
        .collection('Users')
        .doc(keyHotel)
        .collection("Tables");

    userData.doc(key).update({"RequestStatus": "Accepted","FlagForDinner": "0"}).then((value) {
      userData.where("Key", isEqualTo: key).get().then((QuerySnapshot value2) {
        DocumentReference acceptedDataReference = acceptedData.doc(key);
        acceptedDataReference.set({
          "Key": key,
          "KeyUser": value2.docs.elementAt(0).data()["KeyUser"],
          "KeyHotel": value2.docs.elementAt(0).data()["KeyHotel"],
          "KeyTableArray": [
            "KeyTableNumber" +
                "${value2.docs.elementAt(0).data()["TableNumber"]}"
          ],
          "Time": value2.docs.elementAt(0).data()["Time"],
          "Date": value2.docs.elementAt(0).data()["Date"],
          "Code": value2.docs.elementAt(0).data()["Code"],
          "UserName": value2.docs.elementAt(0).data()["UserName"],
          "MobileNo": value2.docs.elementAt(0).data()["MobileNo"],
          "TotalPerson": value2.docs.elementAt(0).data()["TotalPerson"],
          "TableNumber": value2.docs.elementAt(0).data()["TableNumber"],
          "DinnerStatus": "Pending",
          "StartTime": "",
          "EndTime": "",
          "FamilyRequest": "No",
          "Arrived": "",
          "FlagForDinner": "0",
        }).then((value) {
          tableData
              .doc(value2.docs.elementAt(0).data()["KeyTable"])
              .collection("Customer")
              .doc(key)
              .set({
            "Key": key,
            "KeyUser": value2.docs.elementAt(0).data()["KeyUser"],
            "KeyHotel": value2.docs.elementAt(0).data()["KeyHotel"],
            "KeyTableArray": [
              "KeyTableNumber" +
                  "${value2.docs.elementAt(0).data()["TableNumber"]}"
            ],
            "Time": value2.docs.elementAt(0).data()["Time"],
            "Date": value2.docs.elementAt(0).data()["Date"],
            "Code": value2.docs.elementAt(0).data()["Code"],
            "UserName": value2.docs.elementAt(0).data()["UserName"],
            "MobileNo": value2.docs.elementAt(0).data()["MobileNo"],
            "TotalPerson": value2.docs.elementAt(0).data()["TotalPerson"],
            "TableNumber": value2.docs.elementAt(0).data()["TableNumber"],
            "DinnerStatus": "Pending",
            "StartTime": "",
            "EndTime": "",
            "FamilyRequest": "No",
            "Arrived": "",
            "FlagForDinner": "0",
          }).then((value) {
            qs.docs[index].reference.delete().then((value) {
              acceptedData.get().then((QuerySnapshot dataLength) {

                userData.doc(key).update({"KeyTableArray": [
                  "KeyTableNumber" +
                      "${value2.docs.elementAt(0).data()["TableNumber"]}"
                ]}).then((value){
                  customerLength.value = dataLength.docs.length;
                  Navigator.of(globalKey.currentContext, rootNavigator: true)
                      .pop();
                }).catchError((onError){print(">> 0");
                Navigator.of(globalKey.currentContext, rootNavigator: true)
                    .pop();
                Get.snackbar("Error", onError.message);});






              }).catchError((onError) {
                print(">> 1");
                Navigator.of(globalKey.currentContext, rootNavigator: true)
                    .pop();
                Get.snackbar("Error", onError.message);
              });
            }).catchError((onError) {
              print(">> 2");
              Navigator.of(globalKey.currentContext, rootNavigator: true).pop();
              Get.snackbar("Error", onError.message);
            });
          }).catchError((onError) {
            print(">> 3");
            Navigator.of(globalKey.currentContext, rootNavigator: true).pop();
            Get.snackbar("Error", onError.message);
          });
        }).catchError((onError) {
          print(">> 4");
          Navigator.of(globalKey.currentContext, rootNavigator: true).pop();
          Get.snackbar("Error", onError.message);
        });
      }).catchError((onError) {
        print(">> 5");
        Navigator.of(globalKey.currentContext, rootNavigator: true).pop();
        Get.snackbar("Error", onError.message);
      });
    }).catchError((onError) {
      print(">> 5");
      Navigator.of(globalKey.currentContext, rootNavigator: true).pop();
      Get.snackbar("Error", onError.message);
    });
  }

  Future<void> acceptFamilyRequest(
      int index, String keyUser, String keyRequest, String allTables) async {
    QuerySnapshot qs = await userRequestToOwnerReference.get();
    var userRequestData = FirebaseFirestore.instance
        .collection("Users")
        .doc(keyUser)
        .collection("Requests");

    final acceptedData = FirebaseFirestore.instance
        .collection('Users')
        .doc(userModel.key1)
        .collection("Accepted");

    final userData = FirebaseFirestore.instance
        .collection('Users')
        .doc(keyUser)
        .collection("Requests");

    userData.doc(keyRequest).update({
      "RequestStatus": "Accepted",
      "TableNumber": allTables,
      "KeyTableArray": tableKeys,
      "FlagForDinner": "0",
    }).then((value) {
      userData
          .where("Key", isEqualTo: keyRequest)
          .get()
          .then((QuerySnapshot value3) {
        DocumentReference acceptedDataReference = acceptedData.doc(keyRequest);
        acceptedDataReference.set({
          "Key": keyRequest,
          "KeyUser": value3.docs.elementAt(0).data()["KeyUser"],
          "KeyHotel": value3.docs.elementAt(0).data()["KeyHotel"],
          "KeyTableArray": tableKeys,
          "Time": value3.docs.elementAt(0).data()["Time"],
          "Date": value3.docs.elementAt(0).data()["Date"],
          "Code": value3.docs.elementAt(0).data()["Code"],
          "UserName": value3.docs.elementAt(0).data()["UserName"],
          "MobileNo": value3.docs.elementAt(0).data()["MobileNo"],
          "TotalPerson": value3.docs.elementAt(0).data()["TotalPerson"],
          "TableNumber": allTables,
          "DinnerStatus": "Pending",
          "StartTime": "",
          "EndTime": "",
          "FamilyRequest": "Yes",
          "Arrived": "",
          "FlagForDinner": "0",
        }).then((value) {
          for (int i = 0; i < tableKeys.length; i++) {
            FirebaseFirestore.instance
                .collection("Users")
                .doc(userModel.key1)
                .collection("Tables")
                .where("Key", isEqualTo: tableKeys[i].toString())
                .get()
                .then((QuerySnapshot value) {
              userRequestData
                  .where("Key", isEqualTo: keyRequest)
                  .get()
                  .then((QuerySnapshot value2) {
                FirebaseFirestore.instance
                    .collection("Users")
                    .doc(userModel.key1)
                    .collection("Tables")
                    .doc(value.docs.elementAt(0).data()["Key"])
                    .collection("Customer")
                    .doc(value2.docs.elementAt(0).data()["Key"])
                    .set({
                  "Key": value2.docs.elementAt(0).data()["Key"],
                  "KeyUser": value2.docs.elementAt(0).data()["KeyUser"],
                  "KeyHotel": userModel.key1,
                  "KeyTableArray": tableKeys,
                  "Time": value2.docs.elementAt(0).data()["Time"],
                  "Date": value2.docs.elementAt(0).data()["Date"],
                  "Code": value2.docs.elementAt(0).data()["Code"],
                  "UserName": value2.docs.elementAt(0).data()["UserName"],
                  "MobileNo": value2.docs.elementAt(0).data()["MobileNo"],
                  "TotalPerson": value2.docs.elementAt(0).data()["TotalPerson"],
                  "TableNumber": allTables,
                  "DinnerStatus": "Pending",
                  "StartTime": "",
                  "EndTime": "",
                  "FamilyRequest": "Yes",
                  "Arrived": "",
                  "FlagForDinner": "0",
                }).then((value) {
                  if (i == (tableKeys.length - 1)) {
                    qs.docs[index].reference.delete().then((value) {
                      Navigator.of(globalKey.currentContext,
                              rootNavigator: true)
                          .pop();
                      Get.offAll(() => HotelHomePage());
                    }).catchError((onError) {
                      print("a1");
                      Navigator.of(globalKey.currentContext,
                              rootNavigator: true)
                          .pop();
                      Get.snackbar("Error", onError.message);
                    });
                  }
                }).catchError((onError) {
                  print("b");
                  Navigator.of(globalKey.currentContext, rootNavigator: true)
                      .pop();
                  Get.snackbar("Error", onError.message);
                });
              }).catchError((onError) {
                print("c");
                Navigator.of(globalKey.currentContext, rootNavigator: true)
                    .pop();
                Get.snackbar("Error", onError.message);
              });
            }).catchError((onError) {
              print("d");
              Navigator.of(globalKey.currentContext, rootNavigator: true).pop();
              Get.snackbar("Error", onError.message);
            });
          }
        }).catchError((onError) {
          print("e");
          Navigator.of(globalKey.currentContext, rootNavigator: true).pop();
          Get.snackbar("Error", onError.message);
        });
      }).catchError((onError) {
        print("f");
        Navigator.of(globalKey.currentContext, rootNavigator: true).pop();
        Get.snackbar("Error", onError.message);
      });
    }).catchError((onError) {
      print("g");
      Navigator.of(globalKey.currentContext, rootNavigator: true).pop();
      Get.snackbar("Error", onError.message);
    });
  }

  Future<void> hotelHoliday(String date, String reason) async {
    FirebaseFirestore.instance.collection('Users').doc(userModel.key1).update(
        {"HotelHolidayDate": date, "HotelHolidayReason": reason}).then((value) {
      FirebaseFirestore.instance
          .collection('Users')
          .where("Key", isEqualTo: userModel.key1)
          .get()
          .then((QuerySnapshot querySnapshot) {
        hotelModel =
            HotelModel.fromQuerySnapshot(querySnapshot.docs.elementAt(0));
        userModel =
            UserModel.fromQuerySnapshot(querySnapshot.docs.elementAt(0));
        Preferences.saveUser(userModel);
        Preferences.saveOwner(hotelModel);
        Navigator.of(globalKey.currentContext, rootNavigator: true).pop();
        Get.offAll(() => HotelHomePage());
      }).catchError((onError) {
        print(">> 1");
        Navigator.of(globalKey.currentContext, rootNavigator: true).pop();
        Get.snackbar("Error", onError.message);
      });
    }).catchError((onError) {
      print(">> 2");
      Navigator.of(globalKey.currentContext, rootNavigator: true).pop();
      Get.snackbar("Error", onError.message);
    });
  }

  Future<void> hotelHolidayCancel() async {
    FirebaseFirestore.instance.collection('Users').doc(userModel.key1).update(
        {"HotelHolidayDate": "", "HotelHolidayReason": ""}).then((value) {
      FirebaseFirestore.instance
          .collection('Users')
          .where("Key", isEqualTo: userModel.key1)
          .get()
          .then((QuerySnapshot querySnapshot) {
        hotelModel =
            HotelModel.fromQuerySnapshot(querySnapshot.docs.elementAt(0));
        userModel =
            UserModel.fromQuerySnapshot(querySnapshot.docs.elementAt(0));
        Preferences.saveUser(userModel);
        Preferences.saveOwner(hotelModel);
        Navigator.of(globalKey.currentContext, rootNavigator: true).pop();
        Get.offAll(() => HotelHomePage());
      }).catchError((onError) {
        print(">> 1");
        Navigator.of(globalKey.currentContext, rootNavigator: true).pop();
        Get.snackbar("Error", onError.message);
      });
    }).catchError((onError) {
      print(">> 2");
      Navigator.of(globalKey.currentContext, rootNavigator: true).pop();
      Get.snackbar("Error", onError.message);
    });
  }

  Future<void> scanData(
      int index,
      String key,
      String keyHotel,
      String keyCustomer,
      String keyTable,
      String startTime,
      String endTime,
      String family,
      List tableKeysFamily) async {

    CollectionReference removeAndAddToOwnerHistory = FirebaseFirestore.instance
        .collection("Users")
        .doc(keyHotel)
        .collection("Accepted");

    var removeAndAddToUserHistory = FirebaseFirestore.instance
        .collection("Users")
        .doc(userModel.key1)
        .collection("Requests");

    var historyUser = FirebaseFirestore.instance
        .collection("Users")
        .doc(userModel.key1)
        .collection("History")
        .doc(key);

    var historyOwner = FirebaseFirestore.instance
        .collection("Users")
        .doc(keyHotel)
        .collection("History")
        .doc(key);

    var tableUserRemove = FirebaseFirestore.instance
        .collection("Users")
        .doc(keyHotel)
        .collection("Tables")
        .doc(keyTable)
        .collection("Customer")
        .doc(key);

    QuerySnapshot ownerSide = await removeAndAddToOwnerHistory.get();

    removeAndAddToUserHistory.doc(key).update({
      "DinnerStatus": "Start",
      "Arrived": "Yes",
      "StartTime": startTime,
      "EndTime": endTime
    }).then((value) async {
      removeAndAddToUserHistory
          .where("Key", isEqualTo: key)
          .get()
          .then((QuerySnapshot value2) {
        historyOwner.set({
          "Key": key,
          "Arrived": "Yes",
          "KeyHotel": value2.docs.elementAt(0).data()["KeyHotel"],
          "KeyUser": value2.docs.elementAt(0).data()["KeyUser"],
          "KeyTableArray": value2.docs.elementAt(0).data()["KeyTableArray"],
          "TotalPerson": value2.docs.elementAt(0).data()["TotalPerson"],
          "TableNumber": value2.docs.elementAt(0).data()["TableNumber"],
          "UserName": value2.docs.elementAt(0).data()["UserName"],
          "Date": value2.docs.elementAt(0).data()["Date"],
          "Time": value2.docs.elementAt(0).data()["Time"],
          "HotelName": value2.docs.elementAt(0).data()["HotelName"],
          "HotelImage": value2.docs.elementAt(0).data()["HotelImage"],
          "DinnerStatus": value2.docs.elementAt(0).data()["DinnerStatus"],
          "StartTime": value2.docs.elementAt(0).data()["StartTime"],
          "EndTime": value2.docs.elementAt(0).data()["EndTime"],
        }).then((value) {
          ownerSide.docs[index].reference.delete().then((value) {
            historyUser.set({
              "Key": key,
              "Arrived": "Yes",
              "KeyHotel": value2.docs.elementAt(0).data()["KeyHotel"],
              "KeyUser": value2.docs.elementAt(0).data()["KeyUser"],
              "KeyTableArray": value2.docs.elementAt(0).data()["KeyTableArray"],
              "TotalPerson": value2.docs.elementAt(0).data()["TotalPerson"],
              "TableNumber": value2.docs.elementAt(0).data()["TableNumber"],
              "UserName": value2.docs.elementAt(0).data()["UserName"],
              "Date": value2.docs.elementAt(0).data()["Date"],
              "Time": value2.docs.elementAt(0).data()["Time"],
              "HotelName": value2.docs.elementAt(0).data()["HotelName"],
              "HotelImage": value2.docs.elementAt(0).data()["HotelImage"],
              "DinnerStatus": value2.docs.elementAt(0).data()["DinnerStatus"],
              "StartTime": value2.docs.elementAt(0).data()["StartTime"],
              "EndTime": value2.docs.elementAt(0).data()["EndTime"],
            }).then((value) {
              removeAndAddToUserHistory.doc(key).delete().then((value) {
                if (family == "Yes") {
                  for (int i = 0; i < tableKeysFamily.length; i++) {
                    FirebaseFirestore.instance
                        .collection("Users")
                        .doc(keyHotel)
                        .collection("Tables")
                        .where("Key", isEqualTo: tableKeysFamily[i])
                        .get()
                        .then((QuerySnapshot value4) {
                      FirebaseFirestore.instance
                          .collection("Users")
                          .doc(keyHotel)
                          .collection("Tables")
                          .doc(value4.docs.elementAt(0).data()["Key"])
                          .collection("Customer")
                          .where("Key", isEqualTo: keyCustomer)
                          .get()
                          .then((QuerySnapshot value3) {
                        FirebaseFirestore.instance
                            .collection("Users")
                            .doc(keyHotel)
                            .collection("Tables")
                            .doc(value4.docs.elementAt(0).data()["Key"])
                            .collection("Customer")
                            .doc(value3.docs.elementAt(0).data()["Key"])
                            .update({
                          "DinnerStatus": "Start",
                          "StartTime": value2.docs.elementAt(0).data()["StartTime"],
                          "EndTime": value2.docs.elementAt(0).data()["EndTime"],
                        })
                            .then((value) {
                          Navigator.of(globalKey.currentContext,
                                  rootNavigator: true)
                              .pop();
                          Get.offAll(() => UserHomePage());
                        }).catchError((onError) {
                          print("Error 0");
                          Navigator.of(globalKey.currentContext,
                                  rootNavigator: true)
                              .pop();
                          Get.snackbar("Error", onError.message);
                        });
                      }).catchError((onError) {
                        print("Error 1");
                        Navigator.of(globalKey.currentContext,
                                rootNavigator: true)
                            .pop();
                        Get.snackbar("Error", onError.message);
                      });
                    }).catchError((onError) {
                      print("Error 2");
                      Navigator.of(globalKey.currentContext,
                              rootNavigator: true)
                          .pop();
                      Get.snackbar("Error", onError.message);
                    });
                  }
                } else {
                  tableUserRemove.update({
                    "DinnerStatus": "Start",
                    "StartTime": value2.docs.elementAt(0).data()["StartTime"],
                    "EndTime": value2.docs.elementAt(0).data()["EndTime"],}).then((value) {
                    Navigator.of(globalKey.currentContext, rootNavigator: true)
                        .pop();
                    Get.offAll(() => UserHomePage());
                  }).catchError((onError) {
                    print("Error 0");
                    Navigator.of(globalKey.currentContext, rootNavigator: true)
                        .pop();
                    Get.snackbar("Error", onError.message);
                  });
                }



              }).catchError((onError) {
                print("Error 1");
                Navigator.of(globalKey.currentContext, rootNavigator: true)
                    .pop();
                Get.snackbar("Error", onError.message);
              });
            }).catchError((onError) {
              print("Error 2");
              Navigator.of(globalKey.currentContext, rootNavigator: true).pop();
              Get.snackbar("Error", onError.message);
            });
          }).catchError((onError) {
            print("Error 3");
            Navigator.of(globalKey.currentContext, rootNavigator: true).pop();
            Get.snackbar("Error", onError.message);
          });
        }).catchError((onError) {
          print("Error 4");
          Navigator.of(globalKey.currentContext, rootNavigator: true).pop();
          Get.snackbar("Error", onError.message);
        });
      }).catchError((onError) {
        print("Error 5");
        Navigator.of(globalKey.currentContext, rootNavigator: true).pop();
        Get.snackbar("Error", onError.message);
      });
    }).catchError((onError) {
      print("Error 6");
      Navigator.of(globalKey.currentContext, rootNavigator: true).pop();
      Get.snackbar("Error", onError.message);
    });
  }

  Future<void> updateTableNumberFromOwnerSide(String keyOrder, String keyUser,
      String newTableNumber, List keyTables) async {
    List tempOldKeyTables = [];
    List tempNewKeyTables = [];
    var acceptedCustomerData = FirebaseFirestore.instance
        .collection("Users")
        .doc(userModel.key1)
        .collection("Accepted");
    var tableCustomerData = FirebaseFirestore.instance
        .collection("Users")
        .doc(userModel.key1)
        .collection("Tables");

    FirebaseFirestore.instance
        .collection("Users")
        .doc(keyUser)
        .collection("Requests")
        .doc(keyOrder)
        .update({"TableNumber": newTableNumber}).then((value) {
      acceptedCustomerData
          .doc(keyOrder)
          .update({"TableNumber": newTableNumber}).then((value) {
        acceptedCustomerData
            .where("Key", isEqualTo: keyOrder)
            .get()
            .then((QuerySnapshot customerData) {
          tempOldKeyTables =
              customerData.docs.elementAt(0).data()["KeyTableArray"];
          for (int i = 0; i < tempOldKeyTables.length; i++) {
            tableCustomerData
                .where("Key", isEqualTo: tempOldKeyTables[i].toString())
                .get()
                .then((QuerySnapshot removeCustomerFromOldTable) {
              tableCustomerData
                  .doc(removeCustomerFromOldTable.docs
                      .elementAt(0)
                      .data()["Key"])
                  .collection("Customer")
                  .doc(keyOrder)
                  .delete()
                  .then((value) {
                print(">><<");
              }).catchError((onError) {
                print("Error 22");
                Navigator.of(globalKey.currentContext, rootNavigator: true)
                    .pop();
                Get.snackbar("Error", onError.message);
              });
            }).catchError((onError) {
              print("Error 11");
              Navigator.of(globalKey.currentContext, rootNavigator: true).pop();
              Get.snackbar("Error", onError.message);
            });
          }
          acceptedCustomerData
              .doc(keyOrder)
              .update({"KeyTableArray": keyTables}).then((value) {
            acceptedCustomerData
                .where("Key", isEqualTo: keyOrder)
                .get()
                .then((QuerySnapshot newData) {
              tempNewKeyTables =
                  newData.docs.elementAt(0).data()["KeyTableArray"];
              for (int i = 0; i < tempNewKeyTables.length; i++) {
                tableCustomerData
                    .where("Key", isEqualTo: tempNewKeyTables[i].toString())
                    .get()
                    .then((QuerySnapshot addCustomerInNewTable) {
                  FirebaseFirestore.instance
                      .collection("Users")
                      .doc(userModel.key1)
                      .collection("Tables")
                      .doc(
                          addCustomerInNewTable.docs.elementAt(0).data()["Key"])
                      .collection("Customer")
                      .doc(keyOrder)
                      .set(jsonDecode(
                          jsonEncode(newData.docs.elementAt(0).data())))
                      .then((value) {
                    if (i == tempNewKeyTables.length - 1) {
                      Navigator.of(globalKey.currentContext,
                              rootNavigator: true)
                          .pop();
                      Get.offAll(() => HotelHomePage());
                    } else {
                      print(">>><<<");
                    }
                  }).catchError((onError) {
                    print("Error 222");
                    Navigator.of(globalKey.currentContext, rootNavigator: true)
                        .pop();
                    Get.snackbar("Error", onError.message);
                  });
                }).catchError((onError) {
                  print("Error 111");
                  Navigator.of(globalKey.currentContext, rootNavigator: true)
                      .pop();
                  Get.snackbar("Error", onError.message);
                });
              }
            }).catchError((onError) {
              print("Error 5");
              Navigator.of(globalKey.currentContext, rootNavigator: true).pop();
              Get.snackbar("Error", onError.message);
            });
          }).catchError((onError) {
            print("Error 4");
            Navigator.of(globalKey.currentContext, rootNavigator: true).pop();
            Get.snackbar("Error", onError.message);
          });
        }).catchError((onError) {
          print("Error 3");
          Navigator.of(globalKey.currentContext, rootNavigator: true).pop();
          Get.snackbar("Error", onError.message);
        });
      }).catchError((onError) {
        print("Error 2");
        Navigator.of(globalKey.currentContext, rootNavigator: true).pop();
        Get.snackbar("Error", onError.message);
      });
    }).catchError((onError) {
      print("Error 1");
      Navigator.of(globalKey.currentContext, rootNavigator: true).pop();
      Get.snackbar("Error", onError.message);
    });
  }

  Future<void> notArrivedUser(String keyOrder) async {
    List keyTableTemp = [];
    var acceptedCustomer = FirebaseFirestore.instance
        .collection("Users")
        .doc(userModel.key1)
        .collection("Accepted");

    var notArrivedCustomer = FirebaseFirestore.instance
        .collection("Users")
        .doc(userModel.key1)
        .collection("NotArrive");

    var tableData = FirebaseFirestore.instance
        .collection("Users")
        .doc(userModel.key1)
        .collection("Tables");

    acceptedCustomer
        .where("Key", isEqualTo: keyOrder)
        .get()
        .then((QuerySnapshot customerData) {
      keyTableTemp = customerData.docs.elementAt(0).data()["KeyTableArray"];
      FirebaseFirestore.instance
          .collection("Users")
          .doc(customerData.docs.elementAt(0).data()["KeyUser"])
          .collection("Requests")
          .doc(customerData.docs.elementAt(0).data()["Key"])
          .update({"Arrived": "Not"}).then((value) {
        acceptedCustomer.doc(keyOrder).update({"Arrived": "Not"}).then((value) {
          for (int i = 0; i < keyTableTemp.length; i++) {
            tableData
                .where("Key", isEqualTo: keyTableTemp[i])
                .get()
                .then((QuerySnapshot tableKey) {
              tableData
                  .doc(tableKey.docs.elementAt(0).data()["Key"])
                  .collection("Customer")
                  .doc(keyOrder)
                  .delete()
                  .then((value) {
                if (i == keyTableTemp.length - 1) {
                  acceptedCustomer.doc(keyOrder).delete().then((value) {
                    notArrivedCustomer.doc(keyOrder).set(jsonDecode(
                        jsonEncode(customerData.docs.elementAt(0).data()))).then((value) {
                      notArrivedCustomer.doc(keyOrder).update({"Arrived" : "Not"}).then((value){
                        print("All Done");
                      }).catchError((onError) {
                        print("Error 333");
                        Navigator.of(globalKey.currentContext, rootNavigator: true)
                            .pop();
                        Get.snackbar("Error", onError.message);
                      });
                    }).catchError((onError) {
                      print("Error 222");
                      Navigator.of(globalKey.currentContext, rootNavigator: true)
                          .pop();
                      Get.snackbar("Error", onError.message);
                    });
                  }).catchError((onError) {
                    print("Error 111");
                    Navigator.of(globalKey.currentContext, rootNavigator: true)
                        .pop();
                    Get.snackbar("Error", onError.message);
                  });
                  Navigator.of(globalKey.currentContext, rootNavigator: true)
                      .pop();
                  Get.offAll(() => HotelHomePage());
                } else {
                  print(">><<");
                }
              }).catchError((onError) {
                print("Error 22");
                Navigator.of(globalKey.currentContext, rootNavigator: true)
                    .pop();
                Get.snackbar("Error", onError.message);
              });
            }).catchError((onError) {
              print("Error 11");
              Navigator.of(globalKey.currentContext, rootNavigator: true).pop();
              Get.snackbar("Error", onError.message);
            });
          }
        }).catchError((onError) {
          print("Error 3");
          Navigator.of(globalKey.currentContext, rootNavigator: true).pop();
          Get.snackbar("Error", onError.message);
        });
      }).catchError((onError) {
        print("Error 2");
        Navigator.of(globalKey.currentContext, rootNavigator: true).pop();
        Get.snackbar("Error", onError.message);
      });
    }).catchError((onError) {
      print("Error 1");
      Navigator.of(globalKey.currentContext, rootNavigator: true).pop();
      Get.snackbar("Error", onError.message);
    });
  }

  Future<void> cancelReservationIfPending(String keyOrder, String keyHotel) async {
    FirebaseFirestore.instance
        .collection("Users")
        .doc(keyHotel)
        .collection("UserRequest")
        .doc(keyOrder)
        .delete()
        .then((value) {
      FirebaseFirestore.instance
          .collection("Users")
          .doc(userModel.key1)
          .collection("Requests")
          .doc(keyOrder)
          .delete()
          .then((value) {
        Navigator.of(globalKey.currentContext, rootNavigator: true).pop();
      }).catchError((onError) {
        print("Error 2");
        Navigator.of(globalKey.currentContext, rootNavigator: true).pop();
        Get.snackbar("Error", onError.message);
      });
    }).catchError((onError) {
      print("Error 1");
      Navigator.of(globalKey.currentContext, rootNavigator: true).pop();
      Get.snackbar("Error", onError.message);
    });
  }

  Future<void> cancelReservationIfAccepted(
      String keyOrder, String keyHotel, List keyTableList) async{
    for (int i = 0; i < keyTableList.length; i++) {
      FirebaseFirestore.instance
          .collection("Users")
          .doc(keyHotel)
          .collection("Tables")
          .doc(keyTableList[i])
          .collection("Customer")
          .doc(keyOrder)
          .delete()
          .then((value) {

        if(i == keyTableList.length-1 )
        {
          FirebaseFirestore.instance
              .collection("Users")
              .doc(keyHotel)
              .collection("Accepted")
              .doc(keyOrder)
              .delete()
              .then((value) {
            FirebaseFirestore.instance
                .collection("Users")
                .doc(userModel.key1)
                .collection("Requests")
                .doc(keyOrder)
                .delete()
                .then((value) {
              Navigator.of(globalKey.currentContext, rootNavigator: true).pop();
              Get.snackbar("Done", "Your reservation cancel successfully.");});
          })
              .catchError((onError) {print("Error 22");
          Navigator.of(globalKey.currentContext, rootNavigator: true).pop();
          Get.snackbar("Error", onError.message);
          }).catchError((onError) {print("Error 11");
          Navigator.of(globalKey.currentContext, rootNavigator: true).pop();
          Get.snackbar("Error", onError.message);});
        }
      }).catchError((onError) {print("Error 1");
      Navigator.of(globalKey.currentContext, rootNavigator: true).pop();
      Get.snackbar("Error", onError.message);});
    }
  }


}
