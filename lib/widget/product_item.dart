import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/providers/cart.dart';
import 'package:flutter_complete_guide/providers/product.dart';
import 'package:provider/provider.dart';
import 'package:flutter_complete_guide/Screens/product_detail_screen.dart';

import 'badge.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context);
    final cart = Provider.of<Cart>(context);
    return ClipRRect(
      borderRadius: BorderRadius.circular(
        10,
      ),
      child: GridTile(
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            child: Image.network(
              product.imageUrl,
              fit: BoxFit.cover,
            ),
            onTap: () {
              Navigator.of(context)
                  .pushNamed(ProductDetailScreen.routeName, arguments: product);
            },
          ),
        ),
        footer: GridTileBar(
            title: Center(
              child: Text(
                product.title,
                textAlign: TextAlign.center,
              ),
            ),
            backgroundColor: Colors.black87,
            subtitle: Center(
              child: Text(
                product.price.toString(),
                textAlign: TextAlign.center,
              ),
            ),
            leading: IconButton(
              icon: Icon((product.isFavorite
                  ? Icons.favorite
                  : Icons.favorite_border)),
              onPressed:() => () async { 
                 product.toggleFavorite();
                },
              color: Theme.of(context).secondaryHeaderColor,
            ),
            trailing: Badge(
              child: IconButton(
                icon: Icon(
                  Icons.shopping_cart,
                ),
                onPressed: () {
                  cart.addItem(product);
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    duration: const Duration(
                      milliseconds: 700,
                    ),
                    action: SnackBarAction(label: 'Undo', onPressed:() => cart.undoAdding(product)),
                    elevation: 10,
                    content: Row(
                      children: [
                        Icon(
                          Icons.add_shopping_cart,
                          color: Theme.of(context).secondaryHeaderColor,
                        ),
                        Text(
                            ' ${product.title} added to cart.'),
                      ],
                    ),
                  ));
                },
                color: Theme.of(context).secondaryHeaderColor,
              ),
              value: cart.quantityOfProduct(product).toString(),
              color: Colors.lime,
            )),
      ),
    );
  }
}
