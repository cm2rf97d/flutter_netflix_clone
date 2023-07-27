import 'package:netflix_sample/database/database_helper.dart';
import 'package:netflix_sample/model/Movie/movie_data.dart';

class MovieManager {
  final dbHelper = DataBaseHelper.instance;

  MovieManager._privateConstructor();

  static final MovieManager instance = MovieManager._privateConstructor();

  void insert(SubMovieData movie) async {
    var result = await dbHelper.querySpecifyRow(movie.id);
    List<SubMovieData> downloadMovies =
        result.map((i) => SubMovieData.fromJson(i)).toList();

    if(downloadMovies.isEmpty) {
      dbHelper.insert(movie.toMap());
    }
  }

  void delete(SubMovieData movie) async {
    dbHelper.delete(movie.id);
  }

  Future<List<Map<String, dynamic>>> queryAllMovie() async {
    final movies = await dbHelper.queryAllRows();
    return movies;
  }
}
