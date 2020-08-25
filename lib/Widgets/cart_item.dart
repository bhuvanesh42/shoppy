import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Provider/cart.dart';

class CartItem extends StatelessWidget {
  final String id;
  final String productid;
  final double price;
  final int quantity;
  final String title;

  CartItem(this.id, this.productid, this.price, this.quantity, this.title);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(id),
      background: Container(
        color: Theme.of(context).errorColor,
        child: Icon(
          Icons.delete_forever,
          color: Colors.white,
          size: 30,
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) {
        return showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: Text('Are you sure..'),
                  titleTextStyle: TextStyle(fontFamily: 'KirangHaerang-Regular',color: Colors.black,fontSize: 20),
                  content: Text('do you want to delete this cart item ?'),
                  actions: <Widget>[
                    FlatButton(
                        onPressed: () {
                          Navigator.of(ctx).pop(false);
                        },
                        child: Text('NO')),
                    FlatButton(
                        onPressed: () {
                          Navigator.of(ctx).pop(true);
                        },
                        child: Text('YES'))
                  ],
                ));
      },
      onDismissed: (direction) {
        Provider.of<Cart>(context, listen: false).removeitem(productid);
      },
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Padding(
          padding: EdgeInsets.all(10),
          child: ListTile(
            leading: CircleAvatar(
              child: Padding(
                  padding: EdgeInsets.all(3),
                  child: FittedBox(child: Text('\$ $price'))),
            ),
            title: Text(title),
            subtitle: Text('Total : \$ ${(price * quantity)}'),
            trailing: Text('$quantity X'),
          ),
        ),
      ),
    );
  }
}
