import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import 'package:tflite/tflite.dart';

class ObjectDetectionVM extends ChangeNotifier {
  // late CameraController cameraController;
  // CameraImage? imgCamera;

  //
  // void initializeCamera(bool mounted) {
  //   Future<dynamic>.delayed(Duration(seconds: 20));
  //   cameraController = CameraController(cameras[0], ResolutionPreset.medium);
  //   cameraController.initialize().then((value) {
  //     if (!mounted) return;
  //
  //     cameraController.startImageStream((imageFromStream) => {
  //           if (!isCamWorking)
  //             {
  //               isCamWorking = true,
  //               imgCamera = imageFromStream,
  //             }
  //         },);
  //   });
  // }

  Future loadModel() async {

    try {
      String? response;
      response = await Tflite.loadModel(
        model: 'assets/ssd_mobilenet.tflite',
        labels: 'assets/ssd_mobilenet.txt',
      );
      Tflite.close();

    } on PlatformException {
      var logger = Logger();
      logger.d('Unable to load model');
    }
  }
}
