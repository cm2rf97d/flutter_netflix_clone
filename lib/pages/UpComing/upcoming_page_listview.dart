import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:netflix_sample/model/Movie/movie_data.dart';

import '../MovieDetail/movie_detail_page.dart';

class UpComingPageListView extends StatefulWidget {
  final List<SubMovieData> movies;

  const UpComingPageListView({super.key, required this.movies});

  @override
  State<UpComingPageListView> createState() => _UpComingPageListView();
}

class _UpComingPageListView extends State<UpComingPageListView> {
  late final List<SubMovieData> _movies;

  @override
  void initState() {
    _movies = widget.movies;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
        color: Colors.black,
        child: ListView.builder(
          scrollDirection: Axis.vertical,
          itemBuilder: (BuildContext context, int index) {
            String imageUrl = _movies[index].posterPath; // 電影 image url
            String movieName = _movies[index].originalTitle; // 電影名稱
            return Container(
                height: 180,
                padding: const EdgeInsets.all(10.0),
                child: InkWell(
                  // 導向電影細節頁面
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return Scaffold(
                          appBar: AppBar(
                            title: Text(_movies[index].originalTitle),
                            backgroundColor: Colors.black,
                          ),
                          backgroundColor: Colors.black,
                          body: MovieDetailPage(movie: _movies[index]));
                    }));
                  },
                  child: Card(
                    color: Colors.black,
                    elevation: 5.0,
                    child: Row(
                      children: [
                        CachedNetworkImage(
                          progressIndicatorBuilder: (context, url, progress) =>
                              Center(
                            child: CircularProgressIndicator(
                              value: progress.progress,
                            ),
                          ),
                          fit: BoxFit.fill,
                          fadeOutDuration: const Duration(seconds: 1),
                          imageUrl: 'https://image.tmdb.org/t/p/w500$imageUrl',
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          // 使用 Expanded 讓文字自適應
                          child: Text(
                            movieName,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 19),
                          ),
                        ),
                        const Icon(Icons.play_circle_outline,
                            color: Colors.white),
                      ],
                    ),
                  ),
                ));
          },
          itemCount: _movies.length,
        ));
  }
}
