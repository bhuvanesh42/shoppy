import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageurl;
  bool isFavorites;

  Product(
      {@required this.id,
      @required this.description,
      @required this.title,
      @required this.imageurl,
      this.isFavorites = false,
      @required this.price});

  Future<void> toggelestatus(String token, String userid) async{
    final oldstatus = isFavorites;
    isFavorites = !isFavorites;
    notifyListeners();
    final url = 'https://flutter-shop-3c829.firebaseio.com/userfavories/$userid/$id.json?auth=$token';
    try{
      await http.put(url, body:  json.encode(
        isFavorites,
      ));
    }catch(error){
      isFavorites = oldstatus;
      notifyListeners();
    }

  }
}
