import 'package:get/get.dart';
import 'package:mediapipedemo/src/controllers/faceMeshController.dart';
import 'package:mediapipedemo/src/controllers/inferenceController.dart';

class HomeBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<FaceMeshController>(FaceMeshController());
    Get.put<InferenceController>(InferenceController());
  }
}
