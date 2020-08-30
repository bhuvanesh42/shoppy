import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Provider/product.dart';
import '../Provider/products.dart';

class EditProductScreen extends StatefulWidget {
  static const rountnam = '/editproduct';

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _pricefocusnode = FocusNode();
  final _descritionfocusnode = FocusNode();
  final _imageurlcontroller = TextEditingController();
  final _imageurlfocusnode = FocusNode();
  final _form = GlobalKey<FormState>();

  var editproduct =
      Product(id: null, title: '', price: 0, description: '', imageurl: '');

  var _intivalues = {
    'title': '',
    'price': '',
    'description': '',
    'imageurl': '',
  };
  var _Isint = true;
  var _isloading = false;

  @override
  void initState() {
    // TODO: implement initState
    _imageurlfocusnode.addListener(_updateImageurl);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies

    if (_Isint) {
      final productid = ModalRoute.of(context).settings.arguments as String;
      if (productid != null) {
        editproduct =
            Provider.of<Products>(context, listen: false).findbyid(productid);
        _intivalues = {
          'title': editproduct.title,
          'price': editproduct.price.toString(),
          'description': editproduct.description,
          'imageurl': '',
        };
        _imageurlcontroller.text = editproduct.imageurl;
      }
    }
    _Isint = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _imageurlfocusnode.removeListener(_updateImageurl);
    _descritionfocusnode.dispose();
    _pricefocusnode.dispose();
    _imageurlcontroller.dispose();
    _imageurlfocusnode.dispose();
    super.dispose();
  }

  void _updateImageurl() {
    if (!_imageurlfocusnode.hasFocus) {
      if ((!_imageurlcontroller.text.startsWith('http') &&
              !_imageurlcontroller.text.startsWith('https')) ||
          (!_imageurlcontroller.text.endsWith('.jpg') &&
              !_imageurlcontroller.text.endsWith('.png') &&
              !_imageurlcontroller.text.endsWith('jpeg'))) {
        return;
      }

      setState(() {});
    }
  }

  Future<void> _saveform() async {
    final validate = _form.currentState.validate();
    if (!validate) {
      return;
    }
    _form.currentState.save();
    setState(() {
      _isloading = true;
    });
    if (editproduct.id != null) {
    await  Provider.of<Products>(context, listen: false)
          .updateproduct(editproduct.id, editproduct);

    } else {
      try {
        await Provider.of<Products>(context, listen: false)
            .addProduct(editproduct);
      } catch (error) {
       await showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: Text('An error accured'),
                  content: Text('Something went worng'),
                  actions: <Widget>[
                    FlatButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('Okay'))
                  ],
                ));
      }/* finally {
        setState(() {
          _isloading = true;
        });
        Navigator.of(context).pop();
      }*/

    }
    setState(() {
      _isloading = true;
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add products'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveform,
          )
        ],
      ),
      body: _isloading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: EdgeInsets.all(25),
              child: Form(
                  key: _form,
                  child: ListView(
                    children: <Widget>[
                      TextFormField(
                        initialValue: _intivalues['title'],
                        decoration: InputDecoration(labelText: 'Title'),
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_pricefocusnode);
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'plase provide title';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          editproduct = Product(
                              id: editproduct.id,
                              isFavorites: editproduct.isFavorites,
                              title: value,
                              price: editproduct.price,
                              imageurl: editproduct.imageurl,
                              description: editproduct.description);
                        },
                      ),
                      TextFormField(
                        initialValue: _intivalues['price'],
                        decoration: InputDecoration(labelText: 'Price'),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        focusNode: _pricefocusnode,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context)
                              .requestFocus(_descritionfocusnode);
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'enter price';
                          }
                          if (double.tryParse(value) == null) {
                            return ' enter valid number';
                          }
                          if (double.parse(value) <= 0) {
                            return ' enter amount grater then zero';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          editproduct = Product(
                              id: editproduct.id,
                              isFavorites: editproduct.isFavorites,
                              title: editproduct.title,
                              price: double.parse(value),
                              imageurl: editproduct.imageurl,
                              description: editproduct.description);
                        },
                      ),
                      TextFormField(
                        initialValue: _intivalues['description'],
                        decoration: InputDecoration(labelText: 'Description'),
                        maxLines: 3,
                        keyboardType: TextInputType.multiline,
                        focusNode: _descritionfocusnode,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'enter description';
                          }
                          if (value.length < 0) {
                            return ' enter at least 10 characters ';
                          }

                          return null;
                        },
                        onSaved: (value) {
                          editproduct = Product(
                              id: editproduct.id,
                              isFavorites: editproduct.isFavorites,
                              title: editproduct.title,
                              price: editproduct.price,
                              imageurl: editproduct.imageurl,
                              description: value);
                        },
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Container(
                            width: 100,
                            height: 100,
                            margin: EdgeInsets.only(top: 8, right: 10),
                            decoration: BoxDecoration(
                                border:
                                    Border.all(width: 1, color: Colors.grey)),
                            child: _imageurlcontroller.text.isEmpty
                                ? Text('Enter Url')
                                : FittedBox(
                                    child:
                                        Image.network(_imageurlcontroller.text),
                                    fit: BoxFit.cover,
                                  ),
                          ),
                          Expanded(
                            child: TextFormField(
                              decoration:
                                  InputDecoration(labelText: 'ImageURl'),
                              keyboardType: TextInputType.url,
                              textInputAction: TextInputAction.done,
                              controller: _imageurlcontroller,
                              focusNode: _imageurlfocusnode,
                              onFieldSubmitted: (_) {
                                _saveform();
                              },
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'enter ImageUrl';
                                }
                                if (!value.startsWith('http') &&
                                    !value.startsWith('https')) {
                                  return ' enter valid url http or https at starting ';
                                }
                                if (!value.endsWith('.jpg') &&
                                    !value.endsWith('.png') &&
                                    !value.endsWith('jpeg')) {
                                  return ' image url must end with .jpg or .png or . jpeg';
                                }

                                return null;
                              },
                              onSaved: (value) {
                                editproduct = Product(
                                    id: editproduct.id,
                                    isFavorites: editproduct.isFavorites,
                                    title: editproduct.title,
                                    price: editproduct.price,
                                    imageurl: value,
                                    description: editproduct.description);
                              },
                            ),
                          ),
                        ],
                      )
                    ],
                  )),
            ),
    );
  }
}
