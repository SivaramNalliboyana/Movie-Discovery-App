import 'dart:convert';

import 'package:easymovies/apikey.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'model.dart';

class ViewMovie extends StatefulWidget {
  final String poster;
  final String title;
  final String overview;
  final double rating;
  final int id;
  final String origin;
  final String original;

  ViewMovie(this.poster, this.title, this.overview, this.rating, this.id,
      this.origin, this.original);
  @override
  _ViewMovieState createState() => _ViewMovieState();
}

class _ViewMovieState extends State<ViewMovie> {
  getsimiliarmovies()async{
    var url = 'https://api.themoviedb.org/3/movie/${widget.id}/similar?api_key=$apikey&language=en-US&page=1';
    var response =  await http.get(url);
    var result = jsonDecode(response.body);
    List<SimiliarMovie> genrelist = List<SimiliarMovie>();
    for (var cinema in result['results']) {
      print(result);
      SimiliarMovie movie = SimiliarMovie(
          cinema['poster_path'],);
      genrelist.add(movie);
    }
    return genrelist;
  }
  
  
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
          physics: ScrollPhysics(),
      child: Column(
        children: <Widget>[
          ClipPath(
            clipper: OvalBottomBorderClipper(),
            child: Hero(
              tag: widget.poster,
              child: Container(
                  height: 400,
                  width: MediaQuery.of(context).size.width,
                  child: Image(
                    image: NetworkImage(
                        'https://image.tmdb.org/t/p/w500${widget.poster}'),fit: BoxFit.cover,
                  )),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(height:10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Icon(Icons.video_library,),
                  Text(widget.title,style: GoogleFonts.montserrat(
                    fontWeight:FontWeight.w700,
                    fontSize:20
                  ),),
                  Icon(Icons.favorite,color: Colors.red),
                ],
              ),
              SizedBox(height:10.0),
              RatingBar(
                 allowHalfRating: true,
                 itemCount: 5,
                 itemSize: 45,
                 itemBuilder: (BuildContext context,_)=>Icon(Icons.star,color:Colors.yellow),
                 initialRating: widget.rating / 2,
                 onRatingUpdate: (rating){
                   print(rating);
                 },
              ),
              SizedBox(height:10.0),
              Text("OverView",style: GoogleFonts.montserrat(
                fontWeight:FontWeight.w400,
                fontSize:15
              ),),
              SizedBox(height:5.0),
              Text(widget.overview,style:GoogleFonts.montserrat(
                fontWeight:FontWeight.w700,
                fontSize:20
              ) ,),
            ],
          ),
          Container(
            height: 200,
            child: FutureBuilder(
              future: getsimiliarmovies(),
              builder: (BuildContext context,dataSnapshot){
              if (!dataSnapshot.hasData){
                return Text("Loading");
              }
              return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context,int index){
                return Container(
                  padding: EdgeInsets.all(10.0),
                  height:200,
                  child: Image(image: NetworkImage('https://image.tmdb.org/t/p/w500${dataSnapshot.data[index].poster}'),fit: BoxFit.cover
                ));
              });
            }),
          )
        ],
      ),
    ));
  }
}

class SimiliarMovie {
  final String poster;
  SimiliarMovie(this.poster);}