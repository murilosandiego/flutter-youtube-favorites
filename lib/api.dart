import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:youtube_favorite/models/video.dart';

final API_KEY = DotEnv().env['API_KEY'];

class Api {
  String _search;
  String _nextToken;

  Future<List<Video>> search(String search) async {
    _search = search;

    http.Response response = await http.get(
        "https://www.googleapis.com/youtube/v3/search?part=snippet&q=$search&type=video&key=$API_KEY&maxResults=10");

    return decode(response);
  }

  Future<List<Video>> nextPage() async {
    http.Response response = await http.get(
        "https://www.googleapis.com/youtube/v3/search?part=snippet&q=$_search&type=video&key=$API_KEY&maxResults=10&pageToken=$_nextToken");

    return decode(response);
  }

  List<Video> decode(http.Response response) {
    if (response.statusCode != 200) {
      throw Exception('Failed to load videos');
    }

    var decoded = json.decode(response.body);

    _nextToken = decoded['nextPageToken'];

    List<Video> videos = decoded['items'].map<Video>((map) {
      return Video.fromJson(map);
    }).toList();

    return videos;
  }
}
