import 'dart:convert';

import '../models/http_exception.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import './product.dart';

class ProductsProvider with ChangeNotifier {
  final String authToken;

  List<Product> _items = [];

  ProductsProvider(this.authToken, this._items);

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favoriteItems {
    return _items.where((prodItem) => prodItem.isFavorite == true).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  Future<void> fetchAndSetProducts() async {
    final url = Uri.parse(
        'https://fluttershop-9a023-default-rtdb.firebaseio.com/products.json?auth$authToken');
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<Product> loadedProducts = [];
      if (extractedData == null) {
        return;
      }
      extractedData.forEach((prodId, prodData) {
        loadedProducts.add(Product(
          id: prodId,
          title: prodData['title'],
          price: prodData['price'].toDouble(),
          description: prodData['description'],
          imageUrl: prodData['imageUrl'],
          isFavorite: prodData['isFavorite'],
        ));
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> addProduct(Product product) async {
    // final url =
    //     'https://fluttershop-9a023-default-rtdb.firebaseio.com/products.json';
    final url = Uri.parse(
        'https://fluttershop-9a023-default-rtdb.firebaseio.com/products.json');
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'title': product.title,
            'description': product.description,
            'imageUrl': product.imageUrl,
            'price': product.price,
            'isFavorite': product.isFavorite,
          },
        ),
      );
      final newProduct = Product(
        id: json.decode(response.body)['name'],
        title: product.title,
        price: product.price,
        description: product.description,
        imageUrl: product.imageUrl,
      );
      // _items.add(newProduct);
      _items.insert(0, newProduct);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final itemUrl = Uri.parse(
        'https://fluttershop-9a023-default-rtdb.firebaseio.com/products/$id.json');
    await http.patch(itemUrl,
        body: json.encode({
          'title': newProduct.title,
          'description': newProduct.description,
          'imageUrl': newProduct.imageUrl,
          'price': newProduct.price,
        }));
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    _items[prodIndex] = newProduct;
    notifyListeners();
  }

  Future<void> deleteProduct(String id) async {
    final url = Uri.parse(
        'https://fluttershop-9a023-default-rtdb.firebaseio.com/products/$id.json');
    final existingProductIndex = _items.indexWhere((prod) => prod.id == id);
    var existingProduct = _items[existingProductIndex];
    _items.removeAt(existingProductIndex);
    notifyListeners();
    // we are only removing it from the list, not the memory so if it fails we can bring it back
    try {
      final response = await http.delete(url);
      if (response.statusCode >= 400) {
        _items.insert(existingProductIndex, existingProduct);
        notifyListeners();
        throw HttpException('Could Not Delet Product');
      }
    } catch (error) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException('Could Not Delet Product');
    }
    existingProduct = null;
    // .then((response) {
    //   print(response.statusCode);

    //   existingProduct = null;
    //   notifyListeners();
    // }).catchError((error) {
    //   // if an error occurred rollback
    //   _items.insert(existingProductIndex, existingProduct);
    //   notifyListeners();
    // });
    // _items.removeAt(existingProductIndex);
    // notifyListeners();
  }
}
