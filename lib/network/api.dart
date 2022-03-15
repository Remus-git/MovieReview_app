import 'package:flutter/cupertino.dart';
import 'package:movie_app/models/cast.dart';
import 'package:movie_app/models/movie.dart';
import 'package:movie_app/models/res_cast.dart';
import 'package:movie_app/models/res_popular.dart';
import 'package:http/http.dart' as http;

class API {
  final String _baseURL = "https://api.themoviedb.org/3";
  static const String imageURL = "http://image.tmdb.org/t/p/w200";

  final String _apiKey = "d435c4ede979c49687a7eaa3d46ff096";

  Future<List<Movie>> getList(String url, {String param = ""}) async {
    final response = await http.get(
      Uri.parse("$_baseURL$url?api_key=$_apiKey&$param"),
    );

    if (response.statusCode == 200) {
      var resp = ResPopular.fromRawJson(response.body);

      return resp.results;
    } else {
      throw Exception('Failed to load album');
    }
  }

  Future<List<Movie>> getPopular() async {
    return getList("/movie/popular");
  }

  Future<List<Movie>> getUpcoming() async {
    return getList("/movie/top_rated");
  }

  Future<List<Movie>> getSearch(String name) async {
    return getList("/search/movie", param: "query=$name");
  }

  Future<List<Movie>> getRecommend(int movieID) async {
    var url = "/movie/$movieID/recommendations";
    final response = await http.get(
      Uri.parse("$_baseURL$url?api_key=$_apiKey"),
    );

    if (response.statusCode == 200) {
      var resp = ResPopular.fromRawJson(response.body);
      return resp.results;
    } else {
      throw Exception('Failed to Load Casts');
    }
  }

  Future<List<Cast>> getCast(int movieID) async {
    var url = "/movie/$movieID/credits";

    final response = await http.get(
      Uri.parse("$_baseURL$url?api_key=$_apiKey"),
    );

    if (response.statusCode == 200) {
      var resp = RespCast.fromRawJson(response.body);
      return resp.cast;
    } else {
      throw Exception('Failed to load Casts');
    }
  }
}
