import 'package:flutter/material.dart';
class SettingsPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<SettingsPage>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Setting'),),
      body: Center(
        child: Text('Setting'),
      ),
    );
  }
}