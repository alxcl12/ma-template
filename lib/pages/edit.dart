import 'dart:convert';
import 'dart:developer' as developer;
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:non_native/domain/data.dart';
import 'package:http/http.dart' as http;
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
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 40.0),
        child: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 50.0, horizontal: 10.0),
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
    client.update(entity, widget.entity.id!);
    Fluttertoast.showToast(
        msg: "Edited entity.", toastLength: Toast.LENGTH_SHORT);
    Navigator.pop(context);
    Navigator.pop(context);

    // developer.log("Before patch call");
    // final http.Response response = await http.patch(
    //   Uri.parse('http://10.0.2.2:5000/bg/${widget.entity.id}'),
    //   headers: <String, String>{
    //     'Content-Type': 'application/json; charset=UTF-8',
    //   },
    //   body: jsonEncode(<String, String>{
    //     'name': nameController.text,
    //     'price': priceController.text,
    //     'minAge': minAgeController.text,
    //     'maxAge': maxAgeController.text,
    //     'publisher': publisherController.text
    //   }),
    // );
    // developer.log("After patch call, response: ${response.statusCode}");
    // if (response.statusCode == 200) {
    //   Fluttertoast.showToast(
    //       msg: "Edited entity.", toastLength: Toast.LENGTH_SHORT);
    //   Navigator.pop(context);
    //   Navigator.pop(context);
    // } else {
    //   _showErrorDialog(context, response.statusCode.toString());
    // }
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
