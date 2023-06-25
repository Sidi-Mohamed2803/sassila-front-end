// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:convert';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sassila_mobile_ui/modeles/Femme.dart';
import 'package:sassila_mobile_ui/modeles/Homme.dart';
import 'package:sassila_mobile_ui/pages/facial_recognition_page.dart';
import 'package:sassila_mobile_ui/pages/individu_page.dart';
import 'package:sassila_mobile_ui/widgets/alphabet_scroll_widget.dart';
import 'package:sassila_mobile_ui/modeles/Individu.dart';
import 'package:http/http.dart' as http;
import 'package:speech_to_text/speech_to_text.dart';

class Membres extends StatefulWidget {
  const Membres({Key? key}) : super(key: key);
  static String routeName = 'membres';

  @override
  State<Membres> createState() {
    return _MembresState();
  }
}

class _MembresState extends State<Membres> {
  List<Individu> individus = [];
  List<Individu> matchedIndividus = [];
  TextEditingController textController = TextEditingController();
  final SpeechToText _speechToText = SpeechToText();
  bool isListening = false;
  String _recognizedWords = '';
  // String baseUrl = 'localhost:3000';
  // String baseUrl = '10.30.2.172:3000';
  String baseUrl = '192.168.1.21:3000';
  // String baseUrl = '192.168.0.174:3000';
  // String baseUrl = '10.0.2.2:3000';

  @override
  void initState() {
    super.initState();
  }

  Future<List<Individu>> getIndividus() async {
    var httpUri = Uri.http(baseUrl, '/individu/list');

    var data = await http.get(httpUri);
    var jsonData = json.decode(utf8.decode(data.bodyBytes)) as Iterable;

    individus = jsonData.map(
      (currentItem) {
        final key = currentItem['key_'] as String;
        if (key.startsWith('H')) {
          return Homme.fromJson(currentItem);
        }
        return Femme.fromJson(currentItem);
      },
    ).toList();
    return individus;
  }

  void search(String query) {
    List<Individu> base = [];
    base.addAll(individus);
    if (query.isNotEmpty) {
      List<Individu> tempIndividus = [];

      for (var element in base) {
        String match = '${element.prenom} ${element.nom}';
        if (match.toLowerCase().contains(query.toLowerCase())) {
          tempIndividus.add(element);
        }
      }
      setState(() {
        matchedIndividus.clear();
        matchedIndividus.addAll(tempIndividus);
      });
      return;
    } else {
      setState(() {
        matchedIndividus.clear();
        matchedIndividus.addAll(individus);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        elevation: 0,
        title: Text(''),
        centerTitle: true,
        actions: [],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: TextField(
                onChanged: (value) {
                  search(value);
                },
                controller: textController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Chercher',
                ),
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AvatarGlow(
                  endRadius: 50,
                  glowColor: Colors.blue,
                  duration: Duration(
                    milliseconds: 2500,
                  ),
                  animate: isListening,
                  child: FloatingActionButton(
                    backgroundColor: Colors.blue,
                    onPressed: () async {
                      if (!isListening) {
                        var available = await _speechToText.initialize();
                        if (available) {
                          setState(
                            () {
                              isListening = true;
                            },
                          );
                          _speechToText.listen(
                            listenFor: Duration(milliseconds: 5000),
                            onResult: (result) {
                              setState(
                                () {
                                  _recognizedWords = result.recognizedWords;
                                  textController.text = _recognizedWords;
                                  search(_recognizedWords);
                                  setState(
                                    () {
                                      isListening = false;
                                    },
                                  );
                                },
                              );
                            },
                          );
                        }
                      } else {
                        setState(
                          () {
                            isListening = false;
                          },
                        );
                        _speechToText.stop();
                      }
                    },
                    child: Icon(
                      isListening ? Icons.mic : Icons.mic_none,
                    ),
                  ),
                ),
                FloatingActionButton(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => FaceRecognitionPage(
                        individus: individus,
                      ),
                    ),
                  ),
                  backgroundColor: Colors.blue,
                  child: Icon(Icons.image_search_rounded),
                ),
              ],
            ),
            SizedBox(
              height: deviceHeight * 0.675,
              child: FutureBuilder(
                future: getIndividus(),
                builder: (BuildContext context,
                    AsyncSnapshot<List<Individu>> snapshot) {
                  if (snapshot.data == null) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Center(
                          child: CircularProgressIndicator(),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Center(
                          child: Text(
                            'Patientez un instant.\n\nSi le chargement dure trop, veuillez vérifier votre connexion.',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    );
                  } else {
                    return AlphabetScrollList(
                      key: ValueKey(matchedIndividus.length),
                      items: matchedIndividus.isNotEmpty
                          ? matchedIndividus
                          : individus,
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RechercheIndividusDelegate extends SearchDelegate {
  static List<Individu> elementsRecherche = [];

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          if (query.isEmpty) {
            close(context, null);
          } else {
            query = '';
          }
        },
        icon: Icon(
          Icons.clear,
        ),
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () => close(context, null),
      icon: Icon(
        Icons.arrow_back,
      ),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    List<Individu> matchQuery = [];

    for (var element in elementsRecherche) {
      String match = '${element.prenom} ${element.nom}';
      if (match.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(element);
      }
    }

    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(
            matchQuery[index].prenom,
          ),
          onTap: () => {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => IndividuPage(
                  id: matchQuery[index].id,
                  list: elementsRecherche,
                ),
              ),
            ),
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<Individu> matchQuery = [];
    for (var element in elementsRecherche) {
      String match = '${element.prenom} ${element.nom}';
      if (match.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(element);
      }
    }

    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(
            matchQuery[index].prenom,
          ),
          onTap: () => {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => IndividuPage(
                  id: matchQuery[index].id,
                  list: elementsRecherche,
                ),
              ),
            ),
          },
        );
      },
    );
  }
}
