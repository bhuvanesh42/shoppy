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

  double get totalamount {
    var total = 0.0;
    _items.forEach((key, cartitem) {
      total += cartitem.price * cartitem.quantity;
    });
    return total;
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

  void removeitem(String productid) {
    _items.remove(productid);
    notifyListeners();
  }

  void clear() {
    _items = {};
    notifyListeners();
  }

  void removefromcart(String productid) {
    if (!_items.containsKey(productid)) {
      return;
    }
    if (_items[productid].quantity > 1) {
      _items.update(productid, (ex) =>
          CartItem(id: ex.id,
              title: ex.title,
              price: ex.price,
              quantity: ex.quantity - 1));
    }else{
      _items.remove(productid);
    }
    notifyListeners();
  }

}
