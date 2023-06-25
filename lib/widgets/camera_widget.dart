import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class SassilaCameraWidget extends StatefulWidget {
  static String routeName = 'camera';
  @override
  State<SassilaCameraWidget> createState() => _SassilaCameraWidgetState();
}

class _SassilaCameraWidgetState extends State<SassilaCameraWidget> {
  late List<CameraDescription> cameras;
  late CameraController cameraController;

  @override
  void initState() {
    startCamera(0);
    super.initState();
  }

  void startCamera(int direction) async {
    cameras = await availableCameras();

    cameraController = CameraController(
      cameras[direction],
      ResolutionPreset.high,
      enableAudio: false,
    );

    await cameraController.initialize().then((value) {
      if (!mounted) {
        return;
      }
      setState(() {}); // To refresh the widget
    }).catchError((e) {
      print(e);
    });
  }

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
