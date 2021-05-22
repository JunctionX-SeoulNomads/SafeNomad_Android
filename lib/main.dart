import 'package:flutter/material.dart';
import 'package:safe_nomad/pages/driver.dart';
import 'package:safe_nomad/pages/nomad.dart';
import 'dart:async';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      onGenerateRoute: (routerSettings){
        switch(routerSettings.name){
          case '/':
            return MaterialPageRoute(builder: (_) => MyHomePage(title: 'SafeNomad') );
          case '/driver_main':
            return  MaterialPageRoute(builder: (_) => DriverRoute(routerSettings.arguments));
          case '/nomad_main':
            return MaterialPageRoute(builder: (_) => NomadRoute(routerSettings.arguments));
          default:
            return MaterialPageRoute(builder: (_) =>MyHomePage(title: 'Unknown'));

        }

      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);


  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {



  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(

        title: Text(widget.title),
      ),
      body: Center(

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                      SizedBox(
                      width: MediaQuery.of(context).size.width * 0.4,
                      height: MediaQuery.of(context).size.width * 0.4,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Colors.black,
                            textStyle: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold)),
                        onPressed: () {
                          Navigator.pushNamed(context, '/driver_main', arguments: {"user": "user"});
                        },
                        child: Text("Driver"),
                      ),
                    ),
                  SizedBox(
                      width: MediaQuery.of(context).size.width * 0.4,
                      height: MediaQuery.of(context).size.width * 0.4,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Colors.black,
                            textStyle: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold)),
                        onPressed: () {
                          Navigator.pushNamed(context, '/nomad_main', arguments: {"user": "user"});

                        },
                        child: Text("Nomad"),
                      ),
                    ),
                ],
            )


          ],
        ),
      ),
// This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
