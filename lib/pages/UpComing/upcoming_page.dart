import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:netflix_sample/pages/UpComing/upcoming_page_listview.dart';
import '../../model/Movie/movie_data.dart';
import '../../model/Movie/movie_state.dart';

class UpComingPage extends StatefulWidget {
  final String fetchCategory;

  const UpComingPage({super.key, required this.fetchCategory});

  @override
  State<UpComingPage> createState() => _UpComingPage();
}

class _UpComingPage extends State<UpComingPage> {
  late final String _fetchCategory;
  bool _isLoading = false;
  List<SubMovieData> _movies = [];

  @override
  void initState() {
    super.initState();
    _fetchCategory = widget.fetchCategory; // 由於 createState() 不要帶參數比較好，因此在 initState() 內取得.
    _fetchMovie();
  }

  void _fetchMovie() async {
    setState(() {
      _isLoading = true;
    });

    var movies = await MovieState().fetchMovie(FetchMovieType.regular, _fetchCategory);

    this._movies = movies;

    if (mounted) { // 確認API的結果回來時，該頁面還沒有被dispose.
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size deviceScreen = MediaQuery.of(context).size;

    if (_isLoading) {
      return SizedBox(
          height: deviceScreen.height,
          width: deviceScreen.width,
          child: const Center(child: CircularProgressIndicator()));
    } else {
      return UpComingPageListView(movies: _movies,);
    }
  }
}
