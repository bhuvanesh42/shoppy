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

      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(title:Text(loadedbyproduct.title),
            background: Container(
              height: 300,
              width: double.infinity,
              child: Hero(
                tag: loadedbyproduct.id,
                child: Image.network(
                  loadedbyproduct.imageurl,
                  fit: BoxFit.cover,
                ),
              ),
            ),),

          ),
          SliverList(
              delegate: SliverChildListDelegate([
            SizedBox(
              height: 10,
            ),
            Text(
              'Price \$ ${loadedbyproduct.price}',
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
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
          ])),
        ],

      ),
    );
  }
}
