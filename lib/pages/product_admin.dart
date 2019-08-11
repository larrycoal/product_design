import 'package:flutter/material.dart';

import '../scoped-model/main.dart';

import './product_edit.dart';
import './product_list.dart';
import '../widgets/ui_element/logout.dart';

class ManageProduct extends StatelessWidget {
  final MainModel model;

  ManageProduct(this.model);
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          drawer: Drawer(
            child: (Column(
              children: <Widget>[
                AppBar(
                  automaticallyImplyLeading: false,
                  title: (Text('CHOOSE')),
                ),
                ListTile(
                    leading: Icon(Icons.shop),
                    title: (Text('all products')),
                    onTap: () {
                      Navigator.pushReplacementNamed(context, '/Ppage');
                    }),
                Divider(
                  height: 10,
                ),
                Logout(),
              ],
            )),
          ),
          appBar: AppBar(
            title: Text('Manage product'),
            bottom: TabBar(
              tabs: <Widget>[
                Tab(icon: Icon(Icons.create), text: 'create product'),
                Tab(
                  icon: Icon(Icons.list),
                  text: 'product list',
                )
              ],
            ),
          ),
          body: TabBarView(
            children: <Widget>[
              EditProduct(),
              ProductList(model),
            ],
          )),
    );
  }
}
