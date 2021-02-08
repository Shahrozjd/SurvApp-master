import 'package:flutter/material.dart';

class Category {
  final String catId;
  final String title;
  final String imageUrl;
  const Category({
    @required this.catId,
    @required this.title,
    @required this.imageUrl,
  });
}
