import 'package:flutter/material.dart';

class Product {
  final String id;
  final String title;
  final String description;
  final double price;
  final String image;
  final bool isfavorite;
  final String useremail;
  final String userid;
  Product(
      {
        @required this.id,
        @required this.description,
      @required this.image,
      @required this.price,
      @required this.title,
      @required this.useremail,
      @required this.userid,
      this.isfavorite=false,});
}
