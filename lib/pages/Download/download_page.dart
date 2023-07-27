import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:netflix_sample/database/movie_manager.dart';
import 'package:netflix_sample/model/Movie/movie_data.dart';
import '../MovieDetail/movie_detail_page.dart';

class DownloadPage extends StatefulWidget {
  const DownloadPage({super.key});

  @override
  State<DownloadPage> createState() => _DownloadPage();
}

class _DownloadPage extends State<DownloadPage> {
  List<SubMovieData> downloadMovies = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchDownloadMovies();
  }

  void _fetchDownloadMovies() async {
    setState(() {
      _isLoading = true;
    });

    var aa =
        await MovieManager.instance.queryAllMovie(); // 使用 SQLite 讀取以Download的影片
    List<SubMovieData> downloadMovies =
        aa.map((i) => SubMovieData.fromJson(i)).toList(); // Json decode
    this.downloadMovies = downloadMovies;

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size deviceScreen = MediaQuery.of(context).size;

    if (_isLoading) {
      return Container(
          color: Colors.black,
          child: SizedBox(
              height: deviceScreen.height,
              width: deviceScreen.width,
              child: const Center(child: CircularProgressIndicator())));
    } else {
      return Container(
          height: deviceScreen.height,
          color: Colors.black,
          child: Column(
            children: [
              IconButton(
                  // 目前由於使用 iOS 的 Tabbar關係，選取到該頁面時不會ReBuild，flutter沒有 viewWillAppear 可以Rebuild，
                  // 未來會使用 provider or FutureBuilder 來解決該問題
                  // 目前先使用手動Refresh...><
                  onPressed: () {
                    setState(() {
                      _fetchDownloadMovies();
                    });
                  },
                  icon: const Icon(Icons.refresh, color: Colors.white)),
              Expanded(
                  child: ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  String imageUrl = downloadMovies[index].posterPath;
                  String movieName = downloadMovies[index].originalTitle;

                  return Container(
                      height: 180,
                      padding: const EdgeInsets.all(10.0),
                      child: InkWell(
                        // 點擊後導向 電影細節頁面
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return Scaffold(
                                appBar: AppBar(
                                  title: Text(movieName),
                                  backgroundColor: Colors.black,
                                ),
                                backgroundColor: Colors.black,
                                body: MovieDetailPage(
                                    movie: downloadMovies[index]));
                          }));
                        },
                        child: Card(
                          color: Colors.black,
                          elevation: 5.0,
                          child: Row(
                            children: [
                              CachedNetworkImage(
                                progressIndicatorBuilder:
                                    (context, url, progress) => Center(
                                  child: CircularProgressIndicator(
                                    value: progress.progress,
                                  ),
                                ),
                                fit: BoxFit.fill,
                                fadeOutDuration: const Duration(seconds: 1),
                                imageUrl:
                                    'https://image.tmdb.org/t/p/w500$imageUrl',
                              ),
                              const SizedBox(width: 20),
                              Expanded(
                                child: Text(
                                  movieName,
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 19),
                                ),
                              ),
                              ElevatedButton(
                                  // 刪除Button(SQLite)
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.black),
                                  onPressed: () {
                                    MovieManager.instance
                                        .delete(downloadMovies[index]);
                                    setState(() {
                                      _fetchDownloadMovies();
                                    });
                                  },
                                  child: const Icon(
                                    Icons.delete,
                                    color: Colors.white,
                                  ))
                            ],
                          ),
                        ),
                      ));
                },
                itemCount: downloadMovies.length,
              ))
            ],
          ));
    }
  }
}
