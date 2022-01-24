import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:non_native/domain/data.dart';
import 'dart:developer' as developer;
import 'package:http/http.dart' as http;
import 'package:non_native/pages/view.dart';
import 'package:non_native/rest/api_client.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<BoardGame> _list = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Board Games"),
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            var result = await Navigator.pushNamed(context, '/add');
            if(result != null){
              setState(() {
                _list.add(result as BoardGame);
              });
            }
          },
          child: const Icon(Icons.add),
        ),
        body: (_list.isEmpty) ? _buildBody(context) : _buildListView(context)
    );
  }

  FutureBuilder<List<BoardGame>> _buildBody(BuildContext context) {
    final client = ApiClient(Dio(BaseOptions(contentType: "application/json")));
    developer.log("Before get all call");
    return FutureBuilder<List<BoardGame>>(
        future: client.getAll(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            developer.log("After get all call");

            final List<BoardGame>? posts = snapshot.data;
            _list = posts!;

            return _buildListView(context);
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }

  Widget _buildListView(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 3.0),
          child: Card(
            child: ListTile(
              onTap: () async {
                var result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            ViewScreen(entity: _list[index])));
                if(result != null){
                  var returned = result as ReturnedFromPop;
                  var entity = returned.entity;

                  if(returned.type == 0) {
                    var index = _list.indexWhere((element) =>
                    element.id == entity.id);
                    setState(() {
                      _list.replaceRange(index, index + 1, [entity]);
                    });
                  }
                  else{
                    setState(() {
                      _list.removeWhere((element) => element.id == entity.id);
                    });
                  }
                }
              },
              title: Text(_list[index].name),
            ),
          ),
        );
      },
      itemCount: _list.length,
    );
  }

  _showErrorDialog(BuildContext context, String err) {
    Widget cancelButton = TextButton(
      child: Text("Ok"),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text("Error"),
      content: Text(err),
      actions: [
        cancelButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
