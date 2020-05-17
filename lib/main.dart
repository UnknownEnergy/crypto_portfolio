import 'package:crypto_portfolio/widgets/userLoginWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Crypto Portfolio',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: UserLoginWidget(),
    );
  }
}
