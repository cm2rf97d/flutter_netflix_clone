import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../model/Movie/movie_data.dart';

class FetchPictureImage extends StatefulWidget {
  final SubMovieData movieData;

  const FetchPictureImage({super.key, required this.movieData});

  @override
  State<FetchPictureImage> createState() => _FetchPictureImage();
}

class _FetchPictureImage extends State<FetchPictureImage> {
  late final SubMovieData _movieData;

  @override
  void initState() {
    _movieData = widget.movieData; // 由於 createState() 不要帶參數比較好，因此在 initState() 內取得.
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String imageUrl = _movieData.posterPath;
    return Container(
      color: Colors.black,
      child: CachedNetworkImage(
        progressIndicatorBuilder: (context, url, progress) => Center(
          child: CircularProgressIndicator(
            value: progress.progress,
          ),
        ),
        fit: BoxFit.fill,
        fadeOutDuration: const Duration(seconds: 1),
        imageUrl: 'https://image.tmdb.org/t/p/w500$imageUrl',
      ),
    );
  }
}
