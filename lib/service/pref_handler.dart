import 'package:shared_preferences/shared_preferences.dart';

class PreferenceHandler {
  static const String idUser = "";

  static void saveId(String userId) {
    SharedPreferences.getInstance().then((prefs) {
      prefs.setString(idUser, userId);
    });
  }

  //For getting user id
  static Future getId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String id = prefs.getString(idUser) ?? '';
    return id;
  }

  // For removing user id
  static void removeId() {
    SharedPreferences.getInstance().then((prefs) {
      prefs.clear();
    });
  }
}
