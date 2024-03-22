import 'package:camera/camera.dart';
import 'package:flutter_tflite/flutter_tflite.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class ScanController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    initTFLite(); // Load TensorFlow Lite model first
    initCamera(); // Then initialize the camera
  }

  @override
  void dispose() {
    super.dispose();
    cameraController.dispose();
  }

  late CameraController cameraController;
  late List<CameraDescription> cameras;
  var isCameraInitialized = false.obs;
  var cameraCount = 0;
  var label = "";
  // ignore: prefer_typing_uninitialized_variables
  var x, y, w, h = 0.0;

  initCamera() async {
    if (await Permission.camera.request().isGranted) {
      try {
        cameras = await availableCameras();
        cameraController = CameraController(cameras[0], ResolutionPreset.max);
        await cameraController.initialize().then((_) {
          cameraController.startImageStream((image) {
            cameraCount++;
            if (cameraCount % 10 == 0) {
              cameraCount = 0;
              objectDetector(image);
            }
            update();
          });
        });
        isCameraInitialized(true);
      } catch (e) {
        print('Error initializing camera: $e');
      }
    } else {
      print("Permission Denied");
    }
  }

  initTFLite() async {
    try {
      await Tflite.loadModel(
        model: "assets/ssd_mobilenet.tflite",
        labels: "assets/ssd_mobilenet.txt",
        isAsset: true,
        numThreads: 1,
        useGpuDelegate: false,
      );
    } catch (e) {
      print('Error loading TensorFlow Lite model: $e');
    }
  }

  objectDetector(CameraImage image) async {
    var detector = await Tflite.detectObjectOnFrame(
      bytesList: image.planes.map((e) => e.bytes).toList(),
      asynch: true,
      imageHeight: image.height,
      imageWidth: image.width,
      numBoxesPerBlock: 5,
      numResultsPerClass: 5,
      imageMean: 127.5,
      imageStd: 127.5,
      rotation: 90,
      threshold: 0.2,
    );
    if (detector != null) {
      print("Detection result: $detector");
      var ourDetector = detector.first;
      if (ourDetector['confidenceInClass'] * 100 > 45) {
        label = ourDetector['detectedClass'].toString();
        w = ourDetector['Rect']['w'];
        h = ourDetector['Rect']['h'];
        x = ourDetector['Rctect']['x'];
        y = detector.first['Rect']['y'];
        print('Label is $label');
      }
      update();
    }
  }
}
