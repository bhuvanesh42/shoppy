import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shoppy/Provider/order.dart';

class OrderItem extends StatefulWidget {
  final Orderitem order;

  OrderItem(this.order);

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  var _expand = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text('\$${widget.order.amount}'),
            subtitle: Text(
                DateFormat('dd MM yyyy hh:mm').format(widget.order.dateTime)),
            trailing: IconButton(
                icon: Icon(_expand ? Icons.expand_less : Icons.expand_more),
                onPressed: () {
                  setState(() {
                    _expand = !_expand;
                  });
                }),
          ),
          if (_expand)
            Card(
              elevation: 2,
              margin: EdgeInsets.all(15),
              child: Container(
                height: min(widget.order.products.length * 20.0 + 20, 100),
                child: ListView(
                  children: widget.order.products
                      .map((pros) => Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Text(
                                pros.title,
                                style: TextStyle(fontSize: 20),
                              ),
                              Text(
                                '${pros.quantity} X ${pros.price}',
                                style: TextStyle(fontSize: 20),
                              )
                            ],
                          ))
                      .toList(),
                ),
              ),
            )
        ],
      ),
    );
  }
}
