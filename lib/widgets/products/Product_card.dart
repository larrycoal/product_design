import 'package:flutter/material.dart';

import 'package:scoped_model/scoped_model.dart';

import './price_tag.dart';
import '../ui_element/title_default.dart';
import '../ui_element/address_default.dart';
import '../../models/models.dart';
import '../../scoped-model/main.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final int productIndex;
  ProductCard(this.product, this.productIndex);

  Widget buildTitlePrice() {
    return Container(
      margin: EdgeInsets.all(5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          TitleDefault(product.title),
          SizedBox(
            width: 8.0,
          ),
          PriceTag(product.price.toString())
        ],
      ),
    );
  }

  Widget buildActionButtons(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      return ButtonBar(children: <Widget>[
        IconButton(
            icon: Icon(
              Icons.info,
            ),
            color: Theme.of(context).accentColor,
            onPressed: () {
              Navigator.pushNamed<bool>(
                  context, '/product/' + model.allproducts[productIndex].id);
            }),
        SizedBox(
          width: 10.0,
        ),
        IconButton(
            icon: Icon(model.allproducts[productIndex].isfavorite
                ? Icons.favorite
                : Icons.favorite_border),
            color: Colors.red,
            onPressed: () {
              model.selectProduct(productIndex);
              model.togglefavoritebutton();
            })
      ]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Column(children: <Widget>[
      FadeInImage(
        image: NetworkImage(product.image),
        placeholder: AssetImage('assets/food.jpg'),
        height: 300.0,
        fit: BoxFit.cover,
      ),
      buildTitlePrice(),
      AddressDefault('Plot 4 Area 8 opic Estate'),
      Text(product.useremail),
      Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[buildActionButtons(context)])
    ]));
  }
}
