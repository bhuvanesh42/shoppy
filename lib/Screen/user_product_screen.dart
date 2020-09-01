import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoppy/Provider/products.dart';
import 'package:shoppy/Screen/edit_product_screen.dart';
import 'package:shoppy/Widgets/app_drawer.dart';
import 'package:shoppy/Widgets/user_product.dart';

class UserPoductScreen extends StatelessWidget {
  static const rountname = '/userproductscreen';

  Future<void> _onrefresh(BuildContext context) async {
    await Provider.of<Products>(context, listen: false).fetchdata(true);
  }

  @override
  Widget build(BuildContext context) {
    /*final productdata = Provider.of<Products>(context);*/
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Poducts'),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.of(context).pushNamed(EditProductScreen.rountnam);
              })
        ],
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: _onrefresh(context),
        builder: (ctx, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : RefreshIndicator(
                    onRefresh: () => _onrefresh(context),
                    child: Consumer<Products>(
                      builder: (ctx,productdata ,_) => Padding(
                        padding: EdgeInsets.all(10),
                        child: ListView.builder(
                          itemBuilder: (_, i) => Column(
                            children: <Widget>[
                              Card(
                                  elevation: 5,
                                  child: UserProduct(
                                      productdata.item[i].id,
                                      productdata.item[i].title,
                                      productdata.item[i].imageurl)),
                            ],
                          ),
                          itemCount: productdata.item.length,
                        ),
                      ),
                    ),
                  ),
      ),
    );
  }
}
