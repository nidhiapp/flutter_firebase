import 'package:shared_preferences/shared_preferences.dart';

class HelperFunction {
  //keys inside the device(shared preferences)
  static String userLoggedInKey = "LOGGEDIN KEY";
  static String userNameKey = "USERNAMEKEY";
  static String userEmailKey = "USEREMAILKEY";

  //saving the data to sharedprefences

  //getting the data from sharedpreferences
  static Future<bool?> getUserLoggedInStatus() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getBool(userLoggedInKey); 
  }
}
