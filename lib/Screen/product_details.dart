import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoppy/Provider/products.dart';

class ProductDetails extends StatelessWidget {
  static const routname = '/product_details';
  @override
  Widget build(BuildContext context) {
    final productid = ModalRoute.of(context).settings.arguments as String;
    final loadedbyproduct = Provider.of<Products>(context, listen: false).findbyid(productid);
    return Scaffold(
      appBar: AppBar(title: Text(loadedbyproduct.title),),
    );
  }
}
