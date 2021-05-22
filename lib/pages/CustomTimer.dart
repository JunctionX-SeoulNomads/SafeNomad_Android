import 'dart:async';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
typedef void VoidCallback();
class CustomTimer{
  var interval;
  Timer timer;

  void Function() callback;
  CustomTimer(this.interval, this.callback);
     void  startTime(){
      var duration =  Duration(seconds:interval);
      timer = new Timer.periodic(duration, (Timer t) => callback());
    }
    void stopTimer(){
      timer.cancel();
    }

}