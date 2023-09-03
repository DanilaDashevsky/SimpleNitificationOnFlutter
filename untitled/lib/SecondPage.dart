


import 'package:flutter/material.dart';

class SecondPage extends StatefulWidget {
  late final String? payload;
  SecondPage({this.payload, super.key});

  @override
  State<SecondPage> createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea( child: Center(child: Container(child: Text('Yes< It is working'),),),
    ));
  }
}
