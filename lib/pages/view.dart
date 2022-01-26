import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:non_native/domain/data.dart';
import 'dart:developer' as developer;
import 'package:non_native/rest/api_client.dart';

import '../database_helper.dart';
import 'edit.dart';

class ViewScreen extends StatefulWidget {
  final BoardGame entity;
  const ViewScreen({Key? key, required this.entity}) : super(key: key);

  @override
  State<ViewScreen> createState() => _ViewScreenState();
}

class _ViewScreenState extends State<ViewScreen> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    BoardGame boardGame = widget.entity;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Board game"),
        centerTitle: true,
      ),
      body: (_isLoading)
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 64.0, horizontal: 40.0),
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
                            _showDeleteDialog(context, boardGame.id!);
                          },
                          child: const Text("Delete")),
                      const SizedBox(width: 32),
                      ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        EditScreen(entity: widget.entity)));
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
  }

  _showDeleteDialog(BuildContext context, int id) {
    Widget cancelButton = TextButton(
      child: const Text("Cancel"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = TextButton(
      child: const Text("Continue"),
      onPressed: () async {
        final client =
            ApiClient(Dio(BaseOptions(contentType: "application/json")));

        bool local = false;
        developer.log("Before delete call, id: $id");

        setState(() {
          _isLoading = true;
        });
        var result = await client
            .delete(id)
            .timeout(const Duration(milliseconds: 1000))
            .catchError((Object obj) async {
          switch (obj.runtimeType) {
            case DioError:
              final res = (obj as DioError).response;
              developer.log(
                  "Got error : ${res!.statusCode} -> ${res.statusMessage}");
              _showErrorDialog(context, "Error deleting entity.");
              break;
            case TimeoutException:
              Fluttertoast.showToast(
                  msg: "Server did not respond, going local.",
                  toastLength: Toast.LENGTH_SHORT);

              var responseDb = await DatabaseHelper.instance.delete(id);
              if (responseDb == 1) {
                local = true;
              } else {
                _showErrorDialog(context, "Error editing entity in local DB.");
              }

              break;
            default:
              break;
          }
          return Future<void>.value();
        });

        developer.log("After delete call, id: $id");
        setState(() {
          _isLoading = false;
        });

        ReturnedFromPop returned;
        if (local) {
          returned = ReturnedFromPop(widget.entity, 0, true);
        } else {
          returned = ReturnedFromPop(widget.entity, 0, false);
        }

        Fluttertoast.showToast(
            msg: "Deleted board game", toastLength: Toast.LENGTH_SHORT);
        Navigator.pop(context);
        Navigator.pop(context, returned);
      },
    );

    AlertDialog alert = AlertDialog(
      title: const Text("Confirmation"),
      content: const Text("Delete board game?"),
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
      child: const Text("Ok"),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    AlertDialog alert = AlertDialog(
      title: const Text("Error"),
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
