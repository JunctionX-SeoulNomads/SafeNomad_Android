import 'dart:async';
import 'dart:convert';
import 'package:safe_nomad/pages/CustomTimer.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'package:safe_nomad/pages/utils.dart';
double longitude;
double latitude;
String userID;
int idx = 1;
ValueNotifier<int> status = ValueNotifier<int>(1);
BuildContext g_context;
String user=null;
List colors = [ Colors.green, Colors.yellow,Colors.orange, Colors.red, Colors.red[900],Colors.green, Colors.yellow,Colors.red];
List messages = ['Good', 'Normal', 'Medium', 'Critical', 'Super Critical','occasionally visited area','often visited area','commonly visited area'];

bool parking = false;
_getLocation() async {
  Location location = new Location();

  bool _serviceEnabled;
  PermissionStatus _permissionGranted;
  LocationData _locationData;

  _serviceEnabled = await location.serviceEnabled();
  if (!_serviceEnabled) {
    _serviceEnabled = await location.requestService();
    if (!_serviceEnabled) {
      return null;
    }
  }

  _permissionGranted = await location.hasPermission();
  if (_permissionGranted == PermissionStatus.denied) {
    _permissionGranted = await location.requestPermission();
    if (_permissionGranted != PermissionStatus.granted) {
      return null;
    }
  }

  _locationData = await location.getLocation();
  var d = latitude != null && longitude != null ? getDistanceFromLatLon(latitude, longitude, _locationData.latitude, _locationData.longitude) : null;
  //print('Distance Driver:'+ d.toString());
  if( d == null || d >= 5) {
    latitude = _locationData.latitude;
    longitude = _locationData.longitude;
    final response = await http.post(
      Uri.parse('https://safe-nomad.herokuapp.com/driver'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=utf-8',
      },
      body: jsonEncode(<String, dynamic>{
        'longitude': longitude,
        'latitude': latitude,
      }),
    );

    if (response.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      Map<String, dynamic> res = jsonDecode(response.body);
      //return Response.fromJson(jsonDecode(response.body));
      print( res);
      status.value = res['status'];

    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Failed to create response.');
    }
  }
  return;
}

_checkParking() async {
  Location location = new Location();

  bool _serviceEnabled;
  PermissionStatus _permissionGranted;
  LocationData _locationData;

  _serviceEnabled = await location.serviceEnabled();
  if (!_serviceEnabled) {
    _serviceEnabled = await location.requestService();
    if (!_serviceEnabled) {
      return null;
    }
  }

  _permissionGranted = await location.hasPermission();
  if (_permissionGranted == PermissionStatus.denied) {
    _permissionGranted = await location.requestPermission();
    if (_permissionGranted != PermissionStatus.granted) {
      return null;
    }
  }

  _locationData = await location.getLocation();
    latitude = _locationData.latitude;
    longitude = _locationData.longitude;
    final response = await http.post(
      Uri.parse('https://safe-nomad.herokuapp.com/parking'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=utf-8',
      },
      body: jsonEncode(<String, dynamic>{
        'longitude': longitude,
        'latitude': latitude,
      }),
    );
    print(response.statusCode);
    if (response.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      Map<String, dynamic> res = jsonDecode(response.body);
      //return Response.fromJson(jsonDecode(response.body));
      print( res);
      status.value = res['status'] + 5;

    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Failed to create response.');
    }

  return;
}
class DriverRoute extends StatefulWidget {
  final Map<String, String> arguments;
  DriverRoute(this.arguments);
  @override
  _DriverRoute createState() => _DriverRoute();
}
class _DriverRoute extends State<DriverRoute>  {
  CustomTimer customTimer =new CustomTimer(1, _getLocation );
 // Future<LocationData> driver_location;
  @override
  void initState() {
    super.initState();
    customTimer.startTime();
  }

  @override
  Widget build(BuildContext context) {
    //CustomTimer timer = new CustomTimer(5, _getLocation);
   // timer.startTime();
   // g_context = context;
    return Scaffold(

      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
        children:[

          ValueListenableBuilder(
            //TODO 2nd: listen playerPointsToAdd
            valueListenable: status,
            builder: (context, value, widget) {
              //TODO here you can setState or whatever you need

              if(customTimer.is_stopped){
                customTimer.startTime();
              }
              return   Container(
                width: 300.0,
                height: 300.0,
                decoration: new BoxDecoration(
                  color: colors[value],
                  shape: BoxShape.circle,
                ),
              child: Center(
                  child:Text( messages[value]
                  ,style: const TextStyle(fontWeight: FontWeight.bold),)
              ),);

            },
          ),
          ElevatedButton(
            onPressed: () {
              parking = true;
              customTimer.stopTimer();
              _checkParking();// Navigate back to first route when tapped.

            },
            child: Text('Check Parking!'),
        ),

        ]
      ),
      ),
    );
  }
  @override
  void dispose() {
    customTimer.stopTimer();
    super.dispose();
  }


}