import 'package:shared_preferences/shared_preferences.dart';

class Model {
  final String? email;
  final String? pass;
  Model(this.email,this.pass);
  getUser()async{
    final prefs =  await SharedPreferences.getInstance();
    final email = await prefs.getString('email');
    final pass = await prefs.getString('pass');
    var user = [email,pass];
    return (user);
  }
}