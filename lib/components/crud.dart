import 'dart:developer';
import 'dart:io';
import 'package:healthy/model/vsmodel.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';

String _basicAuth = 'Basic ' + base64Encode(utf8.encode('mouheb:mouheb123'));

Map<String, String> myheaders = {'authorization': _basicAuth};

class Crud {
  String? id = "";
  Future<String?> getID() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? myID = sharedPreferences.getString('id');
    return myID;
  }

  void setID(String? newID) {
    id = newID;
  }

  getRequest(String url) async {
    try {
      var response = await http.get(Uri.parse(url));
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

  postRequest(String url, Map data) async {
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

  Future<VsModel?> getView(String url, String? id) async {
    try {
      var response = await http.get(
        Uri.parse(url + "?id=$id"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      print(response.body.toString());

      if (response.statusCode == 200) {
        var responsebody = json.decode(response.body);
        return VsModel.fromJson(responsebody);
      } else {
        print("Error ${response.statusCode}");
      }
    } catch (e) {
      print("Error Catch error $e");
    }
  }

  // getVs(String url, String id) async {
  // var  url1 = url+"?id="+id;
  // print(url1);
  //    try {
  //     var response = await http.get(Uri.parse(url)  ,headers:myheaders );
  //  //  if (response.statusCode == 200) {
  //  //    var responsebody = jsonDecode(response.body);
  //  //    return responsebody;
  //  //  } else {
  //  //    print("Error ${response.statusCode}");
  //  //  }
  //     print('mouheb');
  //      print(response.body);
  //   } catch (e) {
  //     print("Error Catch $e");
  //     print("ccc");
  //   }
  // }

  postRequestV(String url, Map data) async {
    print(data);

    try {
      var response =
          await http.post(Uri.parse(url), body: data, headers: myheaders);
      if (response.statusCode == 200) {
        var responsebody = jsonEncode(response.body);
        print(response.body);
        print("xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx");

        return responsebody;
      } else {
        print("Error ${response.statusCode}");
      }
    } catch (e) {
      print("Error Catch $e");
    }
  }
}


 //postRequestWithFile(String url, Map data, File file) async {
 //  var request = http.MultipartRequest("POST", Uri.parse(url));
 //  var length = await file.length();
 //  var stream = http.ByteStream(file.openRead());
 //  var multipartFile = http.MultipartFile("file", stream, length,
 //      filename: basename(file.path));
 //  request.headers.addAll(myheaders) ;
 //  request.files.add(multipartFile);
 //  data.forEach((key, value) {
 //      request.fields[key] = value ;
 //  });
 //  var myrequest = await request.send();

 //  var response = await http.Response.fromStream(myrequest) ;
 //  if (myrequest.statusCode == 200){
 //      return jsonDecode(response.body) ;
 //  }else {
 //    print("Error ${myrequest.statusCode}") ;
 //  }
 //}
  
//}






















// Future addRequestWithImageOne(url, data, [File? image]) async {
//   var uri = Uri.parse(url);
//   var request = new http.MultipartRequest("POST", uri);
//   request.headers.addAll(myheaders);

//   if (image != null) {
//     var length = await image.length();
//     var stream = new http.ByteStream(image.openRead());
//     stream.cast();
//     var multipartFile = new http.MultipartFile("file", stream, length,
//         filename: basename(image.path));
//     request.files.add(multipartFile);
//   }

//   // add Data to request
//   data.forEach((key, value) {
//     request.fields[key] = value;
//   });
//   // add Data to request
//   // Send Request
//   var myrequest = await request.send();
//   // For get Response Body
//   var response = await http.Response.fromStream(myrequest);
//   if (myrequest.statusCode == 200) {
//     print(response.body);
//     return jsonDecode(response.body);
//   } else {
//     print(response.body);
//     return jsonDecode(response.body);
//   }
// }
