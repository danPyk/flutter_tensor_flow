import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tensor_flow/obj_det/back/camera_vm.dart';
import 'package:provider/provider.dart';
import 'package:flutter_tensor_flow/select_screen/select_screen_vm.dart';
import 'package:wakelock/wakelock.dart';
import 'select_screen/select_screen.dart';

List<CameraDescription> cameras = <CameraDescription>[];

Future<void> main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    cameras = await availableCameras();
  } on CameraException catch (e) {
    logger.e(e.description);
  }
  // Wakelock.enable();

  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MultiProvider(
        providers: [
          ChangeNotifierProvider(
              create: (BuildContext context) => SelectScreenVM()),
          //ChangeNotifierProvider(create: (BuildContext context) => ObjectDetectionVM()),
        ],
        child: const SelectScreen(),
      ),
    );
  }
}
