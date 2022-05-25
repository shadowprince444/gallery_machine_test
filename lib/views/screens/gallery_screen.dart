import 'package:flutter/material.dart';
import 'package:gallery_machine_test/controllers/image_galary_controller.dart';
import 'package:gallery_machine_test/models/image_response_model.dart';
import 'package:gallery_machine_test/utils/screen_utils/size_config.dart';
import 'package:gallery_machine_test/utils/screen_utils/widgets/responsive_safe_area.dart';
import 'package:gallery_machine_test/utils/screen_utils/widgets/spacing_widgets.dart';
import 'package:gallery_machine_test/utils/theme/text_themes.dart';
import 'package:gallery_machine_test/views/widgets/image_tile.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

class GalleryScreen extends StatelessWidget {
  const GalleryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final imageController = Get.find<ImageGalleryController>();
    return Scaffold(
      appBar: AppBar(
        title: Text("Photos"),
      ),
      body: ResponsiveSafeArea(
        builder: (context, size) {
          return SizedBox(
            height: size.height,
            width: size.width,
            child: FutureBuilder(
                future: imageController.getImages(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return Obx(() {
                      return ListView.separated(
                          itemCount: imageController.albumCount.value,
                          separatorBuilder: (context, index) => const VSpace(20),
                          itemBuilder: (context, mainIndex) {
                            List<ImageResponseModel> imageList = imageController.getGroupedImageResponseListByIndex(mainIndex);
                            return Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8.hdp(),
                                vertical: 10.vdp(),
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                    10.vdp(),
                                  ),
                                  color: Colors.blueAccent.withOpacity(
                                    .25,
                                  ),
                                ),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8.hdp(),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    VSpace(10),
                                    Text(
                                      "Album id: ${imageList.first.albumId}",
                                      style: AppTextThemes().headline1,
                                    ),
                                    VSpace(10),
                                    ResponsiveSafeArea(builder: (context, innerSize) {
                                      return GridView.builder(
                                        physics: const NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount: imageList.length,
                                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 4,
                                        ),
                                        itemBuilder: (context, index) {
                                          final imageModel = imageList[index];
                                          return ImageTile(
                                            imageUrl: imageModel.url,
                                            previewUrl: imageModel.thumbnailUrl,
                                            imageHeight: innerSize.width / 4,
                                            imageWidth: innerSize.width / 4,
                                          );
                                        },
                                      );
                                    }),
                                  ],
                                ),
                              ),
                            );
                          });
                    });
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                }),
          );
        },
      ),
    );
  }
}
