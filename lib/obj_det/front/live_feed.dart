import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:tfserving_flutter/obj_det/front/camera.dart';
import 'package:tfserving_flutter/obj_det/back/live_feed_vm.dart';

import 'draw_rectangles.dart';

class LiveFeed extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    final Size screen = MediaQuery.of(context).size;
    return ViewModelBuilder<LiveFeedVM>.reactive(
      viewModelBuilder: () => LiveFeedVM(),
      onModelReady: (viewModel) => viewModel.loadTfModel(),
      builder: (context, viewModel, child) => Scaffold(
        appBar: AppBar(
          title: const Text("Real Time Object Detection"),
        ),
        body: Stack(
          children: <Widget>[
            CameraFeed(viewModel.setRecognitions),
            DrawRectangles(
              viewModel.recognitions,
              math.max(viewModel.imageHeight, viewModel.imageWidth),
              math.min(viewModel.imageHeight, viewModel.imageWidth),
              screen.height,
              screen.width,
            ),
          ],
        ),
      ),
    );
  }
}
