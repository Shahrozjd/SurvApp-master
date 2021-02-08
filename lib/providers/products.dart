import 'package:flutter/material.dart';
import '../widgets/category.dart';
import '../widgets/category_data.dart';
import './product.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:url_launcher/url_launcher.dart';
import '../screens/auth_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/http_exception.dart';

class Products with ChangeNotifier {
  List<Product> _items = [
    // Product(
    //   id: 'RF',
    //   title: 'Jack Roofing Services',
    //   description: 'Best Roofing in Town',
    //   price: 29.99,
    //   reviews: 0,
    //   experience: 15,
    //   workingHours: "Mon - Fri 09:00 - 17:00",
    //   imageUrl:
    //       'https://www.renownedbuildingsolutions.com/assets/img/blog/roof-repair.jpg',
    //   number: "469-400-5192",
    //   email: "rishijarral@gmail.com",
    // ),
    // Product(
    //   id: 'RF',
    //   title: 'Carlos Cleaning Service',
    //   description: 'Best Cleaning Service in Frisco',
    //   price: 59.99,
    //   reviews: 0,
    //   experience: 15,
    //   number: "469-400-5192",
    //   email: "rishijarral@gmail.com",
    //   imageUrl:
    //       'https://www.blockrenovation.com/guides/wp-content/uploads/2018/12/cleaning-service-1170x585.jpg',
    // ),
    // Product(
    //   id: 'HD',
    //   title: 'Jack Roofing Services',
    //   description: 'Best Roofing in Town',
    //   price: 19.99,
    //   reviews: 0,
    //   experience: 15,
    //   number: "469-400-5192",
    //   email: "rishijarral@gmail.com",
    //   imageUrl:
    //       'https://www.renownedbuildingsolutions.com/assets/img/blog/roof-repair.jpg',
    // ),
    // Product(
    //   id: 'EL',
    //   title: 'Carlos Cleaning Service',
    //   description: 'Best Cleaning Service in Frisco',
    //   price: 49.99,
    //   experience: 15,
    //   number: "469-400-5192",
    //   email: "rishijarral@gmail.com",
    //   reviews: 0,
    //   imageUrl:
    //       'https://www.blockrenovation.com/guides/wp-content/uploads/2018/12/cleaning-service-1170x585.jpg',
    // ),
  ];
  var _showMachingOnly = false;
  final String authToken;
  final String userId;

  Products(this.authToken, this.userId, this._items);

  List<Product> get items {
    // if (_showFavoritesOnly) {
    //   return _items.where((prodItem) => prodItem.isFavorite).toList();
    // }
    return [..._items];
  }

  List<Product> get favoriteItems {
    return _items.where((prodItem) => prodItem.isFavorite).toList();
  }

  List<Product> get matchigItems {
    return _items.where((prodItem) => prodItem.isMatching).toList();
  }
  // List<Product> get matchigItems (String id) {
  //   return _items.where((prodItem) => prod.id == id).toList();
  // }

  // Product catMatch(String id) {
  //    return _items.where((prod) => prod.id == id);
  // }
  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  // void showFavoritesOnly() {
  //   _showFavoritesOnly = true;
  //   notifyListeners();
  // }

  // void showAll() {
  //   _showFavoritesOnly = false;
  //   notifyListeners();
  // }
  Future<void> fetchAndSetProducts([bool filterByUser = false]) async {
    final filterString =
        filterByUser ? 'orderBy="creatorId"&equalTo="$userId"' : '';
    var url =
        'https://surv-cc815-default-rtdb.firebaseio.com/services.json?auth=$authToken&$filterString';
    final ratedResponse = await http.get(url);
    final ratedData = json.decode(ratedResponse.body);
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }
      final List<Product> loadedProducts = [];

      extractedData.forEach((prodId, prodData) {
        loadedProducts.add(Product(
            id: prodId,
            title: prodData['title'],
            description: prodData['description'],
            price: prodData['price'],
            number: prodData['number'],
            ctId: prodData['ctId'],
            imageUrl: prodData['imageUrl'],
            // isRated: ratedData == 0 ? ratedData[prodId] : ratedData[prodId] ,
            ));

      });
      // print(json.decode(response.body));
      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> addProduct(Product product) async {
    final url =
        'https://surv-cc815-default-rtdb.firebaseio.com/services.json?auth=$authToken';
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'title': product.title,
          'description': product.description,
          'imageUrl': product.imageUrl,
          'price': product.price,
          'number': product.number,
          'creatorId': userId,
        }),
      );
      final newProduct = Product(
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
        id: json.decode(response.body)['name'],
      );
      _items.add(newProduct);
      // _items.insert(0, newProduct); // at the start of the list
      notifyListeners();
    } catch (error) {
      print(error);
      throw (error);
    }
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      final url =
          'https://surv-cc815-default-rtdb.firebaseio.com/services/$id.json?auth=$authToken';
      await http.patch(url,
          body: json.encode({
            'title': newProduct.title,
            'description': newProduct.description,
            'imageUrl': newProduct.imageUrl,
            'price': newProduct.price,
            'number': newProduct.number,
            'catId': newProduct.ctId,
          }));
      _items[prodIndex] = newProduct;
      notifyListeners();
    } else {
      print('...');
    }
  }

  Future<void> deleteProduct(String id) async {
    final url =
        'https://surv-cc815-default-rtdb.firebaseio.com/services/$id.json?auth=$authToken';
    final existingProductIndex = _items.indexWhere((prod) => prod.id == id);
    var existingProduct = _items[existingProductIndex];
    _items.removeAt(existingProductIndex);
    notifyListeners();
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException('Could not delete product.');
    }
    existingProduct = null;
  }
}
