import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_complete_guide/models/httpExceptionClass.dart';
import 'package:flutter_complete_guide/providers/product.dart';
import 'package:http/http.dart' as http;
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';

class Products with ChangeNotifier {
  final keyApplicationId = '3bhBZQDpP8jaFceAgFnuGEw3p2V9Xi8nwY0H9mFe';
  final keyClientKey = '1A2fpy3fEPRpDDy5FPW7iRh5JvXjZqI5B1IysuaN';
  final keyParseServerUrl = 'https://parseapi.back4app.com';
  List<Product> _items = [];
  List<Product> get items {
    return [..._items];
  }

  List<Product> get favItems {
    return [..._items.where((element) => element.isFavorite).toList()];
  }

  Future<void> addProduct(Product product) async {
    WidgetsFlutterBinding.ensureInitialized();
    await Parse().initialize(keyApplicationId, keyParseServerUrl,
        clientKey: keyClientKey, autoSendSessionId: true);

    var firstObject = ParseObject('Products')
      ..set("title", product.title)
      ..set('description', product.description)
      ..set('imageUrl', product.imageUrl)
      ..set('price', product.price)
      ..set('isFavorie', product.isFavorite);
    ParseResponse pr = await firstObject.save();
    if (pr.success) {
      final newProduct = new Product(
          id: pr.results[0]["objectId"],
          title: product.title,
          description: product.description,
          price: product.price,
          imageUrl: product.imageUrl);
      _items.add(newProduct);
      print(newProduct.id);
      notifyListeners();
    } else {
      throw pr.error;
    }
  }

  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  Future<void> updateProduct(Product pd) async {
    final prodIndex = _items.indexWhere((prod) => prod.id == pd.id);
    if (prodIndex >= 0) {
      try {
        var product = ParseObject('Products')
          ..objectId = pd.id
          ..set('title', pd.title)
          ..set('description', pd.description)
          ..set('imageUrl', pd.imageUrl)
          ..set('price', pd.price);
        await product.save();

        // final url =
        //     "https://danfluttershop-default-rtdb.europe-west1.firebasedatabase.app/product/${pd.id}.json";
        // await http.patch(
        //   Uri.parse(url),
        //   body: jsonEncode({
        //     "title": pd.title,
        //     'description': pd.description,
        //     'imageUrl': pd.imageUrl,
        //     'price': pd.price,
        //   }),
        // );
        _items[prodIndex] = pd;
        notifyListeners();
      } catch (error) {}
    } else {
      print('Product Not Found');
    }
  }

  Future<void> deleteProduct(Product pd) async {
    try {
      var existingProduct = pd;
      final existingIndex = _items.indexOf(pd);
      _items.remove(pd);
      var todo = ParseObject('Products')..objectId = pd.id;
      var resp = await todo.delete();
      //   final url =
      //       "https://danfluttershop-default-rtdb.europe-west1.firebasedatabase.app/product/${pd.id}.json";
      //   http.delete(Uri.parse(url)).then((resp) {
      if (resp.statusCode >= 400) {
        _items.insert(existingIndex, existingProduct);
        throw HttpExceptions('Could not delete product.');
      } else
        existingProduct = null;

      notifyListeners();
    } catch (error) {}
  }

  Future<void> fetachAndSetProducts() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Parse().initialize(keyApplicationId, keyParseServerUrl,
        clientKey: keyClientKey, autoSendSessionId: true);

    QueryBuilder<ParseObject> queryTodo =
        QueryBuilder<ParseObject>(ParseObject('Products'));
    final ParseResponse apiResponse = await queryTodo.query();
    if (apiResponse.success && apiResponse.results != null) {
      //print(apiResponse.results);
      apiResponse.results.forEach((product) {
        Product newPD = Product(
            id: product["objectId"],
            title: product["title"],
            description: product["description"],
            price: product["price"],
            imageUrl: product["imageUrl"]);
        if (!_items.any((element) => element.id == newPD.id)) {
          _items.add(newPD);
          notifyListeners();
        }
      });
    } else {}
  }
}
