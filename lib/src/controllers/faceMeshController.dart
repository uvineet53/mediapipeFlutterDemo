// ignore_for_file: parameter_assignments
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image/image.dart' as image_lib;
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:tflite_flutter_helper/tflite_flutter_helper.dart';
import 'package:mediapipedemo/src/utils/imageUtil.dart';

class FaceMeshController extends GetxController {
  final outputShapes = <List<int>>[];
  final outputTypes = <TfLiteType>[];
  final String _faceMesh = 'face_landmark.tflite';
  final int inputSize = 192;
  Interpreter? interpreter;

  ///Constructor
  FaceMeshController({
    this.interpreter,
  }) {
    loadModel();
  }

  int get address => interpreter!.address;

  Future<void> loadModel() async {
    try {
      final interpreterOptions = InterpreterOptions();
      interpreter ??= await Interpreter.fromAsset(
        _faceMesh,
        options: interpreterOptions,
      );
      final outputTensors = interpreter!.getOutputTensors();
      for (final tensor in outputTensors) {
        outputShapes.add(tensor.shape);
        outputTypes.add(tensor.type);
      }
    } catch (e) {
      debugPrint('Error while creating interpreter: $e');
    }
  }

  TensorImage getProcessedImage(TensorImage inputImage) {
    final imageProcessor = ImageProcessorBuilder()
        .add(ResizeOp(inputSize, inputSize, ResizeMethod.NEAREST_NEIGHBOUR))
        .add(NormalizeOp(0, 255))
        .build();
    return imageProcessor.process(inputImage);
  }

  List<Offset>? predict(image_lib.Image image) {
    if (interpreter == null) {
      debugPrint('Interpreter not initialized');
      return null;
    }
    if (Platform.isAndroid) {
      image = image_lib.copyRotate(image, -90);
      image = image_lib.flipHorizontal(image);
    }
    final tensorImage = (TensorImage(TfLiteType.float32));
    tensorImage.loadImage(image);
    final inputImage = getProcessedImage(tensorImage);
    final TensorBuffer outputLandmarks = TensorBufferFloat(outputShapes[0]);
    final TensorBuffer outputScores = TensorBufferFloat(outputShapes[1]);

    final inputs = <Object>[inputImage.buffer];

    final outputs = <int, Object>{
      0: outputLandmarks.buffer,
      1: outputScores.buffer,
    };

    interpreter!.runForMultipleInputs(inputs, outputs);
    if (outputScores.getDoubleValue(0) < 0) {
      return null;
    }
    final landmarkPoints = outputLandmarks.getDoubleList().reshape([468, 3]);
    final landmarkResults = <Offset>[];
    for (final point in landmarkPoints) {
      landmarkResults.add(
        Offset(
          point[0] / inputSize * image.width,
          point[1] / inputSize * image.height,
        ),
      );
    }
    return landmarkResults;
  }

  @override
  void dispose() {
    interpreter!.close();
    super.dispose();
  }
}

///top-level method to run FaceMesh Service on live feed
List<Offset>? runFaceMeshLive(Map<String, dynamic> params) {
  final faceMeshController = FaceMeshController(
      interpreter: Interpreter.fromAddress(params['address'] as int));
  final image =
      ImageUtil.convertCameraImage(params['cameraImage'] as CameraImage);
  final result = faceMeshController.predict(image!);
  return result;
}
