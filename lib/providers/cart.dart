import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CartItem {
  final String id;
  final String title;
  final int quantity;
  final double price;

  CartItem({
    @required this.id,
    @required this.title,
    @required this.quantity,
    @required this.price,
  });
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  // simply returns the amount of different items
  int get itemCount {
    return _items.length;
  }

  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, val) {
      total += val.price * val.quantity;
    });
    return total;
  }

  void addItem(String productId, double price, String title) {
    if (_items.containsKey(productId)) {
      _items.update(
        productId,
        (existing) => CartItem(
            id: existing.id,
            title: existing.title,
            price: existing.price,
            quantity: existing.quantity + 1),
      );
    } else {
      _items.putIfAbsent(
        productId,
        () => CartItem(
          id: DateTime.now().toString(),
          title: title,
          price: 30,
          quantity: 1,
        ),
      );
    }

    notifyListeners();
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void removeSingleItem(String productId) {
    // quantity is 0 || doesnt exist
    if (!_items.containsKey(productId)) {
      return;
    }
    // quantity greater than 1
    if (_items[productId].quantity > 1) {
      _items.update(
          productId,
          (existingCartIem) => CartItem(
                id: existingCartIem.id,
                title: existingCartIem.title,
                price: existingCartIem.price,
                quantity: existingCartIem.quantity - 1,
              ));
    }
    // quantity is exactly 1 item
    else {
      _items.remove(productId);
    }
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}
