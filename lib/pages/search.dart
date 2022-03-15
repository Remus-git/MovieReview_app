import 'package:flutter/material.dart';
import 'package:movie_app/models/movie.dart';
import 'package:movie_app/network/api.dart';
import 'package:movie_app/pages/detailpage.dart';

class SearchPage extends StatefulWidget {
  SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<Movie>? result;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 16, 16, 17),
        appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: TextField(
              style: const TextStyle(
                color: Colors.white,
              ),
              textInputAction: TextInputAction.search,
              onSubmitted: (value) {
                value == ""
                    ? result = null
                    : API().getSearch(value).then((value) {
                        setState(() {
                          result = value;
                        });
                      });
              },
              decoration: const InputDecoration(
                  hintStyle: TextStyle(color: Colors.white),
                  hintText: "Search Something..."),
            )),
        body: result == null
            ? const Center(
                child: Text(
                "Please Search Something First",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ))
            : ListView.separated(
                scrollDirection: Axis.vertical,
                itemCount: result!.length,
                itemBuilder: (BuildContext context, int index) {
                  Movie movie = result![index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DetailPage(
                                        movie: movie,
                                      )));
                        },
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 180,
                              child: movie.posterPath == null
                                  ? const Text("None")
                                  : Hero(
                                      tag: "${movie.id}",
                                      child: Image.network(API.imageURL +
                                          (movie.posterPath as String))),
                            ),
                            const SizedBox(
                              width: 12,
                            ),
                            SizedBox(
                              width: 220,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                      height: 45,
                                      child: Text(
                                        movie.title,
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      )),
                                  SizedBox(
                                      height: 120,
                                      child: Text(
                                        movie.overview,
                                        style: const TextStyle(
                                            color: Colors.white),
                                        maxLines: 4,
                                        overflow: TextOverflow.ellipsis,
                                      )),
                                  Text(
                                    "${movie.releaseDate}",
                                    style: const TextStyle(color: Colors.white),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  )
                                ],
                              ),
                            )
                          ],
                        )),
                  );
                },
                separatorBuilder: (BuildContext context, int index) =>
                    const Divider(),
              ));
  }
}
