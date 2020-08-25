import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoppy/Provider/products.dart';

class ProductDetails extends StatelessWidget {
  static const routname = '/product_details';

  @override
  Widget build(BuildContext context) {
    final productid = ModalRoute.of(context).settings.arguments as String;
    final loadedbyproduct =
        Provider.of<Products>(context, listen: false).findbyid(productid);
    return Scaffold(
      appBar: AppBar(
        title: Text(loadedbyproduct.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 10,
            ),
            Container(
              height: 300,
              width: double.infinity,
              child: Image.network(
                loadedbyproduct.imageurl,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'Price \$ ${loadedbyproduct.price}',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              width: double.infinity,
              child: Text(
                loadedbyproduct.description,
                textAlign: TextAlign.center,
                softWrap: true,
                style: TextStyle(fontSize: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
