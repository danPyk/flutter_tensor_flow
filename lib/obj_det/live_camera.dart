import 'dart:math' as math;

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:tflite/tflite.dart';
import 'package:tfserving_flutter/obj_det/bounding_box.dart';
import 'package:tfserving_flutter/obj_det/camera.dart';

class LiveFeed extends StatefulWidget {
  final List<CameraDescription> cameras;
  const LiveFeed(this.cameras);
  @override
  _LiveFeedState createState() => _LiveFeedState();
}

class _LiveFeedState extends State<LiveFeed> {
   List<double>? _recognitions = [];
  int _imageHeight = 0;
  int _imageWidth = 0;

  Future<void> loadTfModel() async {
    await Tflite.loadModel(
      model: "assets/ssd_mobilenet.tflite",
      labels: "assets/ssd_mobilenet.txt",
    );
  }
  /*
  The set recognitions function assigns the values of recognitions, imageHeight and width to the variables defined here as callback
  */
 void setRecognitions(List<double> recognitions,int imageHeight,int imageWidth) {
    setState(() {
      _recognitions = recognitions ;
      _imageHeight = imageHeight ;
      _imageWidth = imageWidth;
    });
  }

  @override
  void initState() {
    super.initState();
    loadTfModel();
  }

  @override
  Widget build(BuildContext context) {
    final Size screen = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Real Time Object Detection"),
      ),
      body: Stack(
        children: <Widget>[
          CameraFeed(widget.cameras, setRecognitions),
          BoundingBox(
            _recognitions ?? [] ,
            math.max(_imageHeight, _imageWidth),
            math.min(_imageHeight, _imageWidth),
            screen.height,
            screen.width,
          ),
        ],
      ),
    );
  }
}