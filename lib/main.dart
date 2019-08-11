import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import './pages/Products.dart';
import './pages/Product_admin.dart';
import './pages/Product.dart';
import './pages/auth.dart';
import './scoped-model/main.dart';
import './models/models.dart';

main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  final MainModel _model = MainModel();
  @override
  void initState() {
    _model.autoauthenticate();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel(
      model: _model,
      child: MaterialApp(
          theme: ThemeData(
              primarySwatch: Colors.deepOrange,
              accentColor: Colors.deepPurple,
              fontFamily: 'Oswald',
              brightness: Brightness.light),
         // home: _model.user == null ? AuthPage() : ProductsPage(_model),
          routes: {
            '/' : (BuildContext context) =>  _model.user == null ? AuthPage() : ProductsPage(_model),
            '/Ppage': (BuildContext context) => ProductsPage(_model),
            '/admin': (BuildContext context) => ManageProduct(_model),
          },
          onGenerateRoute: (RouteSettings settings) {
            final List<String> pathElements = settings.name.split('/');
            if (pathElements[0] != '') {
              return null;
            }
            if (pathElements[1] == 'product') {
              String productId = pathElements[2];
              final Product products =
                  _model.allproducts.firstWhere((Product products) {
                return products.id == productId;
              });

              return MaterialPageRoute<bool>(
                builder: (BuildContext context) => ProductPage(products),
              );
            }
            return null;
          },
          onUnknownRoute: (RouteSettings settings) {
            return MaterialPageRoute(
              builder: (BuildContext context) => ProductsPage(_model),
            );
          }),
    );
  }
}
