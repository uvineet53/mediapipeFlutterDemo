import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mediapipedemo/src/controllers/faceMeshController.dart';
import 'package:mediapipedemo/src/controllers/inferenceController.dart';
import 'package:mediapipedemo/src/utils/isolateUtil.dart';
import 'package:mediapipedemo/src/utils/painters/facemeshPainter.dart';
import 'package:mediapipedemo/main.dart';
import 'package:velocity_x/velocity_x.dart';

class CameraView extends StatefulWidget {
  const CameraView({Key? key}) : super(key: key);

  @override
  State<CameraView> createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView> {
  CameraController? _cameraController;

  final FaceMeshController _faceMeshController = Get.find();
  final InferenceController _inferenceController = Get.find();
  late double _ratio;
  int _cameraIndex = 1;
  @override
  void initState() {
    runInitConfig();
    super.initState();
  }

  void runInitConfig() async {
    _inferenceController.isolateUtil = IsolateUtil();
    await _inferenceController.isolateUtil?.initIsolate();
    await _faceMeshController.loadModel();
    await initCamera(_cameraIndex);
  }

  Future<void> initCamera(int index) async {
    _cameraController = CameraController(cameras[index], ResolutionPreset.high);
    await _cameraController!.initialize().then((value) async {
      if (!mounted) {
        return;
      } else {
        setState(() {
          _cameraController!.startImageStream((CameraImage image) async {
            await _inference(image: image);
          });
        });
      }
    });
  }

  Future<void> _inference({required CameraImage image}) async {
    if (!mounted) return;
    if (_inferenceController.isolateUtil != null) {
      if (_inferenceController.predicting) {
        return;
      }
      await _inferenceController.inference(
          cameraImage: image, address: _faceMeshController.address);
    }
  }

  toggleCamera() async {
    setState(() {
      if (_cameraIndex == 0) {
        _cameraIndex = 1;
      } else {
        _cameraIndex = 0;
      }
    });
    if (_cameraController != null) {
      _cameraController!.stopImageStream();
      await initCamera(_cameraIndex);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return Container(
        color: Colors.black,
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    _ratio = (Get.width) / (_cameraController!.value.previewSize!.height + 150);

    return Scaffold(
        backgroundColor: Colors.grey[900],
        appBar: AppBar(
          title: "MEDIAPIPE FACEMESH"
              .text
              .semiBold
              .xl
              .textStyle(GoogleFonts.poppins(letterSpacing: 1.5))
              .make(),
          centerTitle: true,
          elevation: 0.0,
          backgroundColor: Colors.grey[900],
        ),
        floatingActionButton: FloatingActionButton.large(
          backgroundColor: Colors.white,
          onPressed: () => toggleCamera(),
          child: const Icon(
            Icons.cameraswitch_outlined,
            color: Colors.black,
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        body: Padding(
          padding: const EdgeInsets.all(18.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: SizedBox(
              height: Get.height * .7,
              child: Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  if (_cameraController != null)
                    CameraPreview(_cameraController!)
                  else
                    Container(),
                  Obx(() => _inferenceController.inferenceResults != null
                      ? CustomPaint(
                          painter: FaceMeshPainter(
                              points: _inferenceController.inferenceResults,
                              ratio: _ratio),
                        )
                      : Container()),
                ],
              ),
            ),
          ),
        ));
  }

  @override
  void dispose() {
    super.dispose();
    _cameraController?.dispose();
  }
}
