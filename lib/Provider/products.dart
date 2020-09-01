import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shoppy/Model/https_exception.dart';

import 'product.dart';

class Products with ChangeNotifier {
  List<Product> _items = [
    /* Product(
      id: 'p1',
      title: 'Red Shirt',
      description: 'A red shirt - it is pretty red!',
      price: 29.99,
      imageurl:
          'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    ),
    Product(
      id: 'p2',
      title: 'Trousers',
      description: 'A nice pair of trousers.',
      price: 59.99,
      imageurl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    ),
    Product(
      id: 'p3',
      title: 'Yellow Scarf',
      description: 'Warm and cozy - exactly what you need for the winter.',
      price: 19.99,
      imageurl:
          'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    ),
    Product(
      id: 'p4',
      title: 'A Pan',
      description: 'Prepare any meal you want.',
      price: 49.99,
      imageurl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    ),*/
  ];
  final String authToken;
  final String userid;

  Products(this.authToken, this.userid, this._items);

  List<Product> get item {
    return [..._items];
  }

  List<Product> get favoriteItems {
    return _items.where((element) => element.isFavorites).toList();
  }

  Product findbyid(String id) {
    return _items.firstWhere((pro) => pro.id == id);
  }

  Future<void> fetchdata([bool filterproducts = false]) async {
    final filterpro = filterproducts ? 'orderBy="creatorId"&equalTo="$userid"' : '';
    var url =
        'https://flutter-shop-3c829.firebaseio.com/products.json?auth=$authToken&$filterpro';
    try {
      final response = await http.get(url);
      print(json.decode(response.body));
      final extractdata = json.decode(response.body) as Map<String, dynamic>;

      if (extractdata == null) {
        return;
      }
      url =
          'https://flutter-shop-3c829.firebaseio.com/userfavories/$userid.json?auth=$authToken';
      final favoritesresponse = await http.get(url);
      final favoritesdata = json.decode(favoritesresponse.body);
      final List<Product> loadedproduct = [];
      extractdata.forEach((key, value) {
        loadedproduct.add(Product(
            id: key,
            title: value['title'],
            description: value['description'],
            imageurl: value['imageurl'],
            price: value['price'],
            isFavorites:
                favoritesdata == null ? false : favoritesdata[key] ?? false));
      });
      _items = loadedproduct;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> addProduct(Product product) async {
    final url =
        'https://flutter-shop-3c829.firebaseio.com/products.json?auth=$authToken';
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'title': product.title,
          'price': product.price,
          'description': product.description,
          'imageurl': product.imageurl,
          'creatorId': userid,
        }),
      );

      final newproduct = Product(
          id: json.decode(response.body)['name'],
          description: product.description,
          title: product.title,
          imageurl: product.imageurl,
          price: product.price);

      _items.add(newproduct);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> updateproduct(String id, Product newproduct) async {
    final proindex = _items.indexWhere((element) => element.id == id);
    if (proindex >= 0) {
      final url =
          'https://flutter-shop-3c829.firebaseio.com/products/$id.json?auth=$authToken';
      await http.patch(url,
          body: json.encode({
            'title': newproduct.title,
            'description': newproduct.description,
            'price': newproduct.price,
            'imageurl': newproduct.imageurl,
          }));
      _items[proindex] = newproduct;
      notifyListeners();
    } else {
      print('>>>>');
    }
  }

  Future<void> deleteproduct(String id) async {
    print('step2 ');
    final url =
        'https://flutter-shop-3c829.firebaseio.com/products/$id.json?auth=$authToken';
    final existingproductindex =
        _items.indexWhere((element) => element.id == id);
    var existingproduct = _items[existingproductindex];
    _items.removeAt(existingproductindex);
    notifyListeners();
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(existingproductindex, existingproduct);
      notifyListeners();
      throw HttpsException('Could delete product');
    }
    existingproduct = null;
  }
}
