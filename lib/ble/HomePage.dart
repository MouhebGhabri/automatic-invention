import 'dart:async';
import 'dart:convert' show utf8 ;
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';


 class HomePage extends  StatefulWidget{
  const HomePage({Key ?key, required this.device}) : super (key: key);
  final BluetoothDevice device ;
  @override
  _HomePageState create() => _HomePageState();

  @override
  _HomePageState createState() => _HomePageState();

}
class _HomePageState extends State<HomePage>{
  final String SERVICE_UUID ="001800-0000-1000-8000-00805f9b34fb";
  final String CHARACTERISTIC_UUID="00002a00-0000-1000-8000-00805F9B34FB";
  bool isReady=false;
  late Stream<List<int>> stream;
  String temperature ="?";
  String hear_rate ="?";
  String _glucose ="?";

  @override
  void initState(){
    super.initState();
  }
  connectToDevice() async {
    if (widget.device == null) {
      _pop();
      return;
    }
    new Timer(const Duration(seconds: 15),(){
      if(!isReady){
        disconnectFromDevice();
        _pop();
      }
    });
    await widget.device.connect();
    discoverServices();
  }

  disconnectFromDevice(){
    if(widget.device == null){
      _pop();
      return;
    }
    widget.device.disconnect();
  }
  discoverServices()async{
    if(widget.device == null){
      _pop();
      return;
    }
    List<BluetoothService> services = await widget.device.discoverServices();
    services.forEach((service) {
      if(service.uuid.toString()==SERVICE_UUID){
        service.characteristics.forEach((characteristic) {

          if(characteristic.uuid.toString() == CHARACTERISTIC_UUID){
            characteristic.setNotifyValue(!characteristic.isNotifying);
            stream = characteristic.value;

            setState(() {
              isReady=true;
            });
          }
        });
      }
    });
    if(!isReady){
      _pop();
    }
  }
  Future<bool> _onWillPop() async{
    return (await showDialog(
        context: context,
        builder: (context) => new AlertDialog(
          title: Text("are you sure "),
          content: Text("do you want to disconenect and go back ?"),
          actions: <Widget>[
            new TextButton(
                onPressed :() =>Navigator.of(context).pop(false) ,
            child: Text("no"),),
            new TextButton(onPressed: (){
              disconnectFromDevice();
              Navigator.of(context).pop(true);
            },
            child: Text(('yes')),)
          ],),
      //??
          //false
    ));
  }
  _pop(){
    Navigator.of(context).pop(true);
  }

  String _dataParser(List<int> dataFromDevice){
    return utf8.decode(dataFromDevice);
  }

// _DataParser(String data ){
//   if(data.isNotEmpty){
//     var tempValue =data.split(",")[0];
//     var heartrateValue = data.split(",")[1];
//     var glucoseValue =data.split(",")[2];
//     print("Tempurature:${tempValue} ");
//     print("heartrate : ${heartrateValue}");
//     print("glucose: ${glucoseValue}");
//     setState(() {
//       _tempurature = tempValue +"'c";
//       _heartrate = heartrateValue+"BPM";
//       _glucose =glucoseValue +"mg";

//     });
//   }
// }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _onWillPop(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.redAccent,
          title: Text('VITAL SIGNS',),),
        body:

      Container(
        child: !isReady ? Center(
        child: Text(
          "please wait ...",
          style:TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold, letterSpacing: 0.15,color: Colors.blueGrey),textAlign: TextAlign.center,),
      )
          : Container(
        child: StreamBuilder<List<int>>(
          stream: stream,
          builder: (BuildContext context , AsyncSnapshot<dynamic> snapshot) {
            if(snapshot.hasError){ return Text("Error: ${snapshot.error}");}
            if(snapshot.connectionState == ConnectionState.active){
              var _tempurature = _dataParser(snapshot.data);
              var _heartrate = _dataParser(snapshot.data);
              var  _glucose =_dataParser(snapshot.data);
             return Container( alignment: Alignment.center,
               child: Column(

               mainAxisAlignment: MainAxisAlignment.center,
               children: <Widget>[
                 Text('tempurature value',),Text('${_tempurature}'),
                 Text('heartrate value',),Text('${_heartrate}'),
                 Text('glucose value',),Text('${_glucose}')
               ],
             ),);
            }
          return Container(
            alignment: Alignment.center,
            child:Text("Here you go hero "),
          );
         },
        ),
      ),
      ),
      ),

    );
  }
}