import 'package:flutter/material.dart';
import 'package:shoppy/Screen/orders_screen.dart';

class AppDrawer extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            title: Text('Shoppy Menu'),
            automaticallyImplyLeading: false,
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.shop),
            title: Text('shop',style: TextStyle(fontSize: 20)),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.payment),
            title: Text('Orders',style: TextStyle(fontSize: 20),),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(OrdersScreen.routname);
            },
          )
        ],
      ),
    );
  }
}
