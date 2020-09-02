import 'package:flutter/material.dart';

class HttpsException implements Exception{
  final String messege;
   HttpsException(this.messege);
   @override
  String toString() {

     return messege;
    /*return super.toString();*/
  }
}
