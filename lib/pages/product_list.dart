import 'package:flutter/material.dart';

import 'package:scoped_model/scoped_model.dart';

import './product_edit.dart';

import '../scoped-model/main.dart';

class ProductList extends StatefulWidget {
  final MainModel model;

  ProductList(this.model);
  @override
  State<StatefulWidget> createState() {
    return _ProductList();
  }
}

class _ProductList extends State<ProductList> {
  @override
    initState() {
      widget.model.fetchProducts();
      super.initState();
    }
  Widget _buildiconbutton(BuildContext context, int index, MainModel model) {
    return IconButton(
      icon: Icon(Icons.edit),
      onPressed: () {
        model.selectProduct(model.allproducts[index].id);
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) {
              return EditProduct();
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      return ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          return Dismissible(
            key: Key(
              model.allproducts[index].title,
            ),
            background: Container(
              color: Colors.red,
            ),
            onDismissed: (DismissDirection direction) {
              if (direction == DismissDirection.endToStart)
                model.selectProduct(model.allproducts[index].id);
              model.deleteproduct();
              
            },
            child: Column(
              children: <Widget>[
                ListTile(
                    leading: CircleAvatar(
                      backgroundImage:
                          AssetImage(model.allproducts[index].image),
                    ),
                    title: Text(model.allproducts[index].title),
                    subtitle:
                        Text('\$${model.allproducts[index].price.toString()}'),
                    trailing: _buildiconbutton(context, index, model)),
                Divider()
              ],
            ),
          );
        },
        itemCount: model.allproducts.length,
      );
    });
  }
}
