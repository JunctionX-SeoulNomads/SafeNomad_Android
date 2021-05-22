import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';
double longitude;
double latitude;
String userID;
Future<String> _sendReport(String Message) async {
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
    Uri.parse('https://safe-nomad.herokuapp.com/complain'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=utf-8',
    },
    body: jsonEncode(<String, dynamic>{
      'userId': userID,
      'message': Message,
      'longitude': longitude,
      'latitude' : latitude,
    }),
  );

  if (response.statusCode == 200) {
    // If the server did return a 201 CREATED response,
    // then parse the JSON.
    print('reported');
    print(Message);
    return Message;
  } else {
    // If the server did not return a 201 CREATED response,
    // then throw an exception.
    throw Exception('Failed to create response.');
  }

}
class ReportPage extends StatelessWidget {
  final Map<String, String> arguments;
  Future<String> Response;
  ReportPage(this.arguments);
  final messageController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    userID = arguments['user'];
    return Scaffold(

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
        children:[
          FutureBuilder<String>(
            future: Response,
            builder: (context, snapshot) {
              if (snapshot.hasData) {

                return AlertDialog(
                  title: const Text('Notification'),
                  content: const Text('Your message has been sent'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.pop(context, 'OK'),
                      child: const Text('OK'),
                    ),
                  ],
                );
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }

              // By default, show a loading spinner.
              return SizedBox();
            },
          ),
          Card(
              color: Colors.white,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: TextField(
                  maxLines: 8,
                  controller: messageController,
                  decoration: InputDecoration.collapsed(hintText: "Enter your text here"),
                ),
              )
          ),
          Divider(),
          SizedBox(
            width:  MediaQuery.of(context).size.width * 0.3,
            height:  MediaQuery.of(context).size.width * 0.2,
                child:ElevatedButton(
                    onPressed: () {
                      Response = _sendReport(messageController.text.toString());
                      //Navigator.pop(context);// Navigate back to first route when tapped.
                    },
                    child: Text('Report!'),
            ),
          ),

    ]
      ),
    ),
    );
  }
}