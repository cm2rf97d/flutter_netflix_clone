import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:netflix_sample/model/Movie/movie_data.dart';
import 'package:netflix_sample/pages/MovieDetail/movie_detail_page.dart';
import 'package:netflix_sample/widget/fetch_picture_image.dart';
import '../../model/Movie/movie_state.dart';
import '../../model/YoutubeVideo/youtube_video_state.dart';

class HomePageCell extends StatefulWidget {
  final String fetchCategory;

  const HomePageCell({super.key, required this.fetchCategory});

  @override
  State<HomePageCell> createState() => _HomePageCell();
}

class _HomePageCell extends State<HomePageCell> {
  late final String _fetchUrlBody; // 發送API的 url detail.
  List<SubMovieData> _movies = []; // 儲存從 API 取得的電影
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchUrlBody =
        widget.fetchCategory; // 由於 createState() 不要帶參數比較好，因此在 initState() 內取得.
    fetchMovie(); // 發送 API 取得電影
  }

  @override
  void dispose() {
    super.dispose();
  }

  void fetchMovie() async {
    setState(() {
      _isLoading = true;
    });

    var movies =
        await MovieState().fetchMovie(FetchMovieType.regular, _fetchUrlBody);
    _movies = movies;

    if (mounted) { // 確認API的結果回來時，該頁面還沒有被dispose.
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size deviceScreen = MediaQuery
        .of(context)
        .size;

    return _isLoading
        ? SizedBox(
      // Loading 動畫
        height: deviceScreen.height,
        width: deviceScreen.width,
        child: const Center(child: CircularProgressIndicator()))
        : Center(
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              width: 150,
              height: 200,
              padding: const EdgeInsets.all(10.0),
              child: SizedBox(
                  height: 10,
                  width: 50,
                  child: InkWell( // 點擊後導向 電影細節頁面
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
                      elevation: 5.0,
                      child: FetchPictureImage(movieData: _movies[index]), // 讀取 網路image 的 Image, 額外寫一個class.
                      // child: Text('1'),
                    ),
                  )),
            );
          },
          itemCount: _movies.length,
        ));
  }
}