import 'package:flutter/material.dart';

class User {
  final String id;
  final String email;
  final String token;
  User(
      {this.id,
      @required this.email,
      @required this.token});
}
