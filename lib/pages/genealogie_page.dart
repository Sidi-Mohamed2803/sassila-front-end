// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unnecessary_this, deprecated_member_use, import_of_legacy_library_into_null_safe, unnecessary_brace_in_string_interps, must_call_super

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:graphview/GraphView.dart';
import 'package:sassila_mobile_ui/modeles/Femme.dart';
import 'package:sassila_mobile_ui/modeles/Homme.dart';
import 'package:sassila_mobile_ui/modeles/Individu.dart';
import 'package:sassila_mobile_ui/pages/individu_page.dart';

import 'package:http/http.dart' as http;

class TreeViewPage extends StatefulWidget {
  final List<Individu> list;
  final Individu individu;
  const TreeViewPage({Key? key, required this.list, required this.individu})
      : super(key: key);
  static String routeName = 'genealogie';

  @override
  // ignore: library_private_types_in_public_api
  _TreeViewPageState createState() => _TreeViewPageState();
}

class _TreeViewPageState extends State<TreeViewPage> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: Center(
              child: InteractiveViewer(
                  constrained: false,
                  boundaryMargin: EdgeInsets.all(100),
                  minScale: 0.01,
                  maxScale: 3,
                  child: GraphView(
                    graph: graph,
                    algorithm: SugiyamaAlgorithm(
                      builder,
                    ),
                    paint: Paint()
                      ..color = Colors.black
                      ..strokeWidth = 1
                      ..style = PaintingStyle.stroke,
                    builder: (Node node) {
                      return rectangleWidget(node.key?.value as Individu);
                    },
                  )),
            ),
          ),
        ],
      ),
    );
  }

  Widget rectangleWidget(dynamic individu) {
    return InkWell(
      onTap: () {
        Navigator.of(context)
          ..pop()
          ..push(
            MaterialPageRoute(
              builder: (context) => IndividuPage(
                id: individu.id,
                list: widget.list,
              ),
            ),
          );
      },
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40),
          boxShadow: [
            BoxShadow(color: Colors.blue[100]!, spreadRadius: 1),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FutureBuilder(
              future: getImage(individu.id),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.data == null) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Center(
                        child: CircleAvatar(
                            backgroundColor: Colors.grey,
                            radius: 95,
                            child: CircularProgressIndicator()),
                      ),
                    ],
                  );
                } else {
                  return CircleAvatar(
                    radius: 95,
                    backgroundImage: individu.imageUrl.isNotEmpty
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
            SizedBox(
              height: 20,
            ),
            Text(
              '${individu.prenom} ${individu.nom}',
            ),
          ],
        ),
      ),
    );
  }

// Individu(45, "H787gh", "", "", "", DateTime.now(), "", "", DateTime.now(), "", "", "", List.empty())

  void chercherEnfants(Individu individu) {
    if (individu.enfants.isEmpty) {
      return;
    }

    Node individuNode = Node.Id(individu);

    for (var enfant in individu.enfants) {
      graph.addEdge(Node.Id(enfant), individuNode);

      chercherEnfants(enfant);
    }

    // Node epouseNode = Node.Id((individu as Homme).epouses?.first);
    // epouseNode.position = individuNode.position;
    // print(epouseNode.position);
    // graph.addEdge(epouseNode, individuNode);
  }

  void chercherParents(Individu individu) {
    Homme? pere;
    Femme? mere;
    for (var i in widget.list) {
      for (var enfant in i.enfants) {
        if (individu.id == enfant.id && i.key_.startsWith('H')) {
          pere = i as Homme;
          break;
        } else if (individu.id == enfant.id && i.key_.startsWith('F')) {
          mere = i as Femme;
          break;
        }
      }
    }
    Node child = Node.Id(individu);
    if (pere != null) {
      Node fatherNode = Node.Id(pere);
      graph.addEdge(
        child,
        fatherNode,
        // paint: Paint()
        //   ..color = Colors.black
        //   ..strokeWidth = 1
        //   ..style = PaintingStyle.stroke,
      );
      chercherParents(pere);
    }
    if (mere != null) {
      Node motherNode = Node.Id(mere);
      graph.addEdge(child, motherNode);
      chercherParents(mere);
    }
    if (mere == null && pere == null && !graph.hasNodes()) {
      graph.addNode(child);
    }
  }

  final Graph graph = Graph()..isTree = true;
  SugiyamaConfiguration builder = SugiyamaConfiguration();

  @override
  void initState() {
    chercherParents(widget.individu);
    chercherEnfants(widget.individu);

    builder
      ..levelSeparation = 100
      // ..siblingSeparation = 150
      // ..subtreeSeparation = (150)
      ..orientation = (SugiyamaConfiguration.ORIENTATION_BOTTOM_TOP);
  }
}
