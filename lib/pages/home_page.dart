// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unnecessary_this, deprecated_member_use, import_of_legacy_library_into_null_safe

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';

import 'package:sassila_mobile_ui/pages/membres_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  static String routeName = '/';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        actions: [],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(50.0),
                    bottomLeft: Radius.circular(50.0)),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  colors: [
                    Colors.blue[900]!,
                    Colors.blue[500]!,
                    Colors.blue[300]!
                  ],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      SizedBox(
                        height: 220,
                      ),
                      Expanded(
                        flex: 4,
                        child: Padding(
                          padding: EdgeInsets.all(20),
                          child: AnimatedTextKit(
                            animatedTexts: [
                              RotateAnimatedText(
                                'WIKI Sassila',
                                textStyle: TextStyle(
                                  fontSize: 35,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                duration: Duration(seconds: 2),
                              ),
                              RotateAnimatedText(
                                'Comtemplez votre généalogie',
                                textStyle: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                duration: Duration(seconds: 2),
                              ),
                              RotateAnimatedText(
                                'Vos racines au bout des doigts',
                                textStyle: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                duration: Duration(seconds: 2),
                              ),
                            ],
                            repeatForever: true,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Cherchez les membres de votre famille :',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Divider(
                        thickness: 1.5,
                        color: Colors.blueAccent,
                      ),
                      Card(
                        shadowColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                          side: BorderSide(
                            color: Colors.blueAccent,
                            width: 0.5,
                          ),
                        ),
                        child: InkWell(
                          onTap: () => {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => Membres(),
                              ),
                            ),
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Column(
                              children: <Widget>[
                                Icon(
                                  Icons.people,
                                  size: 80,
                                  color: Colors.blue[800],
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Text(
                                  'Voir tous les membres',
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
