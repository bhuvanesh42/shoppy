import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoppy/Provider/auth.dart';
import 'package:shoppy/Provider/cart.dart';

import '../Provider/product.dart';
import '../Screen/product_details.dart';

class ProductItem extends StatelessWidget {
  /* final String id;
  final String title;
  final String imageurl;

  ProductItem(this.id, this.title, this.imageurl);*/

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    final authdata = Provider.of<Auth>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context)
                .pushNamed(ProductDetails.routname, arguments: product.id);
          },
          child: Image.network(
            product.imageurl,
            fit: BoxFit.cover,
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black54,
          leading: Consumer<Product>(
            builder: (ctx, product, _) => IconButton(
                icon: Icon(
                  product.isFavorites ? Icons.favorite : Icons.favorite_border,
                  color: Colors.red[800],
                ),
                onPressed: () => product.toggelestatus(authdata.token, authdata.userid)),
          ),
          title: Text(
            product.title,
            style: Theme.of(context).textTheme.title,
            textAlign: TextAlign.center,
          ),
          trailing: IconButton(
              icon: Icon(Icons.shopping_cart, color: Colors.grey[300]),
              onPressed: () {
                cart.additem(product.id, product.price, product.title);
                Scaffold.of(context).hideCurrentSnackBar();
                Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text('Added to cart'),
                  duration: Duration(seconds: 2),
                  action: SnackBarAction(label: 'UNDO',onPressed: (){
                    cart.removefromcart(product.id);
                  },),
                ));
              }),
        ),
      ),
    );
  }
}
