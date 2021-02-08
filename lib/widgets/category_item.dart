import 'package:flutter/material.dart';

import '../screens/products_overview_screen.dart';

import 'category.dart';

class CategoryItem extends StatelessWidget {
  final String title;
  final String catId;
  final String imageUrl;
  CategoryItem(this.catId, this.title, this.imageUrl);
  void selectCategory(BuildContext ctx) {
    Navigator.of(ctx).pushNamed(
      ProductsOverviewScreen.routeName,
      arguments: {
        'id': catId,
        'title': title,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: GridTile(
            child: GestureDetector(
              onTap: () => selectCategory(context),
              // child: Text(
              //   title,
              //   style: Theme.of(context).textTheme.title,
              // ),

              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
              ),
            ),
            header: GridTileBar(
              backgroundColor: Colors.black54.withOpacity(0.5),
              title: Text(
                title,
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )));
  }
}
