import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import './Product_card.dart';
import '../../models/models.dart';
import '../../scoped-model/main.dart';

class Products extends StatelessWidget {
  Widget _buildproductlist(List<Product> products) {
    Widget productcard;
    if (products.length > 0) {
      productcard = ListView.builder(
        itemBuilder: (BuildContext context, int index) =>
            ProductCard(products[index], index),
        itemCount: products.length,
      );
    } else {
      productcard = Center(
        child: Text('No product on easy list  yet'),
      );
    }
    return productcard;
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        return RefreshIndicator(
            onRefresh: model.fetchProducts,
            child: _buildproductlist(model.displayedproducts));
      },
    );
  }
}
