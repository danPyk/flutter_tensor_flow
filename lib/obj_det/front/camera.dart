import 'dart:math' as math;

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:stacked/stacked.dart';
import 'package:tflite/tflite.dart';

import 'package:flutter_tensor_flow/main.dart';
import 'package:flutter_tensor_flow/obj_det/back/camera_vm.dart';
import 'package:flutter_tensor_flow/obj_det/data/captured_object.dart';

typedef Callback = void Function(List<dynamic> list, int h, int w);

T? _ambiguate<T>(T? value) => value;

Logger logger = Logger();

//todo why camera sometimes work smooth? detectObjectOnFrame create stutter
class CameraFeed extends StatefulWidget {
  final Callback setRecognitions;

  // The cameraFeed Class takes the cameras list and the setRecognitions
  // function as argument
  const CameraFeed(this.setRecognitions);

  @override
  CameraFeedState createState() {
    return CameraFeedState();
  }
}

class CameraFeedState extends State<CameraFeed> with WidgetsBindingObserver {
  late CameraController? controller;

  double _minAvailableExposureOffset = 0.0;
  double _maxAvailableExposureOffset = 0.0;
  double _minAvailableZoom = 1.0;
  double _maxAvailableZoom = 1.0;

  void initCamera() {
    controller = CameraController(
      cameras[0],
      ResolutionPreset.max,
      imageFormatGroup: ImageFormatGroup.yuv420,
    );
    controller?.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});

      //startCameraStream();
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            logger.e('User denied camera access.');
            break;
          default:
            logger.e('Handle other errors.');
            break;
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _ambiguate(WidgetsBinding.instance)?.addObserver(this);
    initCamera();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    logger.d(state.toString());
    final CameraController? cameraController = controller;

    // App state changed before we got the chance to initialize.
    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      onNewCameraSelected(cameraController.description);
    }
  }

  // #en
  Future<void> onNewCameraSelected(CameraDescription cameraDescription) async {
    final CameraController? oldController = controller;
    if (oldController != null) {
      // `controller` needs to be set to null before getting disposed,
      // to avoid a race condition when we use the controller that is being
      // disposed. This happens when camera permission dialog shows up,
      // which triggers `didChangeAppLifecycleState`, which disposes and
      // re-creates the controller.
      controller = null;
      await oldController.dispose();
    }

    final CameraController cameraController = CameraController(
      cameraDescription,
      kIsWeb ? ResolutionPreset.max : ResolutionPreset.medium,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );

    controller = cameraController;

    // If the controller is updated then update the UI.
    cameraController.addListener(() {
      if (mounted) {
        setState(() {});
      }
      if (cameraController.value.hasError) {
        showInSnackBar(
            'Camera error ${cameraController.value.errorDescription}');
      }
    });

    try {
      await cameraController.initialize();
      await Future.wait(<Future<Object?>>[
        // The exposure mode is currently not supported on the web.
        ...!kIsWeb
            ? <Future<Object?>>[
                cameraController.getMinExposureOffset().then(
                    (double value) => _minAvailableExposureOffset = value),
                cameraController
                    .getMaxExposureOffset()
                    .then((double value) => _maxAvailableExposureOffset = value)
              ]
            : <Future<Object?>>[],
        cameraController
            .getMaxZoomLevel()
            .then((double value) => _maxAvailableZoom = value),
        cameraController
            .getMinZoomLevel()
            .then((double value) => _minAvailableZoom = value),
      ]);
    } on CameraException catch (e) {
      switch (e.code) {
        case 'CameraAccessDenied':
          showInSnackBar('You have denied camera access.');
          break;
        case 'CameraAccessDeniedWithoutPrompt':
          // iOS only
          showInSnackBar('Please go to Settings app to enable camera access.');
          break;
        case 'CameraAccessRestricted':
          // iOS only
          showInSnackBar('Camera access is restricted.');
          break;
        case 'AudioAccessDenied':
          showInSnackBar('You have denied audio access.');
          break;
        case 'AudioAccessDeniedWithoutPrompt':
          // iOS only
          showInSnackBar('Please go to Settings app to enable audio access.');
          break;
        case 'AudioAccessRestricted':
          // iOS only
          showInSnackBar('Audio access is restricted.');
          break;
        default:
          _showCameraException(e);
          break;
      }
    }

    if (mounted) {
      setState(() {});
    }
  }

  void showInSnackBar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
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
  void dispose() {
    _ambiguate(WidgetsBinding.instance)?.addObserver(this);

    logger.close();

    controller?.dispose();
    super.dispose();
  }

  Widget cameraPreview() {
    final CameraController? cameraController = controller;

    if (cameraController != null && !cameraController.value.isInitialized) {
      return Container();
    } else {
      return CameraPreview(controller!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CameraVM>.reactive(
      viewModelBuilder: () => CameraVM(),
      builder: (context, viewModel, child) => Scaffold(
        body: cameraPreview(),
      ),
    );
  }
}
