import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Session {
  void saveData(var username, email, employee_id, islogin,name) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setInt('employee_id', employee_id);
    sharedPreferences.setString('username', username);
    sharedPreferences.setString("email", email);
    sharedPreferences.setString("name", name);
    sharedPreferences.setBool("isLogin", islogin);
  }

  void logout() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.clear();
    final service = FlutterBackgroundService();
    service.sendData(
        {"action": "stopService"});
  }
}
