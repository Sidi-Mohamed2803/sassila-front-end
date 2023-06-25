// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, non_constant_identifier_names

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sassila_mobile_ui/modeles/Individu.dart';
import 'package:sassila_mobile_ui/pages/individu_page.dart';

class FaceRecognitionResults extends StatefulWidget {
  Individu individu;
  double confidence;
  List<Individu> list;
  FaceRecognitionResults(
      {Key? key,
      required this.individu,
      required this.confidence,
      required this.list})
      : super(key: key);

  @override
  State<FaceRecognitionResults> createState() => _FaceRecognitionResultsState();
}

class _FaceRecognitionResultsState extends State<FaceRecognitionResults> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        elevation: 0,
        title: Text('Résultats de recherche'),
        centerTitle: true,
        actions: [],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${widget.individu.prenom} ${widget.individu.nom} correspond à ${widget.confidence}% au visage soumis.',
              style: TextStyle(
                fontSize: 25,
              ),
              textAlign: TextAlign.center,
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.memory(
                  base64Decode(widget.individu.imageUrl),
                  fit: BoxFit.cover,
                  width: MediaQuery.of(context).size.width,
                  height: 300,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () => {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => IndividuPage(
                      id: widget.individu.id,
                      list: widget.list,
                    ),
                  ),
                ),
              },
              child: Text(
                'Voir ${widget.individu.prenom}',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
