import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:movie_app/models/movie.dart';
import 'package:movie_app/network/api.dart';
import 'package:movie_app/pages/detailpage.dart';
import 'package:movie_app/pages/search.dart';

class MainPage extends StatefulWidget {
  MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  List<Movie>? popularMovies;
  List<Movie>? topRatedMovies;

  loadPopular() async {
    debugPrint("getPopular1 working!");
    API().getPopular().then((value) {
      debugPrint("getPopular working!");
      setState(() {
        popularMovies = value;
      });
    });
    API().getUpcoming().then((value) {
      setState(() {
        topRatedMovies = value;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    loadPopular();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 16, 16, 17),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("Movie App"),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SearchPage()));
              },
              icon: const Icon(Icons.search))
        ],
      ),
      body: popularMovies == null || topRatedMovies == null
          ? const Text(
              "Loading...",
              style: TextStyle(color: Colors.white),
            )
          : Container(
              padding: const EdgeInsets.all(12),
              color: const Color.fromARGB(255, 16, 16, 17),
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Popular",
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 200,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: popularMovies!.length,
                        itemBuilder: (BuildContext context, int index) {
                          Movie m = popularMovies![index];

                          return Container(
                            margin: const EdgeInsets.only(right: 10, top: 10),
                            width: MediaQuery.of(context).size.width / 1.08,
                            height: 190,
                            child: Column(children: [
                              InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => DetailPage(
                                                  movie: m,
                                                )));
                                  },
                                  child: Stack(children: [
                                    m.posterPath == null
                                        ? Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            color: Colors.red,
                                            height: 180,
                                          )
                                        : SizedBox(
                                            height: 180,
                                            child: Hero(
                                                tag: "${m.id}",
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                  child: Image.network(
                                                    API.imageURL +
                                                        (m.posterPath
                                                            as String),
                                                    width: 500,
                                                    fit: BoxFit.cover,
                                                  ),
                                                )),
                                          ),
                                    BackdropFilter(
                                      filter: ImageFilter.blur(
                                          sigmaX: 2, sigmaY: 2),
                                      child: Container(
                                          decoration: BoxDecoration(
                                              color: Colors.black
                                                  .withOpacity(0.1))),
                                    ),
                                    Center(
                                      child: Text(
                                        m.title,
                                        maxLines: 2,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          fontSize: 50,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ])),
                            ]),
                          );
                        }),
                  ),
                  const Text(
                    "Highest Ratings",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 240,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: topRatedMovies!.length,
                        itemBuilder: (BuildContext context, int index) {
                          Movie topRated = topRatedMovies![index];

                          return Container(
                            margin: const EdgeInsets.only(right: 10, top: 10),
                            child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => DetailPage(
                                                movie: topRated,
                                              )));
                                },
                                child: Column(
                                  children: [
                                    SizedBox(
                                      width:
                                          MediaQuery.of(context).size.width / 3,
                                      height: 180,
                                      child: Hero(
                                          tag: "${topRated.id}",
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            child: topRated.posterPath == null
                                                ? Container(
                                                    width: 200,
                                                    height: 180,
                                                    color: Colors.red,
                                                  )
                                                : Image.network(
                                                    API.imageURL +
                                                        (topRated.posterPath
                                                            as String),
                                                  ),
                                          )),
                                    ),
                                    SizedBox(
                                      height: 30,
                                      child: Row(
                                        children: [
                                          SizedBox(
                                              width: 100,
                                              child: Text(
                                                topRated.title,
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                    color: Colors.white),
                                              )),
                                          Text("${topRated.voteAverage}",
                                              style: const TextStyle(
                                                  color: Colors.white)),
                                        ],
                                      ),
                                    )
                                  ],
                                )),
                          );
                        }),
                  )
                ],
              ),
            ),
    );
  }
}
