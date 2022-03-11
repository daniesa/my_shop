import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/Screens/order_screen.dart';
import 'package:flutter_complete_guide/Screens/products_overview_screen.dart';
import 'package:flutter_complete_guide/Screens/user_product_screen.dart';

class MyDrawerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          _createHeader(),
      _createDrawerItem(icon: Icons.grid_view_rounded,text:"My Shop",onTap: (){
        Navigator.of(context).pushNamed(ProductsOverviewScreen.routeName);
      }),
      _createDrawerItem(icon: Icons.attach_money_rounded,text:"Orders",onTap: (){
        Navigator.of(context).pushNamed(OrdersScreen.routeName);
      }),
            _createDrawerItem(icon: Icons.view_list,text:"Products",onTap: (){
        Navigator.of(context).pushNamed(UserproductsScreen.routeName);
      }),
        ],
      ),
    );
  }

  Widget _createHeader() {
    return DrawerHeader(
      margin: EdgeInsets.zero,
      padding: EdgeInsets.zero,
      child: Stack(
        children: <Widget>[
          Positioned(
            bottom: 12.0,
            left: 16.0,
            child: Text(
              "My Shop!",
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  Widget _createDrawerItem(
    {IconData icon, String text, Function onTap}) {
  return ListTile(
    title: Row(
      children: <Widget>[
        Icon(icon),
        Padding(
          padding: EdgeInsets.only(left: 8.0),
          child: Text(text),
        )
      ],
    ),
    onTap: onTap,
  );
}
}
