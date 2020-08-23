import 'package:flutter/foundation.dart';

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

  void toggelestatus(){
    isFavorites = !isFavorites;
    notifyListeners();
  }
}
