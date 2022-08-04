import 'package:shared_preferences/shared_preferences.dart';

class AuthUtils {
  static const String endPoint = 'auths/login';

  // Keys to store and fetch data from SharedPreferences
  static const String authTokenKey = 'auth_key';
  static const String userIdKey = 'userId';
  // static const String sosRegisterKey = 'sosRegister';
  // static const String sosPremiumKey = 'sosPremium';
  static const String userName = 'username';
  static const String userEmail = 'email';
  static const String userContact = 'contact';
  static const String userProfilePic = 'profilePic';

  static String getToken(SharedPreferences prefs) {
    return prefs.getString(authTokenKey) ?? '';
  }

  static int getUserId(SharedPreferences prefs) {
    return prefs.getInt(userIdKey) ?? 0;
  }

  // static String getSosRegister(SharedPreferences prefs) {
  //   return prefs.getString(sosRegisterKey);
  // }

  // static String getSosPremium(SharedPreferences prefs) {
  //   return prefs.getString(sosPremiumKey);
  // }

  static String getUsername(SharedPreferences prefs) {
    return prefs.getString(userName) ?? '';
  }

  static String getUserEmail(SharedPreferences prefs) {
    return prefs.getString(userEmail) ?? '';
  }

  static String getUserContact(SharedPreferences prefs) {
    return prefs.getString(userContact) ?? '';
  }

  static String getUserProfilePic(SharedPreferences prefs) {
    return prefs.getString(userProfilePic) ?? '';
  }

  static insertDetails(SharedPreferences prefs, var response) {
    prefs.setString(authTokenKey, response['auth_key']);
    prefs.setInt(userIdKey, response['userId']);
    // prefs.setString(sosRegisterKey, response['sosRegister']);
    // prefs.setString(sosPremiumKey, response['sosPremium']);
    prefs.setString(userContact, response['contact']);
    prefs.setString(userEmail, response['email']);
    prefs.setString(userName, response['username']);
    prefs.setString(userProfilePic, response['profilePic']);
  }
}
