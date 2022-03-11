import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/providers/product.dart';
import 'package:flutter_complete_guide/providers/products_provider.dart';
import 'package:provider/provider.dart';

class EditProductScreen extends StatefulWidget {
  static final routeName = '/editProduct';

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  String id;
  String title;
  String description;
  double price;
  String imageUrl;
  bool _isinit = false;
  bool isLoading = false;
  Product pd;
  @override
  void dispose() {
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusNode.removeListener(_updateImgURL);
    _imageUrlFocusNode.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    if (_isinit) {
      final tempProduct = ModalRoute.of(context).settings.arguments as Product;
      try {
        if (tempProduct.id != null) {
          pd = tempProduct;
          _imageUrlController.text = pd.imageUrl;
        }
      } catch (_) {
        pd = new Product(
            id: null, title: null, description: null, price: 0, imageUrl: null);
        _isinit = false;
      }
    }
    super.didChangeDependencies();
  }

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImgURL);
    _isinit = true;
    super.initState();
  }

  void _updateImgURL() {
    if (!_imageUrlFocusNode.hasFocus) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Edit Product'),
          actions: [
            IconButton(
              onPressed: () => submitForm(context),
              icon: Icon(Icons.save),
            )
          ],
        ),
        body: (isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Padding(
                padding: const EdgeInsets.all(15.0),
                child: Form(
                  key: _form,
                  child: ListView(
                    children: [
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Title',
                        ),
                        initialValue: pd.title,
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) => FocusScope.of(context)
                            .requestFocus(_priceFocusNode),
                        onSaved: (value) {
                          title = value;
                        },
                        validator: (val) {
                          if (val.trim() == '') {
                            return 'This field is required.';
                          } else
                            return null;
                        },
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Price',
                        ),
                        initialValue:
                            (pd.price != 0 ? pd.price.toString() : ''),
                        focusNode: _priceFocusNode,
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) => FocusScope.of(context)
                            .requestFocus(_descriptionFocusNode),
                        onSaved: (value) {
                          price = double.parse(value);
                        },
                        validator: (val) {
                          if (val.trim() == '') {
                            return 'This field is required.';
                          } else if (double.tryParse(val) == null) {
                            return 'Invalid number';
                          } else
                            return null;
                        },
                      ),
                      TextFormField(
                        initialValue: pd.description,
                        decoration: InputDecoration(
                          labelText: 'Description',
                        ),
                        focusNode: _descriptionFocusNode,
                        maxLines: 3,
                        keyboardType: TextInputType.multiline,
                        onSaved: (value) {
                          description = value;
                        },
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            margin: EdgeInsets.only(top: 8, right: 10),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.blueGrey,
                              ),
                            ),
                            child: _imageUrlController.text.isEmpty
                                ? Text('No URL Submitted')
                                : FittedBox(
                                    child: Image.network(
                                      _imageUrlController.text,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                          ),
                          Expanded(
                            child: TextFormField(
                              decoration:
                                  InputDecoration(labelText: 'Image URL'),
                              keyboardType: TextInputType.url,
                              textInputAction: TextInputAction.done,
                              controller: _imageUrlController,
                              focusNode: _imageUrlFocusNode,
                              onEditingComplete: () {
                                setState(() {});
                              },
                              onFieldSubmitted: (_) {
                                setState(() {
                                isLoading = true;
                                });
                                submitForm(context);
                              },
                              onSaved: (value) {
                                imageUrl = value;
                              },
                              validator: (val) {
                                if (val.trim() == '') {
                                  return 'This field is required.';
                                } else
                                  return null;
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              )));
  }

  submitForm(BuildContext ctx) {
    if (_form.currentState.validate()) {
      _form.currentState.save();

      setState(() {
        isLoading = true;
      });
      if (pd.id == null) {
        pd = new Product(
            id: null,
            title: title,
            price: price,
            description: description,
            imageUrl: imageUrl);
        Provider.of<Products>(ctx, listen: false)
            .addProduct(pd)
            .catchError((error) {
          return showDialog<Null>(
              context: context,
              builder: (ctx) {
                return AlertDialog(
                  title: Text('An error occured!'),
                  content: Text(error.toString()),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text('Close'),
                    ),
                  ],
                );
              });
        }).then((value) {
          setState(() {
            isLoading = false;
          });

          Navigator.of(context).pop();
        });
      } else {
        String tempID = pd.id;
        bool isFavorite = pd.isFavorite;
        pd = new Product(
            id: tempID,
            title: title,
            price: price,
            description: description,
            imageUrl: imageUrl,
            isFavorite: isFavorite);
        Provider.of<Products>(ctx, listen: false).updateProduct(pd);
        Navigator.of(context).pop();
      }
    }
  }
}
