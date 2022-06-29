import 'package:flutter/cupertino.dart';
import 'package:mediapipedemo/src/utils/isolateUtil.dart';
import 'dart:isolate';
import 'package:camera/camera.dart';
import 'package:get/get.dart';
import 'package:mediapipedemo/src/controllers/faceMeshController.dart';

class InferenceController extends GetxController {
  final Rx<IsolateUtil?> _isolateUtil = Rx<IsolateUtil?>(null);
  set isolateUtil(IsolateUtil? value) => _isolateUtil.value = value;
  IsolateUtil? get isolateUtil => _isolateUtil.value;

  final Rx<bool> _predicting = Rx<bool>(false);
  bool get predicting => _predicting.value;

  final Rx<List<Offset>> _inferenceResults = Rx<List<Offset>>([]);
  List<Offset> get inferenceResults => _inferenceResults.value;

  Future<void> inference(
      {required CameraImage cameraImage, required int address}) async {
    _predicting.value = true;
    final responsePort = ReceivePort();
    isolateUtil?.sendMessage(
      handler: runFaceMeshLive,
      params: {
        'cameraImage': cameraImage,
        'address': address,
      },
      sendPort: isolateUtil!.sendPort,
      responsePort: responsePort,
    );
    final List<Offset>? result = await responsePort.first as List<Offset>?;
    if (result != null) {
      _inferenceResults.value = result;
    } else {
      _inferenceResults.value = [];
    }
    responsePort.close();
    _predicting.value = false;
  }
}
