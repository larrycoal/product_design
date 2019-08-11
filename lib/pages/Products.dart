import 'package:flutter/material.dart';

import 'package:scoped_model/scoped_model.dart';

import '../widgets/products/products.dart';
import '../scoped-model/main.dart';
import '../widgets/ui_element/logout.dart';

class ProductsPage extends StatefulWidget {
  final MainModel model;
  ProductsPage(this.model);
  @override
  State<StatefulWidget> createState() {
    return _ProductsPage();
  }
}

class _ProductsPage extends State<ProductsPage> {
  @override
  initState() {
    widget.model.fetchProducts();
    super.initState();
  }

  Widget _buildproduct() {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, Model model) {
        Widget content = Center(
          child: Text('No porducts Found'),
        );

        if (widget.model.displayedproducts.length > 0 &&
            !widget.model.isloading) {
          content = Products();
        } else if (widget.model.isloading){
          content= Center(child: CircularProgressIndicator(),);
        }
        return content;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: Drawer(
          child: Column(
            children: <Widget>[
              AppBar(
                automaticallyImplyLeading: false,
                title: Text('Choose'),
              ),
              ListTile(
                leading: Icon(Icons.create),
                title: Text('manage products'),
                onTap: () {
                  Navigator.pushReplacementNamed(context, '/admin');
                },
              ),
              Divider(height: 10,),
              Logout(),


            ],
          ),
        ),
        appBar: AppBar(
          title: Text('Easylist'),
          actions: <Widget>[
            ScopedModelDescendant<MainModel>(
              builder: (BuildContext context, Widget child, MainModel model) {
                return IconButton(
                  icon: Icon(model.showfavorite
                      ? Icons.favorite
                      : Icons.favorite_border),
                  onPressed: () {
                    model.togglefavorite();
                  },
                );
              },
            )
          ],
        ),
        body: _buildproduct());
  }
}
