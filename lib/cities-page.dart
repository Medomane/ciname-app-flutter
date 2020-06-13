import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'cinemas-page.dart';
import 'globals.dart';

class CitiesPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<CitiesPage>{

  List<dynamic> cities;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Citites'),),
      body: Center(
        child: this.cities==null?CircularProgressIndicator():
            ListView.builder(
              itemCount: this.cities==null?0:this.cities.length,
              itemBuilder: (context,index){
                return Card(
                  color: Colors.orange,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RaisedButton(
                      color:Colors.white,
                      child: Text(this.cities[index]["name"],style:TextStyle(color:Colors.black)),
                      onPressed: (){
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context)=>CinemasPage(this.cities[index])
                        ));
                      },
                    ),
                  ),
                );
              }
            )
      ),
    );
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadCities();
  }

  void loadCities() {
    http.get(Globals.host+"/cities").then((value) {
      setState(() {
        this.cities = json.decode(utf8.decode(value.bodyBytes))["_embedded"]["cities"];
      });
    }).catchError((error)=>print(error.toString()));
  }
}