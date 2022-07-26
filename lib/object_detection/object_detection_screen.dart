import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:tflite/tflite.dart';

import '../main.dart';
import 'object_detection_VM.dart';

class ObjectDetectionScreen extends StatefulWidget {
  late final ObjectDetectionVM viewModel;

  ObjectDetectionScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => ObjectDetectionScreenState();
}

class ObjectDetectionScreenState extends State<ObjectDetectionScreen> {
  late CameraController cameraController;
   CameraImage? imgCamera;
  bool isCamWorking = false;
  late double imgHeight;
  late double imgWidth;
  List recongnition = [];
  List<Widget> stackWidgets = [];

  Future runModelOnStreamFrame() async {
    imgHeight = imgCamera!.height + 0.0;
    imgWidth = imgCamera!.height + 0.0;
    recongnition = (await Tflite.detectObjectOnFrame(
      bytesList: imgCamera!.planes.map((plane) {
        return plane.bytes;
      }).toList(),
      model: 'SSDMobileNet',
      imageHeight: imgCamera!.height,
      imageWidth: imgCamera!.width,
      imageMean: 127.5,
      numResultsPerClass: 1,
      threshold: 0.4,
    ))!;
    isCamWorking = false;
    setState(() {
      imgCamera;
    });
  }

  List<Widget> displayBoxes(Size screen) {
    if (recongnition.isEmpty) return [];
    if ((imgHeight == 0) || (imgWidth == 0)) return [];
    double factorX = screen.width;
    double factorY = imgHeight;
    Color color = Colors.brown;

    return recongnition
        .map((result) => Positioned(
              left: (result["rect"]["x"] as double) * factorX,
              top: (result["rect"]["y"] as double) * factorY,
              width: (result["rect"]["w"] as double) * factorX,
              height: (result["rect"]["h"] as double) * factorY,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                  border: Border.all(color: Colors.brown, width: 1.0),
                ),
                child: Text(
                  "{$result['detectedClass'] ${(result['confidenceInClass'] * 100).toString()}",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16.0,
                    backgroundColor: color,
                  ),
                ),
              ),
            ))
        .toList();
  }

  @override
  void initState() {
    super.initState();
    cameraController = CameraController(cameras[0], ResolutionPreset.max);
    cameraController.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {
        cameraController.startImageStream(
          (imageFromStream) => {
            if (!isCamWorking)
              {
                isCamWorking = true,
                imgCamera = imageFromStream,
                runModelOnStreamFrame(),
              }
          },
        );
      });
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            print('User denied camera access.');
            break;
          default:
            print('Handle other errors.');
            break;
        }
      }
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController? controller = cameraController;

    // App state changed before we got the chance to initialize.
    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      //todo onNewCameraSelected(cameraController.description);
    }
  }

  @override
  void dispose() {
    super.dispose();
    cameraController.stopImageStream();
    cameraController.dispose();
    Tflite.close();
  }

  @override
  Widget build(BuildContext context) {
    stackWidgets.add(
      Positioned(
        top: 0,
        left: 0,
        width: MediaQuery.of(context).size.height - 100,
        child: Container(
          height: MediaQuery.of(context).size.height - 100,
          child: (!cameraController.value.isInitialized)
              ? Container()
              : AspectRatio(
                  aspectRatio: cameraController.value.aspectRatio,
                  child: CameraPreview(cameraController),
                ),
        ),
      ),
    );

    if (imgCamera != null) {
      stackWidgets.addAll(displayBoxes(MediaQuery.of(context).size));
    }
    return SafeArea(
      child: ViewModelBuilder<ObjectDetectionVM>.reactive(
        viewModelBuilder: () => ObjectDetectionVM(),
        onModelReady: (viewModel) {
          viewModel.loadModel();
        },
        builder: (context, viewModel, child) => Container(
          margin: const EdgeInsets.only(top: 50),
          child: Stack(
            children: stackWidgets,
          ),
        ),
      ),
    );
  }
}
