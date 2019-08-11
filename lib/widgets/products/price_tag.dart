import 'package:flutter/material.dart';

class PriceTag extends StatelessWidget {
  final String price;
  PriceTag(this.price);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.0, vertical: 5.0),
      decoration: BoxDecoration(
          color: Theme.of(context).accentColor,
          borderRadius: BorderRadius.circular(7.0)),
      child: Text(
        '\$' + price.toString(),
        style: TextStyle(color: Colors.white, fontSize: 15.0),
      ),
    );
  }
}
