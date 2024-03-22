import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intelligent_camera/controller/scan_controller.dart';

class CameraView extends StatelessWidget {
  const CameraView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<ScanController>(
          init: ScanController(),
          builder: (controller) {
            return controller.isCameraInitialized.value
                ? Stack(
                    children: [
                      CameraPreview(controller.cameraController),
                      Positioned(
                        right:
                            (controller.x != null) ? (controller.x) * 500 : 100,
                        top:
                            (controller.y != null) ? (controller.y) * 700 : 100,
                        // right: 100,
                        // top: 100,
                        child: Container(
                          width: (controller.w != null)
                              ? controller.w * 100 * context.width / 100
                              : 200,

                          height: (!controller.h.isNegative)
                              ? controller.h * 100 * context.height / 100
                              : 100,

                          // width: 100,
                          // height: 200,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.deepPurple,
                              width: 3,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                color: Colors.white,
                                child: Text(
                                  controller.label,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                : const Center(child: Text("Loading Preview..."));
          }),
    );
  }
}

// class CameraView extends StatelessWidget {
//    const CameraView({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: GetBuilder<ScanController>(
//         init: ScanController(),
//         builder: (controller) {
//           return controller.isCameraInitialized.value
//               ? Stack(
//                   children: [
//                     CameraPreview(controller.cameraController),
//                     if (controller.x != null && controller.y != null)

//                       Positioned(
//                         right: controller.x * 500 ?? 100,
//                         top: controller.y * 700 ?? 100,
//                         child: Container(
//                           width: controller.w != null
//                               ? controller.w * 100 * context.width / 100
//                               : 200,
//                           height: controller.h != null && !controller.h.isNegative
//                               ? controller.h * 100 * context.height / 100
//                               : 100,
//                           decoration: BoxDecoration(
//                             border: Border.all(
//                               color: Colors.deepPurple,
//                               width: 3,
//                             ),
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                           child: Column(
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               Container(
//                                 color: Colors.white,
//                                 child: Text(
//                                   controller.label ?? '',
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                   ],
//                 )
//               : const Center(child: Text("Loading Preview..."));
//         },
//       ),
//     );
//   }
// }

