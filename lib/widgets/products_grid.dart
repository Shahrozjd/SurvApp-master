import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'category.dart';
import 'category_data.dart';
import '../providers/products.dart';
import 'product_item.dart';

class ProductsGrid extends StatelessWidget {
  // final bool showFavs;
  final bool idMatch;
  // static const routeName = '/products_grid';
  // ProductsGrid(this.showFavs,this.idMatch);
  ProductsGrid(this.idMatch);
  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    // final products = productsData.matchingItems;
    //  final products = idMatch ? productsData.matchingItems : productsData.items;
    final products = productsData.items;
    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      itemCount: products.length,
      itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
        // builder: (c) => products[i],
        value: products[i],
        child: ProductItem(
            //  products[i].id,
            // products[i].title,
            // products[i].imageUrl,
            ),
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
    );
  }
}
