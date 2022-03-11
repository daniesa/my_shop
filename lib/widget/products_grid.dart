import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/providers/products_provider.dart';
import 'package:flutter_complete_guide/widget/product_item.dart';
import 'package:provider/provider.dart';

class ProductsGrid extends StatelessWidget {


  final MediaQueryData MQ;
  final bool showFavs;

  const ProductsGrid({Key key, this.MQ, this.showFavs}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final pdData = Provider.of<Products>(context);
    final loadedProducts = (showFavs? pdData.favItems: pdData.items);
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: (MQ.size.width > 700 ? 4 : 2),
          childAspectRatio: 3 / 3,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10),
      itemBuilder: (context, i) {
        return ChangeNotifierProvider.value(
          value: loadedProducts[i],
          child: ProductItem(),
        );
      },
      padding: const EdgeInsets.all(10.0),
      itemCount: loadedProducts.length,
    );
  }
}
