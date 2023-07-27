class MovieData {
  List<SubMovieData> subData;

  MovieData({required this.subData});

  factory MovieData.fromJson(Map<String, dynamic> json) {
    var list = json['results'] as List;
    List<SubMovieData> movie =
        list.map((i) => SubMovieData.fromJson(i)).toList();
    return MovieData(subData: movie);
  }
}

class SubMovieData {
  final int id;
  final String originalTitle;
  final String posterPath;
  final String overview;

  SubMovieData(
      {required this.id,
      required this.originalTitle,
      required this.posterPath,
      required this.overview,});

  factory SubMovieData.fromJson(Map<String, dynamic> json) => SubMovieData(
      id: json['id'] ?? 0,
      originalTitle: json['original_title'] ?? "",
      posterPath: json['poster_path'] ?? "",
      overview: json['overview'] ?? ""
  );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'original_title': originalTitle,
      'poster_path': posterPath,
      'overview': overview,
    };
  }
}

// SubMovieData.fromJson(Map<String, dynamic> json)
//     : id = json['id'],
//       mediaType = json['media_type'],
//       originalTitle = json['original_title'],
//       posterPath = json['poster_path'],
//       overview = json['overview'],
//       releaseDate = json['release_date'],
//       voteCount = json['vote_count'],
//       voteAverage = json['vote_average'];
