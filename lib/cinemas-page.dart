import 'dart:convert';

import 'package:cinema/rooms-page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CinemasPage extends StatefulWidget{
  dynamic city;
  CinemasPage(this.city);

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<CinemasPage> {
  List<dynamic> cinemas;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.city["name"]+' \'s Cinémas'),),
      body: Center(
          child: this.cinemas==null?CircularProgressIndicator():
          ListView.builder(
              itemCount: this.cinemas==null?0:this.cinemas.length,
              itemBuilder: (context,index){
                return Card(
                  color: Colors.blueAccent,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RaisedButton(
                      color:Colors.white,
                      child: Text(this.cinemas[index]["name"],style:TextStyle(color:Colors.black)),
                      onPressed: (){
                        Navigator.push(context, MaterialPageRoute(
                            builder: (context)=>RoomsPage(this.cinemas[index])
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
    loadCinemas();
  }

  void loadCinemas() {
    http.get(widget.city["_links"]["cinemas"]["href"]).then((value) {
      setState(() {
        this.cinemas = json.decode(utf8.decode(value.bodyBytes))["_embedded"]["cinemas"];
      });
    }).catchError((error)=>print(error.toString()));
  }
}