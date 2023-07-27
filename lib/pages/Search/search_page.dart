import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:netflix_sample/model/Movie/movie_data.dart';

import '../../model/Movie/movie_state.dart';
import '../MovieDetail/movie_detail_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPage();
}

class _SearchPage extends State<SearchPage> {
  final TextEditingController _controller = TextEditingController();
  bool _isLoading = false;
  List<SubMovieData> _movies = [];

  @override
  void initState() {
    super.initState();
    _fetchMovie();
  }

  void _fetchMovie() async {
    setState(() {
      _isLoading = true;
    });

    var movies = await MovieState().fetchMovie(FetchMovieType.popular, '');
    _movies = movies;

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _searchMovieOrTV(String query) async {
    if (query.length <= 3) {
      return;
    }

    var movies =
        await MovieState().fetchMovie(FetchMovieType.search, '', query);
    movies.removeWhere((item) => item.posterPath == '');
    setState(() {
      _movies = movies;
    });
  }

  @override
  Widget build(BuildContext context) {
    if(_isLoading) {
      Size deviceScreen = MediaQuery.of(context).size;
      return Container(color: Colors.black, child: SizedBox(
        // Loading 動畫
          height: deviceScreen.height,
          width: deviceScreen.width,
          child: const Center(child: CircularProgressIndicator())));
    } else {
      return Container(
          color: Colors.black,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Center(
                    child: SizedBox(
                      height: 40,
                      child: TextField(
                        onChanged: (String value) async {
                          _searchMovieOrTV(value);
                        },
                        controller: _controller,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.symmetric(vertical: 0.0),
                          enabledBorder: OutlineInputBorder( // 變更'未'點選 TextField時 的外框線顏色
                              borderSide:
                              BorderSide(color: Colors.white, width: 1.0)),
                          focusedBorder: OutlineInputBorder( // 變更點選 TextField時 的外框線顏色
                              borderSide:
                              BorderSide(color: Colors.white, width: 1.0)),
                          prefixIcon: Icon(Icons.search, color: Colors.white),
                          filled: true,
                          fillColor: Color(0x2C2C2C00),
                          hintText: 'Search',
                        ),
                      ),
                    )),
              ),
              const SizedBox(height: 5),
              Expanded(
                child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: GridView.builder( // iOS的 CollectionView
                        gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          childAspectRatio: 0.7, // 將長寬比改變
                          crossAxisCount: 3, // 橫向保持3個item
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                        ),
                        itemCount: _movies.length,
                        itemBuilder: (context, index) {
                          String imageUrl = _movies[index].posterPath;
                          return InkWell(
                            // 點擊後導向 電影細節頁面
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
                            child: Image.network(
                                'https://image.tmdb.org/t/p/w500$imageUrl',
                                fit: BoxFit.fill, frameBuilder: (context, child,
                                frame, wasSynchronouslyLoaded) {
                              if (wasSynchronouslyLoaded) {
                                return child;
                              }
                              return AnimatedOpacity(
                                  opacity: frame == null ? 0 : 1,
                                  duration: const Duration(seconds: 1),
                                  curve: Curves.easeOut,
                                  child: child);
                            }),
                          );
                        })),
              ),
            ],
          ));
    }
  }
}
