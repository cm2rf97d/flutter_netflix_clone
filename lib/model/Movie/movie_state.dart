import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:netflix_sample/model/Movie/movie_data.dart';

import '../../KEY/key.dart';

enum FetchMovieType {
  regular, popular, search
}


class MovieState extends ChangeNotifier {
  final String defaultUrl = 'https://api.themoviedb.org';

  List<SubMovieData> subMovieData = [SubMovieData(id: 0, originalTitle: '', posterPath: '', overview: '')];

  Future<List<SubMovieData>> fetchMovie(FetchMovieType type, String category, [String query = '']) async {

    final Completer<List<SubMovieData>> completer = Completer();


    Uri url = Uri.parse(getUrl(type, category, query));

    final response = await http.get(url, headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    });

    final parsedResponse = json.decode(response.body) as Map<String, dynamic>;
    var movieData = MovieData.fromJson(parsedResponse);
    subMovieData = movieData.subData;
    completer.complete(subMovieData);
    notifyListeners();
    return completer.future;
  }

  String getUrl(FetchMovieType type, String category, String query) {
    switch (type) {
      case FetchMovieType.regular:
        return '$defaultUrl/3$category?api_key=$movieApiKey&language=en-US&page=1';
      case FetchMovieType.popular:
        return '$defaultUrl/3/discover/movie?api_key=$movieApiKey&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&page=1&with_watch_monetization_types=flatrate';
      case FetchMovieType.search:
        return '$defaultUrl/3/search/movie?api_key=$movieApiKey&query=$query';
    }
  }
}
