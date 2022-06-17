import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:healthy/components/crud.dart';
import 'package:healthy/components/customtextform.dart';
import 'package:healthy/components/valid.dart';
import 'package:healthy/constant/linkapi.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  GlobalKey<FormState> formstate = GlobalKey();
  Crud _crud = Crud();

  bool isLoading = false;

  TextEditingController email = TextEditingController();
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();

  signUp() async {
    if (formstate.currentState!.validate()) {
      isLoading = true;
      setState(() {});
      var response = await _crud.postRequest(linkSignUp, {
        "email": email.text,
        "username": username.text,
        "password": password.text
      });
      isLoading = false;
      setState(() {});
     if (response['status'] == "success") {
       Navigator.of(context)
           .pushNamedAndRemoveUntil("success", (route) => false);
     } else {
       AwesomeDialog(
           context: context,
           title: "Alert",
           body: Text("sign up failed try again  "))
         ..show();      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: isLoading == true
            ? Center(child: CircularProgressIndicator())
            : Container(
                padding: EdgeInsets.all(10),
                child: ListView(
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
                              return validInput(val!, 7, 100);
                            },
                            mycontroller: email,
                            hint: "email",
                          ),
                          CustTextForm(
                            valid: (val) {
                              return validInput(val!, 7, 40);
                            },
                            mycontroller: username,
                            hint: "username",
                          ),
                          CustTextForm(
                            valid: (val) {
                              return validInput(val!, 7, 50);
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
                              await signUp();
                            },
                            child: Text("SignUp"),
                          ),
                          Container(height: 10),
                          InkWell(
                            child: Text("Login"),
                            onTap: () {
                              Navigator.of(context).pushReplacementNamed("login");
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
