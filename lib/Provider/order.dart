import 'package:flutter/foundation.dart';

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
  List<Orderitem> _order = [];

  List<Orderitem> get order {
    return [..._order];
  }

  void addorder(List<CartItem> cartpoduct, double total) {
    _order.insert(
        0,
        Orderitem(
            id: DateTime.now().toString(),
            amount: total,
            products: cartpoduct,
            dateTime: DateTime.now()));
    notifyListeners();
  }
}
