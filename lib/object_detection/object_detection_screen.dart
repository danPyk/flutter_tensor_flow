import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../main.dart';
import 'object_detection_VM.dart';

class ObjectDetectionScreen extends StatefulWidget {
  late final  ObjectDetectionVM viewModel;
  ObjectDetectionScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => ObjectDetectionScreenState();
}

class ObjectDetectionScreenState extends State<ObjectDetectionScreen> {

  late CameraController cameraController;
  CameraImage? imgCamera;
  bool isCamWorking = false;

  List<Widget> buildStackWidgets(BuildContext context, ObjectDetectionVM viewModel) {
    List<Widget> stackWidgets = [
      Positioned(
        top: 0,
        left: 0,
        width: MediaQuery.of(context).size.height - 100,
        child: Container(
          height: MediaQuery.of(context).size.height - 100,
          child: (!cameraController.value.isInitialized)
              ? Container()
              : AspectRatio(aspectRatio: cameraController.value.aspectRatio),
        ),
      ),
      CameraPreview(cameraController),
    ];

    return stackWidgets;
  }

  @override
  void initState() {
    super.initState();
   // widget.viewModel.initializeCamera(mounted);
    cameraController = CameraController(cameras[0], ResolutionPreset.max);
    cameraController.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {
        cameraController.startImageStream((imageFromStream) => {
          if (!isCamWorking)
            {
              isCamWorking = true,
              imgCamera = imageFromStream,
            }
        },);
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
    cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ViewModelBuilder<ObjectDetectionVM>.reactive(
        viewModelBuilder: () => ObjectDetectionVM(),
        //onModelReady: (viewModel) => viewModel.initializeCamera(),
        builder: (context, viewModel, child) => Container(
          margin: EdgeInsets.only(top: 50),
          child:

           Stack(
                  children: buildStackWidgets(context, viewModel),
                ),
        ),
      ),
    );
  }
}
