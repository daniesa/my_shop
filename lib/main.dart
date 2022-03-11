import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/Screens/AddEdit_product_screen.dart';
import 'package:flutter_complete_guide/Screens/cart_screen.dart';
import 'package:flutter_complete_guide/Screens/order_screen.dart';
import 'package:flutter_complete_guide/Screens/products_overview_screen.dart';
import 'package:flutter_complete_guide/Screens/userLogIn_screen.dart';
import 'package:flutter_complete_guide/Screens/userRegister_screen.dart';
import 'package:flutter_complete_guide/Screens/user_product_screen.dart';
import 'package:flutter_complete_guide/providers/auth.dart';
import 'package:flutter_complete_guide/providers/cart.dart';
import './Screens/product_detail_screen.dart';
import './providers/products_provider.dart';
import 'package:provider/provider.dart';

import 'providers/orders.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Products(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Cart(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Orders(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Auth(),
        )
      ],
      child: MaterialApp(
        title: 'MyShop',
        theme: ThemeData(
          fontFamily: 'Lato', colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blueGrey).copyWith(secondary: Colors.yellow),
        ),
        debugShowCheckedModeBanner: false,
        home: ProductsOverviewScreen(),
        routes: {
          ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
          ProductsOverviewScreen.routeName: (ctx) => ProductsOverviewScreen(),
          CartScreen.routeName: (ctx) => CartScreen(),
          OrdersScreen.routeName: (ctx) => OrdersScreen(),
          UserproductsScreen.routeName: (ctx) => UserproductsScreen(),
          EditProductScreen.routeName: (ctx) => EditProductScreen(),
        },
      ),
    );
  }
}
