import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:netflix_sample/database/movie_manager.dart';
import 'package:netflix_sample/model/YoutubeVideo/youtube_video_data.dart';
import 'package:netflix_sample/model/YoutubeVideo/youtube_video_state.dart';
import 'package:webview_flutter/webview_flutter.dart';

// Import for Android features.
import 'package:webview_flutter_android/webview_flutter_android.dart';

// Import for iOS features.
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

import '../../model/Movie/movie_data.dart';

class MovieDetailPage extends StatefulWidget {
  final SubMovieData movie;

  const MovieDetailPage({super.key, required this.movie});

  @override
  State<MovieDetailPage> createState() => _MoviewDetailPage();
}

class _MoviewDetailPage extends State<MovieDetailPage> {
  bool _isLoading = false;
  late WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _fetchYoutubeVideo();
  }

  void _fetchYoutubeVideo() async {
    setState(() {
      _isLoading = true;
    });

    var youtubeVideos =
        await YoutubeVideoState().fetchMovie(widget.movie.originalTitle);

    String videoUrl = youtubeVideos[0].id.videoId;
    late final WebViewController controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(onPageFinished: (finish) {
          setState(() {
            _isLoading = false;
          });
        }),
      )
      ..loadRequest(Uri.parse('https://www.youtube.com/embed/$videoUrl'));

    if (mounted) {
      setState(() {
        _controller = controller;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size deviceScreen = MediaQuery.of(context).size;
    return SingleChildScrollView(
        child: Container(
            color: Colors.black,
            child:
            _isLoading
                ? SizedBox(
                    height: deviceScreen.height,
                    width: deviceScreen.width,
                    child: const Center(child: CircularProgressIndicator()))
                :
            Column(
                    children: [
                      SizedBox(
                        height: 300,
                        child: WebViewWidget(controller: _controller),
                        // child: Text('1'),
                      ),
                      const SizedBox(height: 20),
                      Container(
                          alignment: Alignment.topLeft,
                          padding: const EdgeInsets.only(left: 10),
                          child: Text(widget.movie.originalTitle,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 28,
                                  fontWeight: FontWeight.w800))),
                      const SizedBox(height: 20),
                      Container(
                          padding: const EdgeInsets.all(10),
                          child: Text(
                            widget.movie.overview,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w400),
                          )),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            elevation: 9.0,
                            textStyle: const TextStyle(fontSize: 20),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12))),
                        onPressed: () {
                          showAlertDialog(context);
                          MovieManager.instance.insert(widget.movie);
                        },
                        child: const Text('Download'),
                      ),
                    ],
                  )));
  }
}

showAlertDialog(BuildContext context) {
  // Init
  AlertDialog dialog = AlertDialog(
    title: Text("下載完成"),
    actions: [
      ElevatedButton(
          child: Text("OK"),
          onPressed: () {
            Navigator.pop(context);
          }
      ),
    ],
  );

  // Show the dialog
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return dialog;
      }
  );
}