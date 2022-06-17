import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:healthy/components/crud.dart';
import 'package:healthy/components/valid.dart';
import 'package:healthy/main.dart';
import 'package:http/http.dart' as http;
import '../../components/customtextform.dart';
import '../../constant/linkapi.dart';


class EditVs extends StatefulWidget with Crud {
  final vsdata;
  EditVs({Key? key,this.vsdata}): super(key: key);
  @override
  State<EditVs> createState() => _EditVsState();
}
class _EditVsState extends State<EditVs>{

  GlobalKey<FormState> formstate =GlobalKey<FormState>();
  TextEditingController Tempurature =TextEditingController();
  TextEditingController Glucose =TextEditingController();
  TextEditingController Heartrate =TextEditingController();

  bool isLoading =false;

  editVs()async{
    if(formstate.currentState!.validate()){
      isLoading =true;
      setState((){});
      var response = await editRequest(linkEditData, {
        "temp":  Tempurature.text,
        "gluc":  Glucose.text,
        "bmp":   Heartrate.text,
        "id" : widget.vsdata['vs_id'].toString()
      });
      isLoading =false ;
      setState((){});
      if (response['status']=="success"){
        Navigator.of(context).pushReplacementNamed("home") ;
      }else {

      }
    }
  }

  @override
  void intState(){
    Tempurature.text = widget.vsdata['temp'];
    Glucose.text = widget.vsdata['gluc'];
    Heartrate.text = widget.vsdata['bmp'];
    super.initState();
  }
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text("Please edit you vital Signs"),
        backgroundColor: Colors.redAccent,

      ),
      body:isLoading ==true?
      Center(child: CircularProgressIndicator()):

      Container(
        padding: EdgeInsets.all(10),
        child: Form(
          key: formstate,
          child: ListView(
            children: [
              CustTextForm(hint: "Tempurature" ,mycontroller: Tempurature,valid:(val){
                return validInput(val!, 1, 5);
              } ,),
              CustTextForm(hint: "Glucose" ,mycontroller:Glucose ,valid:(val){
                return validInput(val!, 1, 5);

              } ,),
              CustTextForm(hint: "Heartrate" ,mycontroller:Heartrate ,valid:(val){
                return validInput(val!, 1, 5);

              } ,),
              Container(height: 20,),
              MaterialButton(onPressed: ()async{
                await editVs();
              },
                child:Text("Save"),
                textColor: Colors.white,
                color: Colors.redAccent,
              ),

            ],
          ),
        ),
      ),
    );
  }

  editRequest(String url, Map data) async {
    try {
      var response = await http.post(
        Uri.parse(url),
        body: data,
      );
      print(data);
      if (response.statusCode == 200) {
        var responsebody = jsonDecode(response.body);
        return responsebody;
      } else {
        print("Error ${response.statusCode}");
      }
    } catch (e) {
      print("Error Catch $e");
    }
  }
}

