import './screens/categoryScreen.dart';
import './screens/calendar.dart';
import './screens/auth_screen.dart';
import './screens/categoryScreen.dart';

import './screens/auth_screen.dart';
import 'package:flutter/material.dart';
import './screens/auth_screen.dart';
import './screens/detailScreen.dart';
import 'package:provider/provider.dart';
import 'screens/categoryScreen.dart';
import './screens/cart_screen.dart';
import './screens/products_overview_screen.dart';
import './screens/product_detail_screen.dart';
import './providers/products.dart';
import './providers/cart.dart';
import './providers/orders.dart';
import './screens/orders_screen.dart';
import './screens/user_products_screen.dart';
import './screens/edit_product_screen.dart';
import 'widgets/products_grid.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import './providers/auth.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    

    return MultiProvider(
      providers: [
         ChangeNotifierProvider.value(
          value: Auth(),
        ),
        // ChangeNotifierProvider.value(
        //   value: Products(),
        // ),
        ChangeNotifierProvider.value(
          value: Cart(),
        ),
        // ChangeNotifierProvider.value(
        //   value: Orders(),
        // ),
         ChangeNotifierProxyProvider<Auth, Products>(
          update: (ctx, auth, previousProducts) => Products(
                auth.token,
                auth.userId,
                previousProducts == null ? [] : previousProducts.items,
              ),
        ),
        
      ],
      child: Consumer<Auth>(
       builder: (ctx, auth, _) => MaterialApp(
          title: 'Surv',
          theme: ThemeData(
              primaryColor: Colors.black,
              accentColor: Color(0xFFFB8C00),
              fontFamily: 'Raleway',
              textTheme: ThemeData.light().textTheme.copyWith(
                      // body1: TextStyle(
                      //   color: Color.fromRGBO(20, 51, 51, 1),
                      // ),
                      title: TextStyle(
                    fontSize: 20.0,
                    fontFamily: 'RobotoCondensed',
                    fontWeight: FontWeight.bold,
                  ))),
          
          home: auth.isAuth ? CategoriesScreen() : AuthScreen(),
          localizationsDelegates: [
            GlobalWidgetsLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: [
            Locale('en', 'US')
          ],
          routes: {
            ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
            CartScreen.routeName: (ctx) => CartScreen(),
            OrdersScreen.routeName: (ctx) => OrdersScreen(),
            UserProductsScreen.routeName: (ctx) => UserProductsScreen(),
            EditProductScreen.routeName: (ctx) => EditProductScreen(),
            ProductsOverviewScreen.routeName: (ctx) => ProductsOverviewScreen(),
            CategoriesScreen.routeName: (ctx) => CategoriesScreen(),
            DetailsScreen.routeName: (ctx) => DetailsScreen(),
            Calendar.routeName: (ctx) => Calendar(),
          })
      ),
    );
  }
}
