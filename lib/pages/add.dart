import 'dart:convert';
import 'dart:developer' as developer;
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:non_native/database_helper.dart';
import 'package:non_native/domain/data.dart';
import 'package:http/http.dart' as http;
import 'package:non_native/rest/api_client.dart';

class AddScreen extends StatefulWidget {
  const AddScreen({Key? key}) : super(key: key);

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  final nameController = TextEditingController();
  final priceController = TextEditingController();
  final minAgeController = TextEditingController();
  final maxAgeController = TextEditingController();
  final publisherController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Add board game"),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 40.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 50.0, horizontal: 10.0),
                child: Column(
                  children: [
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
                          _onClickSave(context);
                        },
                        child: const Text("Add Board Game")),
                  ],
                ),
              )
            ],
          ),
        ));
  }

  _onClickSave(BuildContext context) async {
    final client = ApiClient(Dio(BaseOptions(contentType: "application/json")));
    final BoardGame entity = BoardGame(
        id: null,
        name: nameController.text,
        price: int.parse(priceController.text),
        minAge: int.parse(minAgeController.text),
        maxAge: int.parse(maxAgeController.text),
        publisher: publisherController.text);

    developer.log("Before add call");
    var result = client.add(entity);
    developer.log("After add call");

    Fluttertoast.showToast(
        msg: "Added entity", toastLength: Toast.LENGTH_SHORT);
    Navigator.pop(context, result);
  }
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
