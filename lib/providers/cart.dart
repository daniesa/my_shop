import 'dart:developer';

import 'package:flutter_complete_guide/providers/product.dart';
import 'package:flutter/foundation.dart';

class CartItem {
  final String id;
  final int quantity;
  final Product product;

  CartItem(
      {@required this.id,
      @required this.product,
      @required this.quantity});
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get count {
    return _items.length;
  }

  int quantityOfProduct(Product pd) {
    CartItem crt = _items.values.toList().firstWhere(
        (element) => element.id == pd.id,
        orElse: () =>
            new CartItem(id: '0', quantity: 0, product: pd));
    return crt.quantity;
  }

  double get totalPrice {
    double tot = 0;
    _items.forEach((key, value) {
      tot += value.quantity * value.product.price;
    });
    return tot;
  }

  void addItem(Product product) {
    if (_items.containsKey(product.id)) //quantity
    {
      _items.update(
        product.id,
        (existing) => CartItem(
            id: product.id,
            quantity: existing.quantity + 1, product: product),
      );
    } else {
      _items.putIfAbsent(
        product.id,
        () => CartItem(
            id: DateTime.now().toString(),
            quantity: 1,
            product: product),
      );
      notifyListeners();
    }
    notifyListeners();
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void undoAdding(Product pd) {
    if (!_items.containsKey(pd.id)) {
      return;
    } else if (_items[pd.id].quantity > 1) {
      _items.update(
          pd.id,
          (value) => CartItem(
              id: value.id,
              quantity: value.quantity - 1
              , product: pd));
      notifyListeners();
    } else {
      removeItem(pd.id);
      notifyListeners();
    }
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}
