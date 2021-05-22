import 'dart:async';
import 'dart:convert';
import 'package:safe_nomad/pages/CustomTimer.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
double longitude;
double latitude;
String userID;
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

  latitude = _locationData.latitude;
  longitude = _locationData.longitude;
  final response = await http.post(
    Uri.parse('https://safe-nomad.herokuapp.com/driver'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=utf-8',
    },
    body: jsonEncode(<String, dynamic>{
      'userId': userID,
      'longitude': longitude,
      'latitude' : latitude,
    }),
  );

  if (response.statusCode == 200) {
    // If the server did return a 201 CREATED response,
    // then parse the JSON.
    Map<String, dynamic> res = jsonDecode(response.body);
    //return Response.fromJson(jsonDecode(response.body));
    print(res['status']);
  } else {
    // If the server did not return a 201 CREATED response,
    // then throw an exception.
    throw Exception('Failed to create response.');
  }
  return;
}

class DriverRoute extends StatelessWidget {
  final Map<String, String> arguments;
  DriverRoute(this.arguments);
 // Future<LocationData> driver_location;
  @override
  Widget build(BuildContext context) {
    userID = arguments['user'];
    CustomTimer timer = new CustomTimer(5, _getLocation);
    timer.startTime();
    return Scaffold(
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
        children:[
          ElevatedButton(
            onPressed: () {
              timer.stopTimer();
              Navigator.pop(context);// Navigate back to first route when tapped.
            },
            child: Text('Go back!'),
        ),

        ]
      ),
      ),
    );
  }
}