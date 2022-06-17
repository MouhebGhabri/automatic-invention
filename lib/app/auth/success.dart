import 'package:flutter/material.dart';

class Success extends StatefulWidget {
  Success({Key? key}) : super(key: key);

  @override
  State<Success> createState() => _SuccessState();
}

class _SuccessState extends State<Success> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Text("Account created successfully" , style: TextStyle(fontSize: 20),),
          ),
          MaterialButton(
              textColor: Colors.white,
              color: Colors.blue,
              onPressed: () {
                Navigator.of(context)
                    .pushNamedAndRemoveUntil("login", (route) => false);
              },
              child: Text("Login"))
        ],
      ),
    );
  }
}
