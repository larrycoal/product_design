import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../models/models.dart';
import '../scoped-model/main.dart';

class EditProduct extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _EditProduct();
  }
}

class _EditProduct extends State<EditProduct> {
  final Map<String, dynamic> _formdata = {
    'title': null,
    'description': null,
    'price': null,
    'image': 'assets/food.jpg'
  };
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  Widget _buildtitletextfield(Product products) {
    return Center(
        child: TextFormField(
      decoration: InputDecoration(labelText: 'PRODUCT NAME'),
      initialValue: products == null ? '' : products.title,
      validator: (String value) {
        if (value.isEmpty || value.length < 5) {
          return 'title cannot be empty and must be greater than 5';
        }
      },
      onSaved: (String value) {
        _formdata['title'] = value;
      },
    ));
  }

  Widget _builddescriptiontextfield(Product products) {
    return TextFormField(
      decoration: InputDecoration(labelText: 'PRODUCT DESCRIPTION'),
      initialValue: products == null ? '' : products.description,
      validator: (String value) {
        if (value.isEmpty || value.length < 5) {
          return 'description cannot be empty and must be greater than 5';
        }
      },
      maxLines: 4,
      onSaved: (String value) {
        _formdata['description'] = value;
      },
    );
  }

  Widget _buildpricetextfield(Product products) {
    return TextFormField(
        decoration: InputDecoration(labelText: 'PRODUCT PRICE'),
        initialValue: products == null ? '' : products.price.toString(),
        validator: (String value) {
          if (value.isEmpty ||
              !RegExp(r'^(?:[1-9]\d*|0)?(?:\.\d+)?$').hasMatch(value)) {
            return 'price has to be a number';
          }
        },
        keyboardType: TextInputType.number,
        onSaved: (String value) {
          _formdata['price'] = double.parse(value);
        });
  }

  Widget _buildsubmitformbutton() {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        return RaisedButton(
            color: Theme.of(context).accentColor,
            textColor: Colors.white,
            child: Text('save'),
            onPressed: () => _submitform(model.addproduct, model.updateproduct,
                model.selectProduct, model.selectedProductIndex));
      },
    );
  }

  Widget _buildpagecontent(BuildContext context, Product products) {
    final double devicewidth = MediaQuery.of(context).size.width;
    final double targetwidth = devicewidth > 550.0 ? 500.0 : devicewidth * 0.95;
    final double targetpadding = devicewidth - targetwidth;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Container(
        margin: EdgeInsets.all(10.0),
        child: Form(
          key: _formkey,
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: targetpadding / 2),
            children: <Widget>[
              _buildtitletextfield(products),
              _builddescriptiontextfield(products),
              _buildpricetextfield(products),
              SizedBox(
                height: 10.0,
              ),
              _buildsubmitformbutton()
            ],
          ),
        ),
      ),
    );
  }

  void _submitform(
      Function addproduct, Function updateproduct, Function setselectedproduct,
      [int selectedProductIndex]) {
    if (!_formkey.currentState.validate()) {
      return;
    }
    _formkey.currentState.save();
    {
      if (selectedProductIndex == -1) {
        addproduct(
          _formdata['title'],
          _formdata['description'],
          _formdata['price'],
          _formdata['image'],
        ).then((bool success) {
          if (success) {
            Navigator.pushReplacementNamed(context, '/Ppage')
                .then((_) => setselectedproduct(null));
          } else {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  AlertDialog(
                    content: Text('Something went Wrong'),
                    actions: <Widget>[
                      FlatButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text('okay'),
                      )
                    ],
                  );
                });
          }
        });
      } else
        updateproduct(
          _formdata['title'],
          _formdata['description'],
          _formdata['price'],
          _formdata['image'],
        ).then((_) => Navigator.pushReplacementNamed(context, '/Ppage')
            .then((_) => setselectedproduct(null)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        final Widget pageContent =
            _buildpagecontent(context, model.selectedProduct);
        return model.selectedProductIndex == -1
            ? pageContent
            : Scaffold(
                appBar: AppBar(
                  title: (Text('EDIT PAGE')),
                ),
                body: pageContent,
              );
      },
    );
  }
}
