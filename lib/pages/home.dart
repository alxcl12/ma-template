import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:non_native/domain/boardgame.dart';
import 'dart:developer' as developer;
import 'package:http/http.dart' as http;

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<BoardGame> _list = [];

  @override
  void initState() {
    super.initState();
    _getList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Board Games"),
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, '/add').then((value) {
              setState(() {
                _getList();
              });
            });
          },
          child: Icon(Icons.add),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 45.0, horizontal: 40.0),
          child: ListView.builder(
            itemCount: _list.length,
            itemBuilder: (context, index) {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 5.0, horizontal: 3.0),
                child: Card(
                  child: ListTile(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        '/view',
                        arguments: _list[index].id,
                      ).then((value) {
                        setState(() {
                          _getList();
                        });
                      });
                    },
                    title: Text(_list[index].name),
                  ),
                ),
              );
            },
          ),
        ));
  }

  List<BoardGame> _decodeBg(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<BoardGame>((json) => BoardGame.fromMap(json)).toList();
  }

  _getList() async {
    List<BoardGame> list = [];
    developer.log("Before get all bg call");
    final http.Response response = await http.get(
      Uri.parse('http://10.0.2.2:5000/bg'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    developer.log("After get all bg call, response ${response.statusCode}");

    if (response.statusCode == 200) {
      list = _decodeBg(response.body);
    } else {
      _showErrorDialog(context, response.statusCode.toString());
    }

    setState(() {
      _list = list;
    });
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
