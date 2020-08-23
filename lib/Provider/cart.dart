import 'package:flutter/foundation.dart';

class CartItem {
  final String id;
  final String title;
  final int quantity;
  final double price;

  CartItem({@required this.id,
    @required this.title,
    @required this.price,
    @required this.quantity});
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get item {
    return {..._items};
}
int get itemcount {
    return _items.length;
}

  void additem(String productid, double price, String title) {
    if (_items.containsKey(productid)) {
      _items.update(productid, (existingvalue) =>
          CartItem(id: existingvalue.id,
              title: existingvalue.title,
              price: existingvalue.price,
              quantity: existingvalue.quantity + 1));
    } else {
      _items.putIfAbsent(productid, () =>
          CartItem(id: DateTime.now().toString(),
              title: title,
              price: price,
              quantity: 1));
    }
    notifyListeners();
  }
}
