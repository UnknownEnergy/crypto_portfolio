import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:crypto_portfolio/widgets/userWidget.dart';
import 'package:crypto_portfolio/widgets/moderatorWidget.dart';

class HomeWidget extends StatefulWidget {
  HomeWidget({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _HomeWidgetState createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: new Container(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new RaisedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CallUserWidget()),
                );
              },
              child: Text('User'),
            ),
            new RaisedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CallModeratorWidget()),
                );
              },
              child: Text('Moderator'),
            ),
          ],
        ),
      ),
    );
  }
}

class CallUserWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("User Widget"),
      ),
      body:
        UserWidget()
    );
  }
}

class CallModeratorWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Moderator Widget"),
        ),
        body:
        ModeratorWidget()
    );
  }
}
