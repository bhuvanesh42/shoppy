import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoppy/Provider/cart.dart';
import 'package:shoppy/Screen/cart_screen.dart';
import 'package:shoppy/Widgets/app_drawer.dart';
import 'package:shoppy/Widgets/badge.dart';

import '../Widgets/product_grid.dart';

enum FavoritesOtion { Favorites, All }

class ProductOverViewScreen extends StatefulWidget {
  @override
  _ProductOverViewScreenState createState() => _ProductOverViewScreenState();
}

class _ProductOverViewScreenState extends State<ProductOverViewScreen> {
  var _showonlyfavorites = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shoppy'),
        actions: <Widget>[
          PopupMenuButton(
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text('Only Favorites'),
                value: FavoritesOtion.Favorites,
              ),
              PopupMenuItem(
                child: Text('Show All'),
                value: FavoritesOtion.All,
              )
            ],
            onSelected: (FavoritesOtion selectedValue) {
              setState(() {
                if (selectedValue == FavoritesOtion.Favorites) {
                  _showonlyfavorites = true;
                } else {
                  _showonlyfavorites = false;
                }
              });
            },
            icon: Icon(Icons.more_vert),
          ),
          Consumer<Cart>(
            builder: (_, cart, ch) => Badge(child: ch, value: cart.itemcount.toString()),
            child: IconButton(icon: Icon(Icons.shopping_cart, color: Colors.white,), onPressed: (){
              Navigator.of(context).pushNamed(CartScreen.routname);
            }),
          )
        ],
      ),
      drawer: AppDrawer(),
      body: ProductGrid(_showonlyfavorites),
    );
  }
}
