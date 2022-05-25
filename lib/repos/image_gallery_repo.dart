import 'package:gallery_machine_test/interfaces/i_image_galary_repo.dart';
import 'package:gallery_machine_test/models/api_response_model.dart';
import 'package:gallery_machine_test/models/image_response_model.dart';
import 'package:gallery_machine_test/services/dio_client.dart';
import 'package:gallery_machine_test/utils/enums/general_enums.dart';

class ImageGalleryRepo implements IImageGallery {
  final _dioClient = DioClient();

  @override
  Future<ApiResponse<List<ImageResponseModel>>> getImagesToGallery() async {
    try {
      final response = await _dioClient.request(
        uri: ApiUrls.baseUrl,
        method: ApiMethod.get,
      );
      List<ImageResponseModel> tempList = [];
      for (Map<String, dynamic> imageData in response.data) {
        tempList.add(
          ImageResponseModel.fromJson(imageData),
        );
      }

      return ApiResponse<List<ImageResponseModel>>.completed(tempList);
    } catch (e) {
      return ApiResponse<List<ImageResponseModel>>.error(
        e.toString().replaceFirst(RegExp(r'Exception'), ""),
      );
    }
  }
}
