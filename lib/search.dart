import 'dart:convert';

import 'package:easymovies/apikey.dart';
import 'package:easymovies/viewmovie.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'model.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController textEditingController = TextEditingController();
  bool valuentered = false;

  displaynofilms() {
    final Orientation orientation = MediaQuery.of(context).orientation;
    return Container(
      child: Center(
          child: ListView(
        shrinkWrap: true,
        children: <Widget>[
          Icon(Icons.movie, color: Colors.grey, size: 200.0),
          Text(
            "Search for Movies",
            style: TextStyle(
                fontFamily: "Montesserat",
                fontWeight: FontWeight.w700,
                fontSize: 25),
            textAlign: TextAlign.center,
          )
        ],
      )),
    );
  }
  getsearchquery() async {
    var url = 'https://api.themoviedb.org/3/search/movie?api_key=$apikey&language=en-US&query=${textEditingController.text}&page=1&include_adult=false';
  var response =  await http.get(url);
    var result = jsonDecode(response.body);
     List<Movie> genrelist = List<Movie>();
    for (var cinema in result['results']) {
      Movie movie = Movie(
          cinema['poster_path'],
          cinema['title'],
          cinema['overview'],
          1.0,
          cinema['id'],
          cinema['original_language'],
          cinema['original_title']);
      genrelist.add(movie);
    }
    return genrelist;
  
  }
  
  
  
  displayfilms(){
    return FutureBuilder(
      future: getsearchquery(),
      builder: (BuildContext context, dataSnapshot){
        if (!dataSnapshot.hasData){
          return Text("Loading");
        }
      return GridView.builder(
        itemCount: dataSnapshot.data.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2), itemBuilder: (BuildContext context, int index){
          return Container(
            padding: EdgeInsets.all(5.0),
            height: 200,
            child: Image(image: NetworkImage('https://image.tmdb.org/t/p/w500${dataSnapshot.data[index].poster}'),fit: BoxFit.cover,),
          );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: textEditingController,
          decoration: InputDecoration(
              hintText: 'Search here...',
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
              filled: true,
              fillColor: Colors.blue,
              suffixIcon: RaisedButton(
                  onPressed: () {
                    setState(() {
                      valuentered = true;
                    });
                  },
                  color: Colors.orange,
                  child: Text("Search"))),
        ),
      ),
      body: valuentered == false ? displaynofilms() : displayfilms(),
    );
  }
}
