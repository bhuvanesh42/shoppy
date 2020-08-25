import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoppy/Provider/order.dart';

import '../Provider/cart.dart' show Cart;
import '../Widgets/cart_item.dart';

class CartScreen extends StatelessWidget {
  static const routname = '/cart';

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('your cart'),
      ),
      body: Column(
        children: <Widget>[
          Card(
            margin: EdgeInsets.all(10),
            elevation: 6,
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Text(
                    'Total',
                    style: TextStyle(
                        fontFamily: 'KirangHaerang-Regular', fontSize: 18),
                  ),
                  Chip(
                    label: Text(
                       '\$ ${cart.totalamount.toStringAsFixed(2)}',
                      style: TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  FlatButton(
                      onPressed: () {
                        Provider.of<Order>(context, listen: false).addorder(
                            cart.item.values.toList(), cart.totalamount);
                        cart.clear();
                      },
                      child: Text(
                        'Order Now',
                        style: TextStyle(
                            fontFamily: 'KirangHaerang-Regular',
                            fontSize: 20,
                            color: Colors.blueGrey),
                      ))
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
              child: ListView.builder(
            itemBuilder: (ctx, i) => CartItem(
                cart.item.values.toList()[i].id,
                cart.item.keys.toList()[i],
                cart.item.values.toList()[i].price,
                cart.item.values.toList()[i].quantity,
                cart.item.values.toList()[i].title),
            itemCount: cart.item.length,
          ))
        ],
      ),
    );
  }
}
