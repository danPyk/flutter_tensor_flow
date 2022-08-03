import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'package:tflite/tflite.dart';
import 'package:tfserving_flutter/main.dart';

import '../front/camera.dart';

Logger logger = Logger();

class CameraVM extends ChangeNotifier {

  // The cameraFeed Class takes the cameras list and the setRecognitions
  // function as argument
  CameraVM();

  // Future<CameraController?> initializeCameraController() async {
  //   if (cameras.isEmpty) {
  //     logger.d('No Cameras Found.');
  //     return Future.error('Couldn\t get the rear camera');
  //   } else {
  //     controller = CameraController(
  //       cameras[0],
  //       ResolutionPreset.high,
  //     );
  //     await controller?.initialize();
  //     return controller;
  //   }
  // }


}
