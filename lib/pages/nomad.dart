import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:safe_nomad/pages/CustomTimer.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';
double longitude;
double latitude;
void _getLocation() async {
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
    body: jsonEncode(<String, double>{
      'longitude': longitude,
      'latitude' : latitude,
    }),
  );

  if (response.statusCode == 200) {
    // If the server did return a 201 CREATED response,
    // then parse the JSON.
    print('success');
  } else {
    // If the server did not return a 201 CREATED response,
    // then throw an exception.
    throw Exception('Failed to create response.');
  }
  return;
}
class NomadRoute extends StatelessWidget {
  final Map<String, String> arguments;
  NomadRoute(this.arguments);
  @override
  Widget build(BuildContext context) {
    CustomTimer timer = new CustomTimer(10, _getLocation);
    timer.startTime();
    return Scaffold(

      body: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.4,
          height: MediaQuery.of(context).size.width * 0.4,
            child:ElevatedButton(
              style: ElevatedButton.styleFrom(
                  primary: Colors.red,
                  textStyle: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold)),
              onPressed: () {
                timer.stopTimer();
                Navigator.pushNamed(context, '/report', arguments: {"user": "user"});

                //timer.startTime();
              },
              child: Text('Report!'),
            ),
        ),
      ),
    );
  }
}