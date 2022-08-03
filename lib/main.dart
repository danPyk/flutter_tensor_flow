import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tfserving_flutter/select_screen/select_screen_vm.dart';
import 'package:wakelock/wakelock.dart';
import 'select_screen/select_screen.dart';

late List<CameraDescription> cameras ;

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
 // Wakelock.enable();

  cameras = await availableCameras();
  runApp(const App());


}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MultiProvider(providers: [
        ChangeNotifierProvider(create: (BuildContext context) => SelectScreenVM()),
        //ChangeNotifierProvider(create: (BuildContext context) => ObjectDetectionVM()),

      ], child:
      const SelectScreen( ),),
    );
  }
}
