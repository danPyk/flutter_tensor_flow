import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'package:tflite/tflite.dart';
import 'package:tfserving_flutter/main.dart';

import 'camera.dart';

Logger logger = Logger();

class CameraVM extends ChangeNotifier {
  late CameraController? controller;
  bool isDetecting = false;
  final Callback setRecognitions;

  // The cameraFeed Class takes the cameras list and the setRecognitions
  // function as argument
  CameraVM(this.setRecognitions);

  Future<CameraController?> initializeCameraController() async {
    if (cameras.isEmpty) {
      logger.d('No Cameras Found.');
    } else {
      controller = CameraController(
        cameras[0],
        ResolutionPreset.high,
      );
      await controller!.initialize();
      return controller;
    }
  }

  void startCameraStream() {
    controller!.startImageStream((CameraImage img) {
      if (!isDetecting) {
        isDetecting = true;
        Tflite.detectObjectOnFrame(
          bytesList: img.planes.map((plane) {
            return plane.bytes;
          }).toList(),
          imageHeight: img.height,
          imageWidth: img.width,
          numResultsPerClass: 1,
          threshold: 0.4,
        ).then((recognitions) {
          /*
              When setRecognitions is called here, the parameters are being passed on to the parent widget as callback. i.e. to the LiveFeed class
               */
          //setRecognitions(recognitions!, img.height, img.width);
          isDetecting = false;
        });
      }
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            logger.d('User denied camera access..');

            break;
          default:
            logger.d('Handle other errors.');

            break;
        }
      }
    });
  }
}
