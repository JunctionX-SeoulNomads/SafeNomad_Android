import 'package:flutter/material.dart';
import 'dart:math';
double getDistanceFromLatLon(lat1,lon1,lat2,lon2) {
  var R = 6371; // Radius of the earth in km
  var dLat = deg2rad(lat2-lat1);  // deg2rad below
  var dLon = deg2rad(lon2-lon1);
  var a =
      sin(dLat/2) * sin(dLat/2) +
          cos(deg2rad(lat1)) * cos(deg2rad(lat2)) *
              sin(dLon/2) * sin(dLon/2)
  ;
  var c = 2 * atan2(sqrt(a), sqrt(1-a));
  var d = R * c; // Distance in km
  return d * 1000;
}

double deg2rad(deg) {
  return deg * (pi/180);
}