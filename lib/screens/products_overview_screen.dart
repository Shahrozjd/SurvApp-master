import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/category.dart';
import '../Widgets/category_data.dart';
import '../widgets/app_drawer.dart';
import '../widgets/products_grid.dart';
import '../widgets/badge.dart';
import '../providers/cart.dart';
import './cart_screen.dart';
import '../widgets/category_item.dart';
import '../providers/products.dart';

enum FilterOptions {
  Favorites,
  All,
}

bool get matchItem {}

class ProductsOverviewScreen extends StatefulWidget {
  static const routeName = '/products_overview_Screen';
  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  // var _showOnlyFavorites = false;
  var _idMatch = true;
  var _isInit = true;
  var _isloading = false;
  @override
  void initState() {
    //   Provider.of<Products>(context).fetchAndSetProducts();

    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
         _isloading = true;
      });
      Provider.of<Products>(context).fetchAndSetProducts().then((_) {
       
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final routeArgs =
        ModalRoute.of(context).settings.arguments as Map<String, String>;
    final categoryTitle = routeArgs['title'];
    final categoryId = routeArgs['id'];

    // final _productData = Provider.of<Products>(context);
    // final _products = _productData.items;

    // return Scaffold(

    // if (categoryId.compareTo(productId) == 0) {
    //   _idMatch = true;
    // }
    return Scaffold(
      appBar: AppBar(
        title: Text(categoryTitle),
        actions: <Widget>[
          // PopupMenuButton(
          // onSelected: (FilterOptions selectedValue) {
          //     setState(() {
          //   if (select == FilterOptions.Favorites) {
          //     _showOnlyFavorites = true;
          //   } else {
          //     _showOnlyFavorites = false;
          //   }
          // });
          //   },
          //   icon: Icon(
          //     Icons.more_vert,
          //   ),
          //   itemBuilder: (_) => [
          //     PopupMenuItem(
          //       child: Text('Only Favorites'),
          //       value: FilterOptions.Favorites,
          //     ),
          //     PopupMenuItem(
          //       child: Text('Show All'),
          //       value: FilterOptions.All,
          //     ),
          //   ],
          // ),
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
        ],
      ),
      drawer: AppDrawer(),
      // body: _isloading ? Center(
      //   child: CircularProgressIndicator(),
      // )
      // : 
      body:ProductsGrid(_idMatch),
    );
  }
}
