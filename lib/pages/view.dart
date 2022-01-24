import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:non_native/domain/boardgame.dart';
import 'dart:developer' as developer;
import 'package:http/http.dart' as http;

class ViewScreen extends StatefulWidget {
  const ViewScreen({Key? key}) : super(key: key);

  @override
  State<ViewScreen> createState() => _ViewScreenState();
}

class _ViewScreenState extends State<ViewScreen> {
  late int id;

  Future<BoardGame> _getBg() async {
    id = ModalRoute.of(context)!.settings.arguments as int;

    developer.log("Before get bg call, id: ${id}");
    final http.Response response = await http.get(
      Uri.parse('http://10.0.2.2:5000/bg/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    developer.log("After get bg call, response: ${response.statusCode}");
    BoardGame boardGame;

    if (response.statusCode == 200) {
      boardGame = BoardGame.fromJson(jsonDecode(response.body));
      return boardGame;
    } else {
      _showErrorDialog(context, response.statusCode.toString());
      return Future.error("err");
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _getBg(),
        builder: (context, AsyncSnapshot<BoardGame> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              BoardGame boardGame = snapshot.data!;
              return Scaffold(
                appBar: AppBar(
                  title: const Text("Board game"),
                  centerTitle: true,
                ),
                body: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 64.0, horizontal: 40.0),
                  child: Column(
                    children: [
                      Text(
                        "Name:  ${boardGame.name}",
                        textAlign: TextAlign.left,
                        style: const TextStyle(fontSize: 20),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Price:  ${boardGame.price}",
                        textAlign: TextAlign.left,
                        style: const TextStyle(fontSize: 20),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Min Age:  ${boardGame.minAge}",
                        textAlign: TextAlign.left,
                        style: const TextStyle(fontSize: 20),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Max Age:  ${boardGame.maxAge}",
                        textAlign: TextAlign.left,
                        style: const TextStyle(fontSize: 20),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Publisher:  ${boardGame.publisher}",
                        textAlign: TextAlign.left,
                        style: const TextStyle(fontSize: 20),
                      ),
                      const SizedBox(height: 48),
                      Row(
                        children: [
                          ElevatedButton(
                              onPressed: () {
                                _showAlertDialog(context, id);
                              },
                              child: const Text("Delete")),
                          const SizedBox(width: 32),
                          ElevatedButton(
                              onPressed: () {
                                Navigator.pushNamed(context, '/edit',
                                        arguments: boardGame.id)
                                    .then((value) {
                                  setState(() {
                                    _getBg();
                                  });
                                });
                              },
                              child: const Text("Edit"))
                        ],
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                      )
                    ],
                  ),
                ),
              );
            } else {
              return _showErrorDialog(
                  context, "Error fetching bg from server!");
            }
          } else {
            return const CircularProgressIndicator();
          }
        });
  }

  _showAlertDialog(BuildContext context, int id) {
    Widget cancelButton = TextButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = TextButton(
      child: Text("Continue"),
      onPressed: () async {
        developer.log("Before delete call, id: $id");
        final http.Response response = await http.delete(
          Uri.parse('http://10.0.2.2:5000/bg/$id'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
        );
        developer.log("After delete call, response: ${response.statusCode}");

        if (response.statusCode == 200) {
          Fluttertoast.showToast(
              msg: "Deleted board game", toastLength: Toast.LENGTH_SHORT);
          Navigator.pop(context);
          Navigator.pop(context);
        } else {
          _showErrorDialog(context, response.statusCode.toString());
        }
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text("Confirmation"),
      content: Text("Delete board game?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
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
