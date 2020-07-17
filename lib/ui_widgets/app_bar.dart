import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

class BasicAppBar extends StatelessWidget {
  const BasicAppBar({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }

  Widget createAppBar() {
    return AppBar(
      backgroundColor: Colors.redAccent,
      leading: Icon(Icons.tag_faces),
      title: Text("Sample title"),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.directions_bike),
          onPressed: () {},
        ),
        IconButton(
          icon: Icon(Icons.directions_bus),
          onPressed: () {},
        ),
        PopupMenuButton(
          itemBuilder: (BuildContext context) {
            return [
              PopupMenuItem(child: Text('Boat')),
              PopupMenuItem(child: Text('Train'))
            ];
          },
        )
      ],
    );
  }
}

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final appTitle = 'Drawer Demo';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appTitle,
      home: MyHomePage(title: appTitle),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final String title;

  MyHomePage({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(child: Text('My Page!')),
      drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text('Drawer Header'),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            ListTile(
              title: Text('Item 1'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Item 2'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
