import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DashboardWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: DecoratedBox(
        // here is where I added my DecoratedBox
        decoration: BoxDecoration(color: Colors.lightBlueAccent),
        child: Text('Dashboard'),
      ),
    );
  }
}
