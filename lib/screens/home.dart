import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:youtube_favorite/blocs/favorite_bloc.dart';
import 'package:youtube_favorite/blocs/videos_bloc.dart';
import 'package:youtube_favorite/delegates/data_search.dart';
import 'package:youtube_favorite/models/video.dart';
import 'package:youtube_favorite/screens/favorites.dart';
import 'package:youtube_favorite/widget/video_tile.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final VideosBloc videosBloc = BlocProvider.getBloc<VideosBloc>();
    final FavoriteBloc favoriteBloc = BlocProvider.getBloc<FavoriteBloc>();

    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        title: Container(
          height: 33,
          child: Image.asset('images/logo_yt.png'),
        ),
        elevation: 0,
        backgroundColor: Colors.black87,
        centerTitle: false,
        actions: <Widget>[
          Align(
            alignment: Alignment.center,
            child: StreamBuilder<Map<String, Video>>(
                initialData: {},
                stream: favoriteBloc.outFav,
                builder: (context, snapshot) {
                  if (snapshot.hasData) return Text('${snapshot.data.length}');
                  return Container();
                }),
          ),
          IconButton(
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => Favorites()));
            },
            icon: Icon(Icons.star),
          ),
          IconButton(
            onPressed: () async {
              String result =
                  await showSearch(context: context, delegate: DataSearch());
              if (result != null) {
                videosBloc.inSearch.add(result);
              }
            },
            icon: Icon(Icons.search),
          )
        ],
      ),
      body: StreamBuilder(
        initialData: [],
        stream: videosBloc.outVideos,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Container();
          return ListView.builder(
            itemBuilder: (BuildContext context, int index) {
              if (index < snapshot.data.length) {
                return VideoTile(snapshot.data[index]);
              } else if (index > 1) {
                videosBloc.inSearch.add(null);
                return Container(
                  height: 40,
                  width: 40,
                  alignment: Alignment.center,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                  ),
                );
              } else {
                return Container();
              }
            },
            itemCount: snapshot.data.length + 1,
          );
        },
      ),
    );
  }
}
