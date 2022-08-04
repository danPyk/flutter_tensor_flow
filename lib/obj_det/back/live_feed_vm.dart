import 'package:flutter/material.dart';
import 'package:tflite/tflite.dart';
import 'package:flutter_tensor_flow/obj_det/data/Rect.dart';
import 'package:flutter_tensor_flow/obj_det/data/captured_object.dart';

import '../front/camera.dart';

class LiveFeedVM extends ChangeNotifier{

   List<dynamic> recognitions = [];
  int imageHeight = 0;
  int imageWidth = 0;

  /*
  The set recognitions function assigns the values of recognitions, imageHeight and width to the variables defined here as callback
  */
  void setRecognitions( List<dynamic> newRecognitions, int newHigh, int newWidth) {
      recognitions = newRecognitions;
      imageHeight = newHigh;
      imageWidth = newWidth;
      notifyListeners();
  }


  Future<void> loadTfModel() async {
    await Tflite.loadModel(
      model: "assets/ssd_mobilenet.tflite",
      labels: "assets/ssd_mobilenet.txt",
    );
  }
}