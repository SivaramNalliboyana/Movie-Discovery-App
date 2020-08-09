import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:easymovies/apikey.dart';
import 'package:easymovies/genre.dart';
import 'package:easymovies/model.dart';
import 'package:easymovies/viewmovie.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  TabController tabController;
  void initState() {
    super.initState();
    tabController = TabController(length: 5, vsync: this);
  }

  getrendingmovies() async {
    var url = 'https://api.themoviedb.org/3/trending/movie/day?api_key=$apikey';
    var response = await http.get(url);
    var result = jsonDecode(response.body);
    List<Movie> trendinglist = List<Movie>();
    for (var cinema in result['results']) {
      Movie movie = Movie(
          cinema['poster_path'],
          cinema['title'],
          cinema['overview'],
          cinema['vote_average'],
          cinema['id'],
          cinema['original_language'],
          cinema['original_title']);
      trendinglist.add(movie);
    }
    return trendinglist;
  }

  getgenerelist() async {
    var url =
        'https://api.themoviedb.org/3/genre/movie/list?api_key=$apikey&langua00ge=en-US';
    var response = await http.get(url);
    var result = jsonDecode(response.body);
    print(result);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.only(left: 20.0, top: 50.0),
              child: Text(
                "Trending Movies",
                style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.w700, fontSize: 20),
              ),
            ),
            SizedBox(height: 10.0),
            Container(
                height: 400,
                child: FutureBuilder(
                    future: getrendingmovies(),
                    builder: (BuildContext context, dataSnapshot) {
                      if (!dataSnapshot.hasData) {
                        return Text("Loading");
                      }
                      return CarouselSlider.builder(
                          itemCount: dataSnapshot.data.length,
                          itemBuilder: (BuildContext context, int index) {
                            return GestureDetector(
                              onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => ViewMovie(
                                          dataSnapshot.data[index].poster,
                                          dataSnapshot.data[index].title,
                                          dataSnapshot.data[index].overview,
                                          dataSnapshot.data[index].rating,
                                          dataSnapshot.data[index].id,
                                          dataSnapshot.data[index].origin,
                                          dataSnapshot.data[index].original))),
                              child: Container(
                                height: 400,
                                width: MediaQuery.of(context).size.width,
                                child: Hero(
                                  tag: dataSnapshot.data[index].poster,
                                  child: Image(
                                    image: NetworkImage(
                                        'https://image.tmdb.org/t/p/w500${dataSnapshot.data[index].poster}'),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            );
                          },
                          options: CarouselOptions(
                            height: 400,
                            viewportFraction: 0.8,
                            enableInfiniteScroll: true,
                            reverse: true,
                            autoPlay: true,
                            autoPlayInterval: Duration(seconds: 4),
                            autoPlayAnimationDuration:
                                Duration(milliseconds: 800),
                            autoPlayCurve: Curves.easeIn,
                            enlargeCenterPage: true,
                            scrollDirection: Axis.horizontal,
                          ));
                    })),
            TabBar(
                controller: tabController,
                isScrollable: true,
                indicatorColor: Colors.black,
                labelColor: Colors.black,
                unselectedLabelColor: Colors.grey,
                labelStyle: GoogleFonts.montserrat(fontWeight: FontWeight.bold),
                tabs: [
                  Tab(
                    text: "Action",
                  ),
                  Tab(
                    text: "Comedy",
                  ),
                  Tab(
                    text: "Crime",
                  ),
                  Tab(
                    text: "Thriller",
                  ),
                  Tab(
                    text: "Romance",
                  ),
                ]),
            SingleChildScrollView(
                child: Container(
              height: 200,
              child: TabBarView(controller: tabController, children: [
                GenrePage('28'),
                GenrePage('35'),
                GenrePage('80'),
                GenrePage('53'),
                GenrePage('10749'),
              ]),
            ))
          ],
        ),
      ),
    );
  }
}
