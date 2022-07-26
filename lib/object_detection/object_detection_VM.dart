import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
//import 'package:tflite/tflite.dart';

class ObjectDetectionVM extends ChangeNotifier {
  // late CameraController cameraController;
  // CameraImage? imgCamera;
  // bool isCamWorking = false;
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

  // Future loadModel() async {
  //   Tflite.close();
  //
  //   try {
  //     String? response;
  //     response = await Tflite.loadModel(
  //       model: 'lib/object_detection/data/4.2 ssd_mobilenet.tflite',
  //       labels: 'lib/object_detection/data/4.1 ssd_mobilenet.txt',
  //     );
  //   } on PlatformException {
  //     var logger = Logger();
  //     logger.d('Unable to load model');
  //   }
  // }
}
