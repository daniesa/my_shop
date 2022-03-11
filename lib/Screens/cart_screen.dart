import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/providers/orders.dart';
import 'package:flutter_complete_guide/widget/cart_item.dart';
import 'package:provider/provider.dart';
import 'package:flutter_complete_guide/widget/cart_item.dart';
import 'package:flutter_complete_guide/providers/cart.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title:const Text('Your Cart'),
      ),
      body: Column(
        children: <Widget>[
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Total',
                    style: TextStyle(fontSize: 20),
                  ),
                  Spacer(),
                  Chip(
                    label: Text(
                      '\$${cart.totalPrice}',
                      style: TextStyle(
                        color:
                            Theme.of(context).primaryTextTheme.headline6.color,
                      ),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  SizedBox(width: 10),
                  TextButton(
                    child: Text('ORDER NOW'),
                    onPressed: () {
                      var orderProvider = Provider.of<Orders>(context,listen:false);
                      orderProvider.addOrder(cart.items.values.toList(), cart.totalPrice, context);
                      print(orderProvider.orders.toString());
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    duration: const Duration(
                      milliseconds: 1500,
                    ),
                    elevation: 10,
                    content: Row(
                      children: [
                        Icon(
                          Icons.add_shopping_cart,
                          color: Theme.of(context).accentColor,
                        ),
                        const Text(
                            'Thanks for your shopping!'),
                      ],
                    ),
                  ));
                      cart.clearCart();
                    },
                  )
                ],
              ),
            ),
          ),
          SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: cart.items.length,
              itemBuilder: (ctx, i) => CartItemWidget(
                cart.items.values.toList()[i].id,
                cart.items.keys.toList()[i],
                cart.items.values.toList()[i].product.price,
                cart.items.values.toList()[i].quantity,
                cart.items.values.toList()[i].product.title,
              ),
            ),
          )
        ],
      ),
    );
  }
}
