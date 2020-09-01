import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../Provider/cart.dart';

class Orderitem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  Orderitem(
      {@required this.id,
      @required this.amount,
      @required this.products,
      @required this.dateTime});
}

class Order with ChangeNotifier {

  final String token;
  final String userid;
  Order(this.token,this.userid, this._order);
  List<Orderitem> _order = [];

  List<Orderitem> get order {
    return [..._order];
  }

  Future<void> fetchorder() async {
    final url = 'https://flutter-shop-3c829.firebaseio.com/orders/$userid.json?auth=$token';
    final response = await http.get(url);
    final List<Orderitem> loadeditem = [];
    final extracteditem = json.decode(response.body) as Map<String, dynamic>;
    if (extracteditem == null) {
      return;
    }
    extracteditem.forEach((key, value) {
      loadeditem.add(Orderitem(
        id: key,
        amount: value['amount'],
        dateTime:  DateTime.parse(value['datetime'],),
        products: (value['products'] as List<dynamic>).map((e) => CartItem(
          id: e['id'],
          price: e['price'],
          title: e['title'],
          quantity: e['quantity']
        )).toList()
      ));
    });
    _order = loadeditem.reversed.toList();
    notifyListeners();
  }

  Future<void> addorder(List<CartItem> cartpoduct, double total) async {
    final url = 'https://flutter-shop-3c829.firebaseio.com/orders/$userid.json?auth=$token';
    final timestamp = DateTime.now();
    final response = await http.post(url,
        body: json.encode({
          'amount': total,
          'datetime': timestamp.toIso8601String(),
          'products': cartpoduct
              .map((e) => {
                    'id': e.id,
                    'title': e.title,
                    'quantity': e.quantity,
                    'price': e.price
                  })
              .toList(),
        }));

    _order.insert(
        0,
        Orderitem(
            id: json.decode(response.body)['name'],
            amount: total,
            products: cartpoduct,
            dateTime: DateTime.now()));
    notifyListeners();
  }
}
