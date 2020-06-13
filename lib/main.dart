import 'package:flutter/material.dart';

import 'main-drawer.dart';

void main()=>runApp(MaterialApp(
  theme: ThemeData(
    appBarTheme: AppBarTheme(
      color: Colors.orange
    )
  ),
  home: MyApp(),
));

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Cinema page'),),
      body: Center(
        child: Text('Cinema'),
      ),
      drawer: MainDrawer()
    );
  }
}
