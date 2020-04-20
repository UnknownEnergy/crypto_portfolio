import 'package:crypto_portfolio/models/moderator.dart';
import 'package:crypto_portfolio/services/moderatorDatabase.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget ModeratorWidget() {

  return FutureBuilder(
    builder: (context, userSnap) {
      if (userSnap.connectionState == ConnectionState.none &&
          userSnap.hasData == null) {
        return Container();
      }
      return ListView.builder(

          itemCount: 1,
          padding: const EdgeInsets.all(15.0),
          itemBuilder: (context, position) {
            Moderator moderator = userSnap.data[position];
            return Column(
              children: <Widget>[
                TextField(
                  obscureText: false,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Moderator',
                  ),
                ),
                Divider(height: 5.0),

                ListTile(
                  title: Text(
                    "ID: "+moderator.userId,
                    style: TextStyle(
                      fontSize: 22.0,
                      color: Colors.deepOrangeAccent,
                    ),
                  ),

                  trailing: Column(
                    children: <Widget>[
                      Padding(padding: EdgeInsets.all(5.0)),

                      GestureDetector( onTap: () {}, child: Icon(Icons.delete) )
                    ],
                  ),
                 // onTap: () => _navigateToNote(context, items[position]),
                ),
              ],
            );
          });

    },

    future: new ModeratorDatabaseService().getAllModerators(),

  );
}
