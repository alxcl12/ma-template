import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:non_native/domain/data.dart';
import 'dart:developer' as developer;
import 'package:http/http.dart' as http;
import 'package:non_native/rest/api_client.dart';

import 'edit.dart';

class ViewScreen extends StatefulWidget {
  final BoardGame entity;
  const ViewScreen({Key? key, required this.entity}) : super(key: key);

  @override
  State<ViewScreen> createState() => _ViewScreenState();
}

class _ViewScreenState extends State<ViewScreen> {
  @override
  Widget build(BuildContext context) {
    BoardGame boardGame = widget.entity;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Board game"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 64.0, horizontal: 40.0),
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
      child: Text("Cancel"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = TextButton(
      child: Text("Continue"),
      onPressed: () {
        final client =
            ApiClient(Dio(BaseOptions(contentType: "application/json")));

        developer.log("Before delete call, id: $id");
        client.delete(id);
        developer.log("After delete call, id: $id");

        var returned = ReturnedFromPop(widget.entity, 1);

        Fluttertoast.showToast(
            msg: "Deleted board game", toastLength: Toast.LENGTH_SHORT);
        Navigator.pop(context);
        Navigator.pop(context, returned);
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
