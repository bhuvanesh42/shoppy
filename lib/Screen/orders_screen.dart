import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoppy/Widgets/app_drawer.dart';
import 'package:shoppy/Widgets/order_item.dart';

import '../Provider/order.dart';

class OrdersScreen extends StatelessWidget {
  static const routname = '/ordrscreen';
  @override
  Widget build(BuildContext context) {
    final orderdata = Provider.of<Order>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      drawer: AppDrawer(),
      body: ListView.builder(
        itemBuilder: (ctx, i) =>  OrderItem(orderdata.order[i]),
        itemCount: orderdata.order.length,
      ),
    );
  }
}
