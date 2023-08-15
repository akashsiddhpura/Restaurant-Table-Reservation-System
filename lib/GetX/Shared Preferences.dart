import 'dart:convert';
import 'package:reserved_table/Model/HotelModel.dart';
import 'package:reserved_table/Model/UserModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  static SharedPreferences preferences;

  init() async {
    preferences = await SharedPreferences.getInstance();
  }

  static saveUser(UserModel user) async {
    preferences = await SharedPreferences.getInstance();
    String data = json.encode(user);
    preferences.setString('UserData', data);
  }

  static Future<UserModel> getUser() async {
    preferences = await SharedPreferences.getInstance();
    String gets = preferences.getString('UserData');
    if (gets!=null) {
      Map userMap = jsonDecode(gets);
      UserModel data = UserModel.fromJson(userMap);
      return data;
    } else {
      return null;
    }
  }

  static saveOwner(HotelModel user) async {
    preferences = await SharedPreferences.getInstance();
    String data = json.encode(user);
    preferences.setString('OwnerData', data);
  }

  static Future<HotelModel> getOwner() async {
    preferences = await SharedPreferences.getInstance();
    Map userMap = jsonDecode(preferences.getString('OwnerData'));
    HotelModel data = HotelModel.fromJson(userMap);
    return data;
  }

  static Future<void> clear() async {
    preferences = await SharedPreferences.getInstance();
    preferences.setString("UserData", null);
  }
}
