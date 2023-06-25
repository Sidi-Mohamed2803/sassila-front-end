// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, non_constant_identifier_names, no_leading_underscores_for_local_identifiers, use_build_context_synchronously, unnecessary_null_comparison

import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sassila_mobile_ui/modeles/Individu.dart';
import 'package:sassila_mobile_ui/pages/facial_recognition_results_page.dart';

class FaceRecognitionPage extends StatefulWidget {
  final List<Individu> individus;
  const FaceRecognitionPage({Key? key, required this.individus})
      : super(key: key);

  @override
  State<FaceRecognitionPage> createState() => _FaceRecognitionPageState();
}

class _FaceRecognitionPageState extends State<FaceRecognitionPage> {
  final ImagePicker _picker = ImagePicker();
  String api_key = 'j266mAM-x23FMKSVv-pzVF_0a-z7jM7T';
  String api_secret = 'S6-Mn4hIra7OV_IKMJxwNqVJCeSnwC8p';
  XFile? _image;
  bool searching = false;

  // String baseUrl = 'localhost:3000';
  // String baseUrl = '10.30.2.172:3000';
  String baseUrl = '192.168.1.21:3000';
  // String baseUrl = '10.0.2.2:3000';

  void debugPrint(dynamic toPrint) {
    if (kDebugMode) {
      print(toPrint);
    }
  }

  Future<dynamic> getIndividuImage(int idIndividu) async {
    var httpUri = Uri.http(baseUrl, '/image/display/$idIndividu');

    var data = await http.get(httpUri);

    var blob = Uint8List.fromList(data.body.codeUnits);

    return blob;
  }

  Future<String> getFaceToken(String image_base64) async {
    var httpUri = Uri.dataFromString(
        'https://api-us.faceplusplus.com/facepp/v3/detect',
        parameters: {
          'image_url':
              'https://qph.cf2.quoracdn.net/main-qimg-f2436738f0c6e9a85c89ce9b5b411f14-lq'
        });

    var httpRequest = Uri.https('api-us.faceplusplus.com', 'facepp/v3/detect',
        {'image_base64': image_base64});

    var data = await http.post(httpRequest);
    debugPrint(data.body);
    var jsonData = jsonDecode(data.body);
    var faces = jsonData['faces'] as List;

    if (faces == null || faces.isEmpty) {
      return '';
    }
    var face = faces[0];
    return face['face_token'];
  }

  Future<String> getFaceTokenFromFile(File image) async {
    var request = http.MultipartRequest(
        'POST', Uri.parse('https://api-us.faceplusplus.com/facepp/v3/detect'))
      ..fields['api_key'] = api_key
      ..fields['api_secret'] = api_secret
      ..files.add(
          http.MultipartFile.fromBytes("image_file", image.readAsBytesSync()));

    try {
      var multiResponse = await request.send();
      var jsonData = jsonDecode(await multiResponse.stream.bytesToString());
      var faces = jsonData['faces'] as List;
      debugPrint(
        "+++++++++++++++++++*******************************************+*+*++*+*+*+*+*+*+*+**+*+*+*+*+\n",
      );
      debugPrint(jsonData);

      if (faces == null || faces.isEmpty) {
        return '';
      }
      var face = faces[0];
      return face['face_token'];
    } on Exception catch (_, e) {
      debugPrint(e);
    }
    return '';
  }

  void searchByFace(XFile face) async {
    double _confidence = 0.0;
    dynamic mostConfident;

    Uint8List image1UintList = await face.readAsBytes();
    String image_base64_1 = base64Encode(image1UintList);
    Uri uri;
    setState(() {
      searching = true;
      loading();
    });
    var face_token1 = await getFaceToken(image_base64_1);
    if (face_token1.isEmpty) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              title: Text(
                'Aucun visage détecté sur l\'image soumise.\nVeuillez sélectionner une image avec un et un seul visage',
                textAlign: TextAlign.center,
              ),
              content: SizedBox(
                height: MediaQuery.of(context).size.height / 7,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.check_box),
                          Text('OK'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          });
      setState(() {
        searching = false;
      });
      return;
    }
    for (var individu in widget.individus) {
      if (individu.imageUrl.isEmpty) {
        continue;
      }
      if (kDebugMode) {
        print("Image URL : ${individu.imageUrl}");
      }
      Uint8List face2 = await getIndividuImage(individu.id) as Uint8List;
      String image_base64_2 = base64Encode(face2);
      debugPrint('2nd call ${individu.prenom}');
      var face_token2 = await getFaceToken(image_base64_2);
      uri = Uri.https(
        'api-us.faceplusplus.com',
        '/facepp/v3/compare',
        {
          'api_key': api_key,
          'api_secret': api_secret,
          'face_token1': face_token1,
          'face_token2': face_token2
        },
      );
      try {
        var data = await http.post(uri);
        if (kDebugMode) {
          print(data.body);
        }
        var jsonData = jsonDecode(data.body);
        if (jsonData['confidence'] != null) {
          if (jsonData['confidence'] > _confidence) {
            _confidence = double.parse(
                (jsonData['confidence'] as double).toStringAsFixed(2));
            mostConfident = individu;
          }
        }
      } on Exception catch (_, e) {
        if (kDebugMode) {
          setState(() {
            searching = false;
          });
          print(e);
        }
      }
    }
    // Remove the CircularProgressIndicator
    Navigator.pop(context);
    if (mostConfident != null) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => FaceRecognitionResults(
            individu: mostConfident,
            confidence: _confidence,
            list: widget.individus,
          ),
        ),
      );
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              title: Text(
                'Aucun individu correspondant trouvé.',
                textAlign: TextAlign.center,
              ),
              content: SizedBox(
                height: MediaQuery.of(context).size.height / 15,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.check_box),
                          Text('OK'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          });
      setState(() {
        searching = false;
      });
    }
  }

  Future getImage(ImageSource media) async {
    var img = await _picker.pickImage(source: media);

    setState(() {
      _image = img;
    });
  }

  void loading() {
    if (searching) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            title: Text(
              'Recherche en cours...',
              textAlign: TextAlign.center,
            ),
            content: SizedBox(
              height: MediaQuery.of(context).size.height / 15,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        },
      );
    } else {}
  }

  void myAlert() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            title: Text('Please choose media to select'),
            content: SizedBox(
              height: MediaQuery.of(context).size.height / 6,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    //if user click this button, user can upload image from gallery
                    onPressed: () {
                      Navigator.pop(context);
                      getImage(ImageSource.gallery);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.image),
                        Text('Galerie'),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    //if user click this button. user can upload image from camera
                    onPressed: () {
                      Navigator.pop(context);
                      getImage(ImageSource.camera);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.camera),
                        Text('Caméra'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        elevation: 0,
        title: Text('Cherchez un individu par visage'),
        centerTitle: true,
        actions: [],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                myAlert();
              },
              child: Text(
                'Sélectionnez une photo',
              ),
            ),
            SizedBox(
              height: 10,
            ),
            if (_image != null) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.file(
                    //to show image, you type like this.
                    File(_image!.path),
                    fit: BoxFit.cover,
                    width: MediaQuery.of(context).size.width,
                    height: 300,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  searchByFace(_image!);
                },
                child: Text(
                  'Commencer la recherche',
                ),
              ),
            ] else ...[
              Text(
                "Aucune image sélectionnée",
                style: TextStyle(fontSize: 20),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
