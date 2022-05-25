import 'package:flutter/material.dart';
import 'package:gallery_machine_test/controllers/image_galary_controller.dart';
import 'package:gallery_machine_test/views/screens/gallery_screen.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(ImageGalleryController());
    return const GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: GalleryScreen(),
    );
  }
}
