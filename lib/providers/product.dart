import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product(
      {@required this.id,
      @required this.title,
      @required this.description,
      @required this.price,
      @required this.imageUrl,
      this.isFavorite = false});

  Future<void> toggleFavorite() async {
    try {
      var product = ParseObject('Products')
        ..objectId = this.id
        ..set('isFavorie', (isFavorite ? 'False' : 'True'));
      ParseResponse t = await product.save();
      if (t.statusCode > 400) {
        print('error');
      } else {
        isFavorite = !isFavorite;
        print(isFavorite.toString());
        notifyListeners();
      }
    } catch (error) {}
  }
}
