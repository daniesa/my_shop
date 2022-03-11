
import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/Screens/addEdit_product_screen.dart';
import 'package:flutter_complete_guide/providers/product.dart';
import 'package:flutter_complete_guide/providers/products_provider.dart';
import 'package:provider/provider.dart';

class UserProductItem extends StatelessWidget {
  final Product product;

  const UserProductItem({Key key, this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final productsData = Provider.of<Products>(context);
    return ListTile(
      title: Text(product.title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(
          product.imageUrl,
        ),
      ),
      trailing: SizedBox(
        width: 150,
        child: Row(
          children: [
            IconButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(EditProductScreen.routeName, arguments: product);
              },
              icon: Icon(Icons.edit),
              color: Theme.of(context).primaryColor,
            ),
            IconButton(
              onPressed: () {
                return showDialog(
                    context: context,
                    builder: (_) {
                      return AlertDialog(
                        title: Text("Deleting..."),
                        content: Text('Are you sure to delete this product?'),
                        actions: [
                          TextButton(
                            onPressed: () async {
                              try
                              {
                              await productsData.deleteProduct(product);
                              Navigator.of(context).pop();
                              }
                              catch(error){
                                  scaffoldMessenger.showSnackBar(SnackBar(content: Center(child: Text('Deleting Failed.'))));
                              }
                            },
                            child: Text('Yes'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text('No'),
                          ),
                        ],
                      );
                    });
              },
              icon: Icon(
                Icons.delete,
              ),
            )
          ],
        ),
      ),
    );
  }
}
