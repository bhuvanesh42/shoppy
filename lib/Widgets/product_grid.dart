import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Provider/products.dart';
import '../Widgets/product_item.dart';

class ProductGrid extends StatelessWidget {
  final bool shw;
  ProductGrid(this.shw);
  @override
  Widget build(BuildContext context) {
    final productdatas = Provider.of<Products>(context);
    final products = shw ? productdatas.favoriteItems : productdatas.item;
    return GridView.builder(
        padding: EdgeInsets.all(10),
        itemCount: products.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 3 / 2,
        ),
        itemBuilder: (ctx, i) =>
            ChangeNotifierProvider.value(
              value: products[i],
              child: ProductItem(),
            )
    );
  }
}
