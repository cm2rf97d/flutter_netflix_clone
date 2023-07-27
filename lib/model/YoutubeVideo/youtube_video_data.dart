class YoutubeVideoData {
  List<SubYoutubeVideoData> subData;

  YoutubeVideoData({required this.subData});

  factory YoutubeVideoData.fromJson(Map<String, dynamic> json) {
    var list = json['items'] as List;
    List<SubYoutubeVideoData> youtubeVideoData =
        list.map((i) => SubYoutubeVideoData.fromJson(i)).toList();
    return YoutubeVideoData(subData: youtubeVideoData);
  }
}

class SubYoutubeVideoData {
  final SubSubYoutubeVideoData id;

  SubYoutubeVideoData({required this.id});

  factory SubYoutubeVideoData.fromJson(Map<String, dynamic> json) =>
      SubYoutubeVideoData(id: SubSubYoutubeVideoData.fromJson(json['id']));
}

class SubSubYoutubeVideoData {
  final String kind;
  final String videoId;

  SubSubYoutubeVideoData({required this.kind, required this.videoId});

  factory SubSubYoutubeVideoData.fromJson(Map<String, dynamic> json) =>
      SubSubYoutubeVideoData(
          kind: json['kind'] ?? "", videoId: json['videoId'] ?? "");
}
