import 'package:flutter/material.dart';
import 'package:non_native/pages/edit.dart';
import 'package:non_native/pages/view.dart';
import 'pages/home.dart';
import 'pages/add.dart';



void main() {
  runApp(MaterialApp(
    routes: {
      '/': (context) => BoardGamesScreen(),
      '/add': (context) => AddBoardGameScreen(),
      '/boardGame': (context) => BoardGameView(),
      '/editBoardGame': (context) => BoardGameEditScreen()
    },
  ));
}

