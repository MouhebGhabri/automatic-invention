import 'dart:developer';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:healthy/components/crud.dart';
import 'package:healthy/components/customtextform.dart';
import 'package:healthy/components/valid.dart';
import 'package:healthy/constant/linkapi.dart';
import 'package:healthy/main.dart';
import 'package:flutter/material.dart';
import 'package:healthy/app/home.dart';

class Login extends StatefulWidget {
  Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  GlobalKey<FormState> formstate = GlobalKey();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  Crud crud = Crud();

  bool isLoading = false;

  login() async {
    if (formstate.currentState!.validate()) {
      isLoading = true;
      setState(() {});
      var response = await crud.postRequest(
          linkLogin, {"email": email.text, "password": password.text});
      isLoading = false;
      setState(() {});
      if (response['status'] == "success") {
        log('id is : ' + response['data']['id'].toString());
        sharedPref.setString("id", response['data']['id'].toString());
        sharedPref.setString("username", response['data']['username']);
        sharedPref.setString("email", response['data']['email']);
        Navigator.of(context).pushNamedAndRemoveUntil("home", (route) => false);
      } else {
        AwesomeDialog(
            context: context,
            title: "Alert",
            body: Text("Email or Password doesn't exist please try again"))
          ..show();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          padding: EdgeInsets.all(10),
          child: isLoading == true
              ? Center(child: CircularProgressIndicator())
              : ListView(
                  children: [
                    Form(
                      key: formstate,
                      child: Column(
                        children: [
                          Image.asset(
                            'images/heart.png',
                            width: 200,
                            height: 200,
                          ),
                          CustTextForm(
                            valid: (val) {
                              return validInput(val!, 3, 60);
                            },
                            mycontroller: email,
                            hint: "email",
                          ),
                          CustTextForm(
                            valid: (val) {
                              return validInput(val!, 3, 20);
                            },
                            mycontroller: password,
                            hint: "password",
                          ),
                          MaterialButton(
                            color: Colors.redAccent,
                            textColor: Colors.white,
                            padding: EdgeInsets.symmetric(
                                horizontal: 70, vertical: 10),
                            onPressed: () async {
                              await login();
                              //  Navigator.push(context,MaterialPageRoute(builder: (context) => Home()));
                            },
                            child: Text("Login"),
                          ),
                          Container(height: 10),
                          InkWell(
                            child: Text("Sign Up"),
                            onTap: () {
                              Navigator.of(context).pushNamed("signup");
                            },
                          )
                        ],
                      ),
                    ),
                  ],
                ),
        ));
  }
}
