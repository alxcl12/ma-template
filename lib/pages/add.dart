import 'dart:convert';
import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:non_native/database_helper.dart';
import 'package:non_native/domain/boardgame.dart';
import 'package:http/http.dart' as http;

class AddBoardGameScreen extends StatefulWidget {
  const AddBoardGameScreen({Key? key}) : super(key: key);

  @override
  State<AddBoardGameScreen> createState() => _AddBoardGameScreenState();
}

class _AddBoardGameScreenState extends State<AddBoardGameScreen> {
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
          children:  [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 50.0, horizontal: 10.0),
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
                      child: const Text("Add Board Game")
                  ),
                ],
              ),
            )
          ],
        ),
      )
    );
  }

  _onClickSave(BuildContext context) async {
    developer.log("Before add bg call, name: ${nameController.text}, price: ${priceController.text}");

    final http.Response response = await http.post(
        Uri.parse('http://10.0.2.2:5000/bg'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'name': nameController.text,
          'price': priceController.text,
          'minAge': minAgeController.text,
          'maxAge': maxAgeController.text,
          'publisher': publisherController.text
        }),
      );

    developer.log("After add bg call, response: ${response.statusCode}");

    if(response.statusCode == 200){
      Fluttertoast.showToast(msg: "Added board game", toastLength: Toast.LENGTH_SHORT);
      Navigator.pop(context);
    }
    else{
      _showErrorDialog(context, response.statusCode.toString());
      BoardGame bg = BoardGame.withoutId(
          nameController.text,
          int.parse(priceController.text),
          int.parse(minAgeController.text),
          int.parse(maxAgeController.text),
          publisherController.text);

      try {
        await DatabaseHelper.instance.addBoardGame(bg);
      }
      on Exception catch(e){
        _showErrorDialog(context, e.toString());
      }
      Fluttertoast.showToast(msg: "Added board game locally!!", toastLength: Toast.LENGTH_SHORT);
      Navigator.pop(context);
    }
  }

  _showErrorDialog(BuildContext context, String err){
    Widget cancelButton = TextButton(
      child: Text("Ok"),
      onPressed:  () {
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
