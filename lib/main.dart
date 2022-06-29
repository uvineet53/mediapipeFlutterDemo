import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:mediapipedemo/src/bindings/homeBinding.dart';
import 'package:mediapipedemo/src/views/cameraView.dart';
import 'package:mediapipedemo/src/views/homeView.dart';

List<CameraDescription> cameras = [];
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  runApp(App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialRoute: "/",
      getPages: [
        GetPage(name: "/", page: () => HomeView(), binding: HomeBinding()),
        GetPage(name: "/facemesh", page: () => CameraView())
      ],
    );
  }
}
