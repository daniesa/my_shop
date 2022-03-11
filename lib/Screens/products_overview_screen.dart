import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/providers/cart.dart';
import 'package:flutter_complete_guide/providers/products_provider.dart';
import 'package:flutter_complete_guide/widget/badge.dart';
import 'package:flutter_complete_guide/widget/main_drawer.dart';
import 'package:flutter_complete_guide/widget/products_grid.dart';
import 'package:provider/provider.dart';
import '../Screens//cart_screen.dart';

enum FilterOptions { Favorites, All }

class ProductsOverviewScreen extends StatefulWidget {
  static const String routeName = '/ProductOverview';
  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  bool _showOnlyFavorites = false;
  bool _isLoading = false;
  bool _isInIt = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() async {
    if (!_isInIt) {
              _isLoading = true;
       await Provider.of<Products>(context).fetachAndSetProducts();
      setState(() {
          _isLoading = false;
        //Hack :   Future.delayed(Duration.zero).then for InIt
      });
    }
    _isInIt = true;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    var MQ = MediaQuery.of(context);
    return Scaffold(
      drawer: MyDrawerWidget(),
      appBar: AppBar(
        title: const Text('My Shop'),
        actions: [
          PopupMenuButton(
            itemBuilder: (_) {
              return [
                PopupMenuItem(
                    child: Text('Only Favorites'),
                    value: FilterOptions.Favorites),
                PopupMenuItem(child: Text('Show All'), value: FilterOptions.All)
              ];
            },
            icon: const Icon(Icons.more_vert),
            onSelected: (FilterOptions selectedValue) {
              setState(() {
                if (selectedValue == FilterOptions.All) {
                  _showOnlyFavorites = false;
                } else {
                  _showOnlyFavorites = true;
                }
              });
            },
          ),
          Badge(
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
            ),
            value: Provider.of<Cart>(context).count.toString(),
          )
        ],
      ),
      body: (_isLoading
          ? Center(child: CircularProgressIndicator())
          : ProductsGrid(MQ: MQ, showFavs: _showOnlyFavorites)),
    );
  }
}
