import 'package:flutter/material.dart';


class AddressDefault extends StatelessWidget{
  final String address;
  AddressDefault(this.address);
  @override
  Widget build(BuildContext context) {
    
    return Container(
            decoration: BoxDecoration(
                border: Border.all(color: Colors.greenAccent),
                borderRadius: BorderRadius.circular(10.0)),
            child: Text(address),
          );
  }
}