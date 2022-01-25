import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:non_native/database_helper.dart';
import 'package:non_native/domain/data.dart';
import 'dart:developer' as developer;
import 'package:http/http.dart' as http;
import 'package:non_native/pages/view.dart';
import 'package:non_native/rest/api_client.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<BoardGame> _list = [];
  final _channel = WebSocketChannel.connect(
    Uri.parse("ws://10.0.2.2:3000"),
  );

  @override
  void initState() {
    super.initState();
    _channel.stream.listen((event) {
      var entity = event as BoardGame;
      log("New entity received from ws, id: ${entity.id}");

      bool insert = true;
      for (var item in _list) {
        if (item.id == entity.id) {
          insert = false;
          break;
        }
      }
      if (insert) {
        setState(() {
          _list.add(entity);
        });
        Fluttertoast.showToast(
            msg: "New entity came from the server.",
            toastLength: Toast.LENGTH_SHORT);
      }
    });
  }

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
            if (result != null) {
              result as ReturnedFromPop;
              setState(() {
                _list.add(result.entity);
              });
              if(!result.local){
                //TODO
                DatabaseHelper.instance.add(result.entity);
              }
            }
          },
          child: const Icon(Icons.add),
        ),
        body: (_list.isEmpty) ? _buildBody(context) : _buildListView(context));
  }

  FutureBuilder<List<BoardGame>> _buildBody(BuildContext context) {
    final client = ApiClient(Dio(BaseOptions(contentType: "application/json")));
    developer.log("Before get all call");
    return FutureBuilder<List<BoardGame>>(
        future: client.getAll().timeout(const Duration(seconds: 3)),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            developer.log("After get all call");

            if (!snapshot.hasError) {
              final List<BoardGame>? posts = snapshot.data;
              _list = posts!;
              DatabaseHelper.instance.deleteDatabase();
              for(var item in _list){
                //TODO
                DatabaseHelper.instance.add(item);
              }
            } else {
              _list = [];
              Future.delayed(const Duration(milliseconds: 500), () {
                _showRetryDialog(context,
                    "Server did not respond. Make sure you are connected to the internet.");
              });
            }
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
            child: Column(
              children: [
                ListTile(
                  onTap: () async {
                    var result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                ViewScreen(entity: _list[index])));
                    if (result != null) {
                      var returned = result as ReturnedFromPop;
                      var entity = returned.entity;

                      if (returned.type == 0) {
                        var index = _list
                            .indexWhere((element) => element.id == entity.id);
                        setState(() {
                          _list.replaceRange(index, index + 1, [entity]);
                        });

                        if(!returned.local){
                          //TODO
                          DatabaseHelper.instance.update(entity);
                        }
                      } else {
                        setState(() {
                          _list.removeWhere(
                              (element) => element.id == entity.id);
                        });

                        if(!returned.local){
                          //TODO
                          DatabaseHelper.instance.delete(entity.id!);
                        }
                      }
                    }
                  },
                  title: Text(_list[index].name),
                  subtitle: Text("Price: " + _list[index].price.toString()),
                ),
                Text(_list[index].publisher, textAlign: TextAlign.left),
              ],
            ),
          ),
        );
      },
      itemCount: _list.length,
    );
  }

  _showRetryDialog(BuildContext context, String err) {
    Widget retryButton = TextButton(
      child: const Text("Retry"),
      onPressed: () {
        Navigator.pop(context);
        setState(() {});
      },
    );

    Widget cancelButton = TextButton(
      child: const Text("Cancel"),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    AlertDialog alert = AlertDialog(
      title: const Text("Error"),
      content: Text(err),
      actions: [
        retryButton,
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

  @override
  void dispose() {
    super.dispose();
    _channel.sink.close();
    DatabaseHelper.instance.deleteDatabase();
  }
}
