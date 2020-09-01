import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoppy/Widgets/app_drawer.dart';
import 'package:shoppy/Widgets/order_item.dart';

import '../Provider/order.dart';

class OrdersScreen extends StatefulWidget {
  static const routname = '/ordrscreen';

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  var isloading = false;
  @override
  void initState() {
    Future.delayed(Duration.zero).then((_)  async{
      setState(() {
        isloading =  true;
      });
    await Provider.of<Order>(context, listen: false).fetchorder();
      setState(() {
        isloading =  false;
      });
    });

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final orderdata = Provider.of<Order>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      drawer: AppDrawer(),
      body: isloading ? Center(child: CircularProgressIndicator(),) : ListView.builder(
        itemBuilder: (ctx, i) =>  OrderItem(orderdata.order[i]),
        itemCount: orderdata.order.length,
      ),
    );
  }
}
