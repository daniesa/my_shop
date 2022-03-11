import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/providers/product.dart';

class ProductDetailScreen extends StatelessWidget {
  //final Product product;

  //const ProductDetailScreen( this.product);

  static const String routeName = '/ProductDetail';
  @override
  Widget build(BuildContext context) {
    final product =
        ModalRoute.of(context).settings.arguments as Product; // is the id!
    return Scaffold(
      appBar: AppBar(
        title: Text(product.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              height: 300,
              width: double.infinity,
              child: Image.network(
                product.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 10),
            Text(
              '\$${product.price}',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 20,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              width: double.infinity,
              child: Text(
                product.description,
                textAlign: TextAlign.center,
                softWrap: true,
              ),
            )
          ],
        ),
      ),
    );
  }
}