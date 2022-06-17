import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:healthy/app/vitsalsigns/edit.dart';
import 'package:healthy/model/vsmodel.dart';
import 'package:http/http.dart' as http;
import 'package:healthy/ble/bluetooth.dart';
import 'package:healthy/components/cardvs.dart';
import 'package:healthy/components/crud.dart';
import '../constant/linkapi.dart';
import '../main.dart';

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(crudInstance.id);
  }

  Crud crudInstance = Crud();
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          title: FutureBuilder<String?>(
              future: crudInstance.getID(),
              builder: (context, snap) {
                if (snap.hasData) {
                  crudInstance.setID(snap.data);
                }

                return Text(
                  "id is ${snap.data}",
                  style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                );
              }),
          backgroundColor: Colors.redAccent,
          leading: IconButton(
              icon: Icon(Icons.bluetooth),
              hoverColor: Colors.blue,
              color: Colors.white,
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => FlutterBlueApp()));
              }),
          actions: [
            IconButton(
                onPressed: () {
                  sharedPref.clear();
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil("login", (route) => false);
                },
                icon: Icon(Icons.exit_to_app))
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).pushNamed("addvs");
          },
          child: Icon(
            Icons.add,
          ),
          splashColor: Colors.redAccent,
        ),
        body: FutureBuilder<String?>(
            future: crudInstance.getID(),
            builder: (context, snp) {
              log(snp.data ?? "TEXT");
              return snp.connectionState == ConnectionState.waiting
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : Container(
                      padding: EdgeInsets.all(10),
                      child: ListView(
                        children: [
                          FutureBuilder<VsModel?>(
                              future:
                                  crudInstance.getView(linkViewData, snp.data),
                              builder: (BuildContext context,
                                  AsyncSnapshot snapshot) {
                                return snapshot.connectionState ==
                                        ConnectionState.waiting
                                    ? Center(child: Text("LOADING.."))
                                    : snapshot.data?.status == 'fail'
                                        ? Center(
                                            child: Text(
                                              "No Vital Signs",
                                            ), //dont forget the design !!!
                                          )
                                        : LimitedBox(
                                            maxHeight: MediaQuery.of(context)
                                                .size
                                                .height,
                                            maxWidth: 300,
                                            child: ListView.builder(
                                              itemCount:
                                                  snapshot.data.data.length,
                                              itemBuilder: (context, index) {
                                                return CardVs(
                                                  onDelet: ()async{
                                                   var response = await deletRequest(linkDeleteData,{
                                                     "id" : snapshot.data['vs_id']
                                                   });
                                                   if(response['status'] == "success"){Navigator.of(context).pushReplacementNamed("home");}
                                                  },
                                                  ontap: () {
                                                    Navigator.of(context).push(MaterialPageRoute(
                                                        builder: (context)=>EditVs(vsdata: snapshot.data,)));
                                                  },
                                                  vsmodel: snapshot.data,
                                                  index: index,
                                                );
                                              },
                                            ),
                                          );
                              })
                        ],
                      ),
                    );
            }));
  }
  deletRequest(String url, Map data) async {
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
































//import 'package:healthy/ble/bluetooth.dart';
//import 'package:healthy/components/cardnote.dart';
//import 'package:healthy/components/crud.dart';
//import 'package:healthy/constant/linkapi.dart';
//import 'package:healthy/main.dart';
//import 'package:healthy/model/notemodel.dart';
//import 'package:flutter/material.dart';
//
//class Home extends StatefulWidget {
//  Home({Key? key}) : super(key: key);
//
//  @override
//  State<Home> createState() => _HomeState();
//}
//
//class _HomeState extends State<Home> with Crud {
//  bool isLoading = false;
//
//  getNotes() async {
//    var response =
//        await postRequest(linkViewData, {"id": sharedPref.getString("id")});
//    return response;
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      appBar: AppBar(
//        title: Text("Home"),
//        actions: [
//          IconButton(
//              onPressed: () {
//                sharedPref.clear();
//                Navigator.of(context)
//                    .pushNamedAndRemoveUntil("login", (route) => false);
//              },
//              icon: Icon(Icons.exit_to_app))
//        ],
//        leading: IconButton(
//            icon: Icon(Icons.bluetooth),
//            hoverColor: Colors.blue,
//            color: Colors.white,
//            onPressed: () {
//              Navigator.push(context,MaterialPageRoute(builder: (context) => FlutterBlueApp()));
//            }),
//      ),
//      floatingActionButton: FloatingActionButton(
//        onPressed: () {
//          Navigator.of(context).pushNamed("addnotes");
//        },
//        child: Icon(Icons.add),
//      ),
//      body: isLoading == true
//          ? Center(child: CircularProgressIndicator())
//          : Container(
//              padding: EdgeInsets.all(10),
//              child: ListView(
//                children: [
//                  FutureBuilder(
//                      future: getNotes(),
//                      builder: (BuildContext context, AsyncSnapshot snapshot) {
//                        if (snapshot.hasData) {
//                          if (snapshot.data['status'] == 'fail')
//                            return Center(
//                                child: Text(
//                              "there's no Data",
//                              style: TextStyle(
//                                  fontSize: 20, fontWeight: FontWeight.bold),
//                            ));
//                          return ListView.builder(
//                              itemCount: snapshot.data['data'].length,
//                              shrinkWrap: true,
//                              physics: NeverScrollableScrollPhysics(),
//                              itemBuilder: (context, i) {
//                                return CardNotes(
//                                  onDelete: () async {
//                                    var response = await postRequest(
//                                        linkDeleteData, {
//                                      "id": snapshot.data['data'][i]['notes_id'].toString() ,
//                                      "imagename" : snapshot.data['data'][i]['notes_image'].toString()
//                                    });
//                                    if (response['status'] == "success") {
//                                      Navigator.of(context)
//                                          .pushReplacementNamed("home");
//                                    }
//                                  },
//                                  ontap: () {
//                                    Navigator.of(context).push(
//                                        MaterialPageRoute(
//                                            builder: (context) => EditData(
//                                                notes: snapshot.data['data']
//                                                    [i])));
//                                  },
//                                  notemodel: NoteModel.fromJson(snapshot.data['data'][i])
//                                );
//                              });
//                        }
//                        if (snapshot.connectionState ==
//                            ConnectionState.waiting) {
//                          return Center(child: Text("Loading ..."));
//                        }
//                        return Center(child: Text("Loading ..."));
//                      })
//                ],
//              ),
//            ),
//    );
//  }
//}
//