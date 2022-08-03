import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:tfserving_flutter/main.dart';
import 'package:tfserving_flutter/obj_det/front/live_feed.dart';
import 'package:tfserving_flutter/select_screen/select_screen_vm.dart';

class SelectScreen extends StatelessWidget {
  const SelectScreen({Key? key}) : super(key: key);

  void changeScreen(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => LiveFeed()));
  }

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      home: ViewModelBuilder<SelectScreenVM>.reactive(
        viewModelBuilder: () => SelectScreenVM(),
        builder: (context, viewModel, child) => Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Center(
              child: Column(
                children: [
                  ListTile(
                    leading: Text('Select app:'),
                  ),
                  ListTile(
                    leading: Text('TensorFlow spam filter with sending to server:'),
                    onTap: null,
                  ),
                  ListTile(
                    leading: Text('Live object detection:'),
                    onTap: () => changeScreen(context),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
