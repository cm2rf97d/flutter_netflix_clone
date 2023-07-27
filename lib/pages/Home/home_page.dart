import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:netflix_sample/pages/Home/home_page_cell.dart';
import '../../model/Movie/movie_state.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  String imageUrl = "";

  final List<Map<String, String>> _titleAndCategory = [
    {'title': 'Trending Movies', 'category': '/trending/movie/day'},
    {'title': 'Trending Movies', 'category': '/trending/movie/day'},
    {'title': 'Trending TV', 'category': '/trending/tv/day'},
    {'title': 'Popular Movies', 'category': '/movie/popular'},
    {'title': 'UpComing Movies', 'category': '/movie/upcoming'},
    {'title': 'Top Rate Movies', 'category': '/movie/top_rated'}
  ];

  @override
  void initState() {
    super.initState();
    _fetchMovie(); // 取得最上層的圖片 url
  }

  @override
  void dispose() {
    super.dispose();
  }

  // 取得最上層的圖片 url
  void _fetchMovie() async {
    var movies = await MovieState()
        .fetchMovie(FetchMovieType.regular, '/trending/movie/day');

    if (mounted) {
      // 確認API的結果回來時，該頁面還沒有被dispose.
      setState(() {
        imageUrl = movies[Random().nextInt(movies.length)]
            .posterPath; // 取出隨機的movie imageUrl.
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size deviceScreen = MediaQuery.of(context).size; // 取得螢幕 size

    // TODO: implement build
    return Container(
      color: Colors.black,
      child: ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          if (index == 0 && imageUrl != "") {
            // 第一個 section 要顯示大圖片，因此做個判斷
            return SizedBox(
              height: 280,
              width: deviceScreen.width - 80,
              child: CachedNetworkImage(
                progressIndicatorBuilder: (context, url, progress) => Center(
                  child: CircularProgressIndicator(
                    value: progress.progress,
                  ),
                ),
                imageUrl: 'https://image.tmdb.org/t/p/w500$imageUrl',
              ),
            );
          } else {
            return SizedBox(
                height: 250,
                child: Column(
                  children: [
                    Container( // 顯示影片的類別
                        alignment: Alignment.topLeft,
                        padding: const EdgeInsets.only(left: 15),
                        child: Text(
                          _titleAndCategory[index]['title'] ?? "",
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.w700),
                        )),
                    SizedBox(
                      // 顯示影片的圖案(Horizontal ListView)
                      height: 200,
                      child: HomePageCell(
                          fetchCategory:
                              _titleAndCategory[index]['category'] ?? ""),
                    )
                  ],
                ));
          }
        },
        itemCount: _titleAndCategory.length,
      ),
    );
  }
}
