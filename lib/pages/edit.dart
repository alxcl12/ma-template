import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:non_native/database_helper.dart';
import 'package:non_native/domain/data.dart';
import 'package:non_native/rest/api_client.dart';

class EditScreen extends StatefulWidget {
  final BoardGame entity;
  const EditScreen({Key? key, required this.entity}) : super(key: key);

  @override
  _EditScreenState createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  final nameController = TextEditingController();
  final priceController = TextEditingController();
  final minAgeController = TextEditingController();
  final maxAgeController = TextEditingController();
  final publisherController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    BoardGame boardGame = widget.entity;
    nameController.text = boardGame.name;
    priceController.text = boardGame.price.toString();
    minAgeController.text = boardGame.minAge.toString();
    maxAgeController.text = boardGame.maxAge.toString();
    publisherController.text = boardGame.publisher;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit"),
        centerTitle: true,
      ),
      body: (_isLoading)
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 0.0, horizontal: 40.0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 50.0, horizontal: 10.0),
                    child: Column(children: [
                      TextField(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Name",
                        ),
                        controller: nameController,
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Price",
                        ),
                        controller: priceController,
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Min Age",
                        ),
                        controller: minAgeController,
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Max Age",
                        ),
                        controller: maxAgeController,
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Publisher",
                        ),
                        controller: publisherController,
                      ),
                      const SizedBox(height: 48),
                      ElevatedButton(
                          onPressed: () {
                            _onClickEdit();
                          },
                          child: const Text("Edit"))
                    ]),
                  ),
                ],
              ),
            ),
    );
  }

  _onClickEdit() async {
    final client = ApiClient(Dio(BaseOptions(contentType: "application/json")));
    final BoardGame entity = BoardGame(
        id: widget.entity.id,
        name: nameController.text,
        price: int.parse(priceController.text),
        minAge: int.parse(minAgeController.text),
        maxAge: int.parse(maxAgeController.text),
        publisher: publisherController.text);
    bool local = false;
    developer.log("Before edit call, id: ${widget.entity.id!}");

    setState(() {
      _isLoading = true;
    });

    var result = await client
        .update(entity, widget.entity.id!)
        .timeout(const Duration(milliseconds: 1000))
        .catchError((Object obj) async {
      switch (obj.runtimeType) {
        case DioError:
          final res = (obj as DioError).response;
          developer
              .log("Got error : ${res!.statusCode} -> ${res.statusMessage}");
          _showErrorDialog(context, "Error editing entity.");
          break;
        case TimeoutException:
          Fluttertoast.showToast(
              msg: "Server did not respond, going local.",
              toastLength: Toast.LENGTH_SHORT);

          var responseDb = await DatabaseHelper.instance.update(entity);
          if (responseDb == 1) {
            local = true;
          } else {
            _showErrorDialog(context, "Error editing entity in local DB.");
          }

          break;
        default:
          break;
      }
      return Future<BoardGame>.value(entity);
    });

    developer.log("After edit call, id: ${widget.entity.id!}");
    _isLoading = false;

    ReturnedFromPop returned;
    if (local) {
      returned = ReturnedFromPop(entity, 0, true);
    } else {
      returned = ReturnedFromPop(result, 0, false);
    }

    Fluttertoast.showToast(
        msg: "Edited entity.", toastLength: Toast.LENGTH_SHORT);
    Navigator.pop(context);
    Navigator.pop(context, returned);
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
