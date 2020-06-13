import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:transparent_image/transparent_image.dart';

import 'globals.dart';

class RoomsPage extends StatefulWidget{
  dynamic cinema;
  RoomsPage(this.cinema);

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<RoomsPage> {
  List<dynamic> rooms;
  List<int> selectedTickets = new List<int>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.cinema["name"]+'\'s rooms'),),
      body: Center(
          child: this.rooms==null?CircularProgressIndicator():
          ListView.builder(
              itemCount: this.rooms==null?0:this.rooms.length,
              itemBuilder: (context,index){
                return Card(
                  color: Colors.lightBlueAccent,
                    child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: RaisedButton(
                              color:Colors.white,
                              child: Text(this.rooms[index]["name"],style:TextStyle(color:Colors.black)),
                              onPressed: (){
                                loadInfo(rooms[index]);
                              },
                            ),
                          ),
                          if(rooms[index]["projections"]!=null)
                          Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  leftSection(rooms[index]["projections"][0]["film"]),
                                  rightSection(rooms[index]["projections"],rooms[index])
                                ],
                              ),
                              if(selectedTickets.length > 0)
                              Row(
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width-20,
                                    child: TextField(
                                      decoration: InputDecoration(hintText: 'Client name'),
                                      onSubmitted: (text){
                                        if(text != null && text.trim() != "" && selectedTickets.length > 0){
                                          Map data = {"clientName":text,"tickets":selectedTickets};
                                          String body = json.encode(data);
                                          http.post(Globals.host+"/buy",headers: {"Content-Type": "application/json"},body: body).
                                          then((value) => loadTickets(rooms[index]["currentProjection"],rooms[index])).
                                          catchError((err)=>print(err.toString()));

                                        }
                                      },
                                    ),
                                  )
                                ],
                              ),
                              if(rooms[index]["currentProjection"] != null && rooms[index]["currentProjection"]["tickets"] != null && rooms[index]["currentProjection"]["tickets"].length > 0)
                              Wrap(
                                spacing: 8.0,
                                runSpacing: 4.0,
                                children: <Widget>[
                                  ...rooms[index]["currentProjection"]["tickets"].map((ticket){
                                    return Container(
                                      width: 40,
                                      child: RaisedButton(
                                        color:ticket["selected"]!=null && ticket["selected"] == true?Colors.purpleAccent:Colors.white,
                                        onPressed: () {
                                          setState((){
                                            if(ticket["selected"]!=null && ticket["selected"] == true){
                                              ticket["selected"] = false;
                                              selectedTickets.remove(ticket["id"]);
                                            }
                                            else {
                                              ticket["selected"] = true;
                                              selectedTickets.add(ticket["id"]);
                                            }
                                          });
                                        },
                                        child: Text(ticket["place"]["number"].toString(),style:TextStyle(color:Colors.black)),
                                      ),
                                    );
                                  })
                                ],
                              )
                            ],
                          )
                        ],
                      ),
                    )
                );
              }
          )
      ),
    );
  }
  @override
  void initState() {
    super.initState();
    loadCinemas();
  }

  void loadCinemas() {
    http.get(widget.cinema["_links"]["rooms"]["href"]).then((value) {
      setState(() {
        this.rooms = json.decode(utf8.decode(value.bodyBytes))["_embedded"]["rooms"];
      });
    }).catchError((error)=>print(error.toString()));
  }

  void loadInfo(room) {
    http.get(room["_links"]["room"]["href"]+"/projections?projection=p1").then((value) {
      setState(() {
        room["projections"] = json.decode(utf8.decode(value.bodyBytes))["_embedded"]["projections"];
      });
    }).catchError((error)=>print(error.toString()));
  }

  Widget leftSection(film) => new Container(
      child: Stack(
        children: [
          Center(child: CircularProgressIndicator(),heightFactor: 2),
          GestureDetector(
            child:Center(
                child: FadeInImage.memoryNetwork(
                  width:  MediaQuery.of(context).size.width/2,
                    placeholder: kTransparentImage,
                    image: '${Globals.host+'/image/'+film["id"].toString()}'
                )
            ),
          ),
        ],
      )
  );

  Widget rightSection(projections,room) => new Container(
    width: MediaQuery.of(context).size.width/2.5,
    child: Padding(
      padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
      child: ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: projections==null?0:projections.length,
          itemBuilder: (context,index){
            return RaisedButton(
              color:room["currentProjection"] != null && room["currentProjection"]["id"] == projections[index]["id"]?Colors.amberAccent:Colors.orange,
              child: Text(projections[index]["session"]["date"],style:TextStyle(color:Colors.black)),
              onPressed: (){
                loadTickets(projections[index],room);
              },
            );
          }
      ),
    )
  );

  void loadTickets(projection,room) {
    http.get(projection["_links"]["tickets"]["href"].toString().replaceAll("{?projection}", "?projection=ticketProjection")).then((value) {
      setState(() {
        projection["tickets"] = json.decode(utf8.decode(value.bodyBytes))["_embedded"]["tickets"].where((ticket)=>ticket["reserved"] == false);
        room["currentProjection"] = projection;
      });
    }).catchError((error)=>print(error.toString()));
  }
}