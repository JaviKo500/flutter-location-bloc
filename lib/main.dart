import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:app_maps/blocs/blocs.dart';
import 'package:app_maps/screens/screens.dart';

void main() {
  runApp( MultiBlocProvider(
    providers: [
      BlocProvider( create: (context) => GpsBloc() ),
      BlocProvider( create: (context) => LocationBloc() ),
      BlocProvider( create: (context) => MapBloc() ),
    ],
    child: const MapsApp(),
  ) );
} 

class MapsApp extends StatelessWidget {

  const MapsApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Maps App',
      debugShowCheckedModeBanner: false,
      home: LoadingScreen()
    );
  }
}