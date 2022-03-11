import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/Screens/addEdit_product_screen.dart';
import 'package:flutter_complete_guide/providers/products_provider.dart';
import 'package:flutter_complete_guide/widget/main_drawer.dart';
import 'package:flutter_complete_guide/widget/product_item_list.dart';
import 'package:provider/provider.dart';

class UserproductsScreen extends StatelessWidget {
  
  static final routeName = '/UserProducts';

  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<Products>(context, listen: false).fetachAndSetProducts();
  }
  @override
  Widget build(BuildContext context) {
    var productsData = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
          title: const Text(
            'Your Product',
          ),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(EditProductScreen.routeName);
              },
              icon: const Icon(Icons.add),
            ),
          ]),
      drawer: MyDrawerWidget(),
      body: RefreshIndicator(
        onRefresh: () => _refreshProducts(context),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListView.builder(
              itemCount: productsData.items.length,
              itemBuilder: (context, i) {
                return Column(
                  children: [
                    UserProductItem(product: productsData.items[i]),
                    Divider(),
                  ],
                );
              }),
        ),
      ),
    );
  }
}
