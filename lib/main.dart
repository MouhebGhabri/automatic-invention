import 'package:healthy/app/auth/login.dart';
import 'package:healthy/app/auth/signup.dart';
import 'package:healthy/app/auth/success.dart';
import 'package:healthy/app/home.dart';
import 'package:flutter/material.dart';
import 'package:healthy/components/crud.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/vitsalsigns/add.dart';
import 'app/vitsalsigns/edit.dart';
import 'components/cardvs.dart';

late SharedPreferences sharedPref;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  sharedPref = await SharedPreferences.getInstance();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'IOT MEDICAL APPLICATION',
      initialRoute: sharedPref.getString("id") == null ? "login" : "signup",
      routes: {
        "login": (context) => Login(),
        "signup": (context) => SignUp(),
        "home": (context) => Home(),
        "success": (context) => Success(),
        "addvs": (context) => AddVs(),
        "edit": (context) => EditVs(),
      },
    );
  }
}
