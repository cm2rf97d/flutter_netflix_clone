import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:netflix_sample/model/YoutubeVideo/youtube_video_data.dart';
import '../../KEY/key.dart';

class YoutubeVideoState extends ChangeNotifier {
  final String defaultUrl = 'https://youtube.googleapis.com/youtube/v3/search';

  List<SubYoutubeVideoData> subYoutubeVideoData = [
    SubYoutubeVideoData(id: SubSubYoutubeVideoData(kind: '', videoId: ''))
  ];

  Future<List<SubYoutubeVideoData>> fetchMovie(String movieName) async {
    final Completer<List<SubYoutubeVideoData>> completer = Completer();

    Uri url = Uri.parse('$defaultUrl?q=$movieName&key=$yotubeApiKey');

    final response = await http.get(url, headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    });

    final parsedResponse = json.decode(response.body) as Map<String, dynamic>;
    var movieData = YoutubeVideoData.fromJson(parsedResponse);
    subYoutubeVideoData = movieData.subData;
    completer.complete(subYoutubeVideoData);
    return completer.future;
  }
}
