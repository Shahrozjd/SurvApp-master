import 'package:flutter/foundation.dart';
import '../Widgets/category.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/http_exception.dart';

class Product with ChangeNotifier {
  final String id;
  final String ctId;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  final double reviews;
  final double experience;
  final String workingHours;
  final String number;
  final String email;
  bool isFavorite;
  double isRated;
  bool isMatching;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    // @required this.price,
    this.price,
    @required this.imageUrl,
    this.ctId,
    this.workingHours,
    this.experience,
    this.reviews,
    this.email,
    this.number,
    this.isFavorite = false,
    this.isMatching = false,
    this.isRated = 0,
  });
  void _setFavValue(double newValue) {
    isRated = newValue;
    notifyListeners();
  }

  void getcatId() {}
  void toggleMatchingStatus() {
    isMatching = !isMatching;
    notifyListeners();
  }

  void toggleFavoriteStatus() {
    isFavorite = !isFavorite;
    notifyListeners();
  }

  Future<void> toggleRatingStatus(String token, String userId,double val) async {
    final oldStatus = isRated;
    isRated = val;
    notifyListeners();
    final url =
        // 'https://flutter-update.firebaseio.com/services/$userId/$id.json?auth=$token';
        // https://surv-cc815-default-rtdb.firebaseio.com/services.json?auth=$authToken
        'https://surv-cc815-default-rtdb.firebaseio.com/services/$userId/$id.json?auth=$token';
    try {
      final response = await http.put(
        url,
        body: json.encode(
          isRated,
        ),
      );
      if (response.statusCode >= 400) {
        _setFavValue(oldStatus);
      }
    } catch (error) {
      _setFavValue(oldStatus);
    }
  }
}
