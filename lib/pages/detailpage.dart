import 'package:flutter/material.dart';
import 'package:movie_app/models/cast.dart';
import 'package:movie_app/network/api.dart';
import 'package:movie_app/models/movie.dart';

class DetailPage extends StatefulWidget {
  Movie movie;
  DetailPage({Key? key, required this.movie}) : super(key: key);

  @override
  State<DetailPage> createState() => _DeatilPageState();
}

class _DeatilPageState extends State<DetailPage> {
  List<Cast>? casts;
  List<Movie>? recommends;
  loadDetails() async {
    API().getRecommend(widget.movie.id).then((value) {
      setState(() {
        recommends = value;
      });
    });
    API().getCast(widget.movie.id).then((value) {
      setState(() {
        casts = value;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    loadDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 16, 16, 17),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("Movie Details"),
      ),
      body: SingleChildScrollView(
          child: Container(
        margin: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Hero(
                    tag: "${widget.movie.id}",
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.network(API.imageURL +
                            (widget.movie.posterPath as String)))),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        margin: const EdgeInsets.only(left: 25, bottom: 25),
                        child: Column(
                          children: [
                            const Icon(
                              Icons.date_range,
                              color: Colors.white,
                            ),
                            const Text(
                              "Release Date",
                              style: TextStyle(color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              "${widget.movie.releaseDate}",
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 10),
                            ),
                          ],
                        )),
                    Container(
                        margin: const EdgeInsets.only(left: 25, bottom: 25),
                        child: Column(
                          children: [
                            const Icon(
                              Icons.rate_review_outlined,
                              color: Colors.white,
                            ),
                            const Text(
                              "Rating",
                              style: TextStyle(color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              "${widget.movie.voteAverage}",
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 15),
                            ),
                          ],
                        )),
                    Container(
                        margin: const EdgeInsets.only(left: 25, bottom: 25),
                        child: Column(
                          children: [
                            const Icon(
                              Icons.star_border_outlined,
                              color: Colors.white,
                            ),
                            const Text(
                              "Popularity",
                              style: TextStyle(color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              "${widget.movie.popularity}",
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 10),
                            ),
                          ],
                        ))
                  ],
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.all(15),
              child: Column(
                children: [
                  Container(
                      margin: EdgeInsets.only(bottom: 20),
                      child: Center(
                        child: Text(
                          widget.movie.title,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                              fontWeight: FontWeight.bold),
                        ),
                      )),
                  Text(
                    widget.movie.overview,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontFamily: 'RaleWay',
                      height: 1.8,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
            ),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text(
                "Recommend Movies",
                textAlign: TextAlign.start,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
              recommends == null
                  ? CircularProgressIndicator()
                  : SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 240,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: recommends!.length,
                          itemBuilder: (BuildContext context, int index) {
                            Movie recommend = recommends![index];
                            return Container(
                              margin: const EdgeInsets.only(right: 10, top: 10),
                              child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => DetailPage(
                                                  movie: recommend,
                                                )));
                                  },
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                3,
                                        height: 180,
                                        child: Hero(
                                            tag: "${recommend.id}",
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              child: recommend.posterPath ==
                                                      null
                                                  ? Container(
                                                      width: 200,
                                                      height: 180,
                                                      color: Colors.red,
                                                    )
                                                  : Image.network(
                                                      API.imageURL +
                                                          (recommend.posterPath
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
                                                  recommend.title,
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                      color: Colors.white),
                                                )),
                                            Text("${recommend.voteAverage}",
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
            ]),
            Container(
              margin: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Casts",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  casts == null
                      ? const CircularProgressIndicator()
                      : SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: 160,
                          child: Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: casts!.length,
                                itemBuilder: (BuildContext context, int index) {
                                  Cast cast = casts![index];
                                  return Column(
                                    children: [
                                      cast.profilePath == null
                                          ? const Padding(
                                              padding:
                                                  EdgeInsets.only(right: 20),
                                              child: CircleAvatar(
                                                radius: 45,
                                              ))
                                          : Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 20),
                                              child: CircleAvatar(
                                                radius: 45,
                                                backgroundImage: NetworkImage(
                                                    API.imageURL +
                                                        cast.profilePath!),
                                              )),
                                      SizedBox(
                                          width: 80,
                                          child: Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 20),
                                              child: Text(cast.originalName,
                                                  textAlign: TextAlign.center,
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold)))),
                                    ],
                                  );
                                },
                              )))
                ],
              ),
            ),
          ],
        ),
      )),
    );
  }
}
