import 'package:flutter/cupertino.dart';
import 'package:flutter_complete_guide/providers/Order_item.dart';
import 'package:flutter_complete_guide/providers/products_provider.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:provider/provider.dart';

import 'cart.dart';
import 'product.dart';

class Orders with ChangeNotifier {
  final keyApplicationId = '3bhBZQDpP8jaFceAgFnuGEw3p2V9Xi8nwY0H9mFe';
  final keyClientKey = '1A2fpy3fEPRpDDy5FPW7iRh5JvXjZqI5B1IysuaN';
  final keyParseServerUrl = 'https://parseapi.back4app.com';
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> addOrder(
      List<CartItem> products, double total, BuildContext context) async {
    WidgetsFlutterBinding.ensureInitialized();
    await Parse().initialize(keyApplicationId, keyParseServerUrl,
        clientKey: keyClientKey, autoSendSessionId: true);

    var mainOrder = ParseObject('Orders')
      ..set("amount", total)
      ..set('dateTime', DateTime.now());
    ParseResponse pr1 = await mainOrder.save();
    if (pr1.success) {
      for (CartItem item in products) {
        var orderItems = ParseObject('OrderItems')
          ..set(
              'mainOrderID',
              (ParseObject('Orders')..objectId = mainOrder.objectId)
                  .toPointer())
          ..set('productID',
              (ParseObject('Products')..objectId = item.product.id).toPointer())
          ..set('quantity', item.quantity);
        ParseResponse pr2 = await orderItems.save();
      }

      var newOrder = new OrderItem(
          id: pr1.results[0]["objectId"],
          amount: total,
          products: products,
          dateTime: DateTime.now());
      _orders.insert(0, newOrder);
      Provider.of<Cart>(context, listen: false).clearCart();
      notifyListeners();
    }
  }

  //copied from products
  // Future<void> updateProduct(Product pd) async {
  //   final prodIndex = _items.indexWhere((prod) => prod.id == pd.id);
  //   if (prodIndex >= 0) {
  //     try {
  //       var product = ParseObject('Products')
  //         ..objectId = pd.id
  //         ..set('title', pd.title)
  //         ..set('description', pd.description)
  //         ..set('imageUrl', pd.imageUrl)
  //         ..set('price', pd.price);
  //       await product.save();

  //       // final url =
  //       //     "https://danfluttershop-default-rtdb.europe-west1.firebasedatabase.app/product/${pd.id}.json";
  //       // await http.patch(
  //       //   Uri.parse(url),
  //       //   body: jsonEncode({
  //       //     "title": pd.title,
  //       //     'description': pd.description,
  //       //     'imageUrl': pd.imageUrl,
  //       //     'price': pd.price,
  //       //   }),
  //       // );
  //       _items[prodIndex] = pd;
  //       notifyListeners();
  //     } catch (error) {}
  //   } else {
  //     print('Product Not Found');
  //   }
  // }

  // Future<void> deleteProduct(Product pd) async {
  //   try {
  //     var existingProduct = pd;
  //     final existingIndex = _items.indexOf(pd);
  //     _items.remove(pd);
  //     var todo = ParseObject('Products')..objectId = pd.id;
  //     var resp = await todo.delete();
  //     //   final url =
  //     //       "https://danfluttershop-default-rtdb.europe-west1.firebasedatabase.app/product/${pd.id}.json";
  //     //   http.delete(Uri.parse(url)).then((resp) {
  //     if (resp.statusCode >= 400) {
  //       _items.insert(existingIndex, existingProduct);
  //       throw HttpExceptions('Could not delete product.');
  //     } else
  //       existingProduct = null;

  //     notifyListeners();
  //   } catch (error) {}
  // }

  Future<void> fetachAndSetOrders(BuildContext context) async {
    WidgetsFlutterBinding.ensureInitialized();
    await Parse().initialize(keyApplicationId, keyParseServerUrl,
        clientKey: keyClientKey, autoSendSessionId: true);

    QueryBuilder<ParseObject> queryTodo =
        QueryBuilder<ParseObject>(ParseObject('Orders'));
    final ParseResponse apiResponse = await queryTodo.query();
    if (apiResponse.success && apiResponse.results != null) {
      apiResponse.results.forEach((order) async {
        QueryBuilder<ParseObject> getItems =
            QueryBuilder<ParseObject>(ParseObject('OrderItems'))
              ..whereContains("mainOrderID", order["objectId"]);
        final ParseResponse itemsResponse = await getItems.query();
        List<CartItem> ciList = [];
        itemsResponse.results.forEach((element) {
          
          Product selectedProduct =
              Provider.of<Products>(context, listen: false)
                  .findById(element["productID"]["objectId"]);
          CartItem ci = new CartItem(
              id: element["objectId"],
              product: selectedProduct,
              quantity: element["quantity"]);
          ciList.add(ci);
        });
        
        OrderItem newPD = OrderItem(
            id: order["objectId"],
            amount: order["amount"],
            products: ciList,
            dateTime: order["dateTime"]);
        if (!_orders.any((element) => element.id == newPD.id)) {
          _orders.add(newPD);
          notifyListeners();
        }
      });
    } else {}
  }
}
