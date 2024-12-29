import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app_state.dart' as appState;
import 'home_page.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => appState.AppState(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fitness Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}
