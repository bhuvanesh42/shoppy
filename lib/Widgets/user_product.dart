import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoppy/Provider/products.dart';
import 'package:shoppy/Screen/edit_product_screen.dart';

class UserProduct extends StatelessWidget {
  final String id;
  final String title;
  final String imageurl;

  UserProduct(this.id, this.title, this.imageurl);

  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold.of(context);
    return ListTile(
      title: Text(title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageurl),
      ),
      trailing: Container(
        width: 100,
        child: Row(
          children: <Widget>[
            IconButton(
                icon: Icon(
                  Icons.edit,
                  color: Theme.of(context).primaryColor,
                ),
                onPressed: () {
                  Navigator.of(context)
                      .pushNamed(EditProductScreen.rountnam, arguments: id);
                }),
            IconButton(
                icon: Icon(
                  Icons.delete,
                  color: Theme.of(context).errorColor,
                ),
                onPressed: () {
                  try {
                    Provider.of<Products>(context, listen: false)
                        .deleteproduct(id);
                  } catch (error) {
                    scaffold.showSnackBar(
                        SnackBar(content: Text('Daleting failed')));
                  }
                })
          ],
        ),
      ),
    );
  }
}
