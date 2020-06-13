import 'package:cinema/setting-file.dart';
import 'package:flutter/material.dart';

import 'cities-page.dart';

class MainDrawer extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    final menu=[
      {"title":"Home","icon":Icon(Icons.home),"page":CitiesPage()},
      {"title":"Setting","icon":Icon(Icons.settings),"page":SettingsPage()},
    ];
    return Drawer(
        child: ListView(
            children: <Widget>
            [
              DrawerHeader(
                  child: Center(
                      child: CircleAvatar( radius: 50,backgroundImage: AssetImage("images/photo.jpg") )
                  ),
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [Colors.orange,Colors.yellow, Colors.white]
                      )
                  )
              ),
              ...menu.map((e) {
                Divider(color :Colors.black,thickness:0,);
                return ListTile(
                    title: Text( e["title"], style: TextStyle(fontSize: 18) ),
                    leading: e["icon"],
                    trailing: Icon(Icons.arrow_right),
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.push( context, MaterialPageRoute(builder: (context) => e["page"]));
                    }
                );
              })
            ]
        )
    );
  }
}