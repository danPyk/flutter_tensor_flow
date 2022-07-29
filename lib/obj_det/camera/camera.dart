import 'dart:math' as math;

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:stacked/stacked.dart';
import 'package:tfserving_flutter/obj_det/camera/camera_vm.dart';

typedef Callback = void Function(List<dynamic> list, int h, int w);

Logger logger = Logger();

class CameraFeed extends StatefulWidget {
  final Callback setRecognitions;

  // The cameraFeed Class takes the cameras list and the setRecognitions
  // function as argument
  const CameraFeed(this.setRecognitions);

  @override
  _CameraFeedState createState() => _CameraFeedState();
}

class _CameraFeedState extends State<CameraFeed> {
  double _minAvailableExposureOffset = 0.0;
  double _maxAvailableExposureOffset = 0.0;
  double _minAvailableZoom = 1.0;
  double _maxAvailableZoom = 1.0;

  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   final CameraController? cameraController = controller;
  //
  //   // App state changed before we got the chance to initialize.
  //   if (cameraController == null || !cameraController.value.isInitialized) {
  //     return;
  //   }
  //
  //   if (state == AppLifecycleState.inactive) {
  //     cameraController.dispose();
  //   } else if (state == AppLifecycleState.resumed) {
  //     onNewCameraSelected(cameraController.description);
  //   }
  // }

  void showInSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  void _logError(String code, String? message) {
    if (message != null) {
      logger.e('Error: $code\nError Message: $message');
    } else {
      logger.e('Error: $code');
    }
  }

  void _showCameraException(CameraException e) {
    _logError(e.code, e.description);
    showInSnackBar('Error: ${e.code}\n${e.description}');
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CameraVM>.reactive(
      viewModelBuilder: () => CameraVM(widget.setRecognitions),
      builder: (context, viewModel, child) => Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Center(
            child: Column(
              children: <Widget>[
                FutureBuilder<CameraController?>(
                  future: viewModel.initializeCameraController(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      if (!viewModel.controller!.value.isInitialized) {
                        return Container();
                      }
                        viewModel.startCameraStream();
                        Size? tmp = MediaQuery.of(context).size;
                        final double screenH = math.max(tmp.height, tmp.width);
                        final double screenW = math.min(tmp.height, tmp.width);

                        CameraController? cnt = snapshot.data as CameraController;
                        tmp = cnt.value.previewSize;
                        final double previewH = math.max(tmp!.height, tmp.width);
                        final double previewW = math.min(tmp.height, tmp.width);
                        final double screenRatio = screenH / screenW;
                        final double previewRatio = previewH / previewW;

                        return OverflowBox(
                            maxHeight: screenRatio > previewRatio ? screenH : screenW / previewW * previewH,
                            maxWidth: screenRatio > previewRatio ? screenH / previewH * previewW : screenW,
                            child: CameraPreview(
                              viewModel.controller!,
                            ));



                    } else if (snapshot.hasError) {
                      return Icon(Icons.error_outline);
                    } else {
                      return CircularProgressIndicator();
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
