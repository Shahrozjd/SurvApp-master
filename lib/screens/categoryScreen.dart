import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/category_data.dart';
import '../widgets/category_item.dart';
import '../widgets/app_drawer.dart';
import '../widgets/badge.dart';
import '../providers/cart.dart';
import './cart_screen.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class CategoriesScreen extends StatelessWidget {
  static const routeName = '/categoryScreen';
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
      appBar: AppBar(title: const Text('Home'), actions: <Widget>[
        Consumer<Cart>(
          builder: (_, cart, ch) => Badge(
            child: ch,
            value: cart.itemCount.toString(),
          ),
          child: IconButton(
            icon: Icon(
              Icons.shopping_cart,
            ),
            onPressed: () {
              Navigator.of(context).pushNamed(CartScreen.routeName);
            },
          ),
        ),
      ]),
      drawer: AppDrawer(),
      body: GridView(
        padding: const EdgeInsets.all(5),
        children: CAT_DATA
            .map(
              (catData) =>
                  CategoryItem(catData.catId, catData.title, catData.imageUrl),
            )
            .toList(),
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 200,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
      ),
    );
  }
}
