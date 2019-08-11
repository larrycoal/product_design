import 'package:flutter/material.dart';

import '../widgets/ui_element/title_default.dart';
import '../widgets/ui_element/address_default.dart';

import '../models/models.dart';

class ProductPage extends StatelessWidget {
  final Product products;

  ProductPage(this.products);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(products.title)),
      body: Column(
        children: <Widget>[
          Image.asset(products.image),
          SizedBox(
            height: 10.0,
          ),
          TitleDefault(products.title),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                AddressDefault('Plot 4 Area 8 opic Estate'),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 5.0),
                  child: Text(
                    '|',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                Text(
                  '\$' + products.price.toString(),
                  style: TextStyle(
                      color: Colors.grey,
                      fontFamily: 'Oswald',
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 5.0),
            child: Text(products.description,
                style: TextStyle(
                    color: Colors.grey,
                    fontFamily: 'Oswald',
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0)),
          )
        ],
      ),
    );
  }
}
