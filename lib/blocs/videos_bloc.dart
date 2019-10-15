import 'dart:async';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:youtube_favorite/api.dart';
import 'package:youtube_favorite/models/video.dart';

class VideosBloc implements BlocBase {
  Api api;
  List<Video> videos;

  final _videosController = StreamController<List<Video>>();
  Stream get outVideos => _videosController.stream;

  final _searchController = StreamController<String>();
  Sink get inSearch => _searchController.sink;

  VideosBloc() {
    api = Api();
    _searchController.stream.listen(_search);
  }

  @override
  void addListener(listener) {}

  @override
  void dispose() {
    _videosController.close();
    _searchController.close();
  }

  @override
  bool get hasListeners => null;

  @override
  void notifyListeners() {}

  @override
  void removeListener(listener) {}

  void _search(String search) async {
    if (search != null) {
      _videosController.sink.add([]);
      videos = await api.search(search);
    } else {
      videos += await api.nextPage();
    }

    _videosController.sink.add(videos);
  }
}
