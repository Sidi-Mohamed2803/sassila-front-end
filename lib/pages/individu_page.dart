// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unnecessary_this, deprecated_member_use, import_of_legacy_library_into_null_safe, sized_box_for_whitespace, avoid_unnecessary_containers

import 'dart:typed_data';

import 'package:date_format/date_format.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:sassila_mobile_ui/modeles/Individu.dart';
import 'package:sassila_mobile_ui/modeles/Section.dart';
import 'package:sassila_mobile_ui/pages/genealogie_page.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class IndividuPage extends StatefulWidget {
  final int id;
  final List<Individu> list;
  const IndividuPage({Key? key, required this.id, required this.list})
      : super(key: key);
  static String routeName = 'individu';

  @override
  State<IndividuPage> createState() => _IndividuPageState();
}

class _IndividuPageState extends State<IndividuPage> {
  final Color persoColor = Color.fromRGBO(39, 15, 171, 1);
  List<Section> sections = [];
  final Base64Decoder _base64decoder = Base64Decoder();
  // String baseUrl = 'localhost:3000';
  // String baseUrl = '10.30.2.172:3000';
  String baseUrl = '192.168.1.21:3000';
  // String baseUrl = '192.168.0.174:3000';
  // String baseUrl = '10.0.2.2:3000';

  void debugPrint(dynamic toPrint) {
    if (kDebugMode) {
      print(toPrint);
    }
  }

  Future<dynamic> getImage(int idIndividu) async {
    var httpUri = Uri.http(baseUrl, '/image/display/$idIndividu');

    var data = await http.get(httpUri);
    var blob = Uint8List.fromList(data.body.codeUnits);

    return blob;
  }

  Future<List<Section>> getSections() async {
    var httpUri = Uri.http(baseUrl, '/individu/${widget.id}/sections');

    var data = await http.get(httpUri);
    var jsonData = json.decode(utf8.decode(data.bodyBytes)) as Iterable;

    sections = jsonData.map((currentItem) {
      return Section.fromJson(currentItem);
    }).toList();
    return sections;
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    Individu individu =
        widget.list.firstWhere((element) => element.id == widget.id);
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromRGBO(4, 9, 35, 1),
                persoColor,
              ],
              begin: FractionalOffset.bottomCenter,
              end: FractionalOffset.topCenter,
            ),
          ),
        ),
        Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            actions: [],
          ),
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 38),
                child: Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Informations',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      height: height * 0.4,
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          // ignore: unused_local_variable
                          double innerHeight = constraints.maxHeight;
                          double innerWidth = constraints.maxWidth;
                          return Stack(
                            fit: StackFit.expand,
                            children: [
                              Positioned(
                                bottom: 0,
                                left: 0,
                                right: 0,
                                child: Container(
                                  width: innerWidth,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    color: Colors.white,
                                  ),
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: height * 0.04,
                                      ),
                                      Text(
                                        '${individu.prenom} ${individu.nom}',
                                        style: TextStyle(
                                          color: persoColor,
                                          fontSize: 25,
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Column(
                                            children: [
                                              Text(
                                                'Date de\nnaissance',
                                                style: TextStyle(
                                                  color: Colors.grey[900],
                                                  fontSize: 19,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                              Text(
                                                formatDate(
                                                    individu.date_naissance,
                                                    [dd, '/', mm, '/', yyyy]),
                                                style: TextStyle(
                                                  color: Color.fromRGBO(
                                                      39, 15, 171, 1),
                                                  fontSize: 17,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ],
                                          ),
                                          Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Container(
                                              height: 40,
                                              width: 5,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ),
                                          Column(
                                            children: [
                                              Text(
                                                'Lieu de\nnaissance',
                                                style: TextStyle(
                                                  color: Colors.grey[900],
                                                  fontSize: 19,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                              Text(
                                                individu.lieu_naissance,
                                                style: TextStyle(
                                                  color: Color.fromRGBO(
                                                      39, 15, 171, 1),
                                                  fontSize: 17,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ],
                                          ),
                                          Padding(
                                            padding: EdgeInsets.all(20.0),
                                            child: Container(
                                              height: 40,
                                              width: 5,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ),
                                          Column(
                                            children: [
                                              Text(
                                                'Résidence\nactuelle',
                                                style: TextStyle(
                                                  color: Colors.grey[900],
                                                  fontSize: 19,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                              Text(
                                                individu.residence_actuelle,
                                                style: TextStyle(
                                                  color: Color.fromRGBO(
                                                      39, 15, 171, 1),
                                                  fontSize: 17,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 15,
                                left: 0,
                                right: 0,
                                child: Center(
                                  child: Container(
                                    child: FutureBuilder(
                                      future: getImage(widget.id),
                                      builder: (BuildContext context,
                                          AsyncSnapshot<dynamic> snapshot) {
                                        if (snapshot.data == null) {
                                          return Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Center(
                                                child: CircleAvatar(
                                                    backgroundColor:
                                                        Colors.grey,
                                                    radius: 95,
                                                    child:
                                                        CircularProgressIndicator()),
                                              ),
                                            ],
                                          );
                                        } else {
                                          return CircleAvatar(
                                            radius: 95,
                                            backgroundImage: individu
                                                    .imageUrl.isNotEmpty
                                                ? MemoryImage(snapshot.data)
                                                : individu.key_.startsWith('H')
                                                    ? AssetImage(
                                                        'images/profileIcon.png',
                                                      ) as ImageProvider
                                                    : AssetImage(
                                                        'images/woman_profile.png',
                                                      ),
                                          );
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    //Section
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.white,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              'Biographie',
                              style: TextStyle(
                                color: persoColor,
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            FutureBuilder(
                              future: getSections(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<List<Section>> snapshot) {
                                if (snapshot.data == null ||
                                    snapshot.data!.isEmpty) {
                                  return Column(
                                    children: [
                                      Divider(
                                        thickness: 2.5,
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          snapshot.data == null
                                              ? Center(
                                                  child:
                                                      CircularProgressIndicator(),
                                                )
                                              : Center(),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Center(
                                            child: Text(
                                              snapshot.data == null
                                                  ? 'Patientez un instant.\n\nSi le chargement dure trop, veuillez vérifier votre connexion et réessayez.'
                                                  : '${individu.prenom} ${individu.nom} n\'a pas encore de sections de biographie.',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 20,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  );
                                }

                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    for (var section in snapshot.data!)
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          children: [
                                            Divider(
                                              thickness: 2.5,
                                            ),
                                            Text(
                                              '${section.titre}',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 22,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 25,
                                            ),
                                            Text(
                                              '${section.contenu}',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 18,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                  ],
                                );
                              },
                            ),
                            Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Container(
                                height: height * 0.06,
                                width: width * 0.5,
                                decoration: BoxDecoration(
                                  color: persoColor,
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: InkWell(
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Text(
                                        'Généalogie',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 25,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    onTap: () => {
                                          Navigator.of(context)
                                              .push(MaterialPageRoute(
                                            builder: (context) => TreeViewPage(
                                              individu: individu,
                                              list: widget.list,
                                            ),
                                          ))
                                        }),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    //Fin Section
                  ],
                )),
          ),
        ),
      ],
    );
  }
}
