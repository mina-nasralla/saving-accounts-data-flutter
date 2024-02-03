
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void ToastMsg({
  required String text,
  required Color color,

}) {
  Fluttertoast.showToast(
      msg: text,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 4,
      backgroundColor: color,
      textColor: Colors.white,
      fontSize: 16.0);
}