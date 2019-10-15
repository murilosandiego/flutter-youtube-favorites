import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:youtube_favorite/blocs/favorite_bloc.dart';
import 'package:youtube_favorite/screens/home.dart';

import 'blocs/videos_bloc.dart';

Future main() async {
  await DotEnv().load('.env');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      blocs: [
        Bloc((i) => VideosBloc()),
        Bloc((i) => FavoriteBloc()),
      ],
      child: MaterialApp(
        title: 'FlutterTube',
        theme: ThemeData(),
        home: Home(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
