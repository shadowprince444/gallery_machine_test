import 'package:gallery_machine_test/models/image_response_model.dart';
import 'package:gallery_machine_test/repos/image_gallery_repo.dart';
import 'package:gallery_machine_test/utils/enums/general_enums.dart';
import 'package:get/get.dart';

class ImageGalleryController extends GetxController {
  final _imageRepo = ImageGalleryRepo();

  RxInt get albumCount => _listOfImages.length.obs;
  List<List<ImageResponseModel>> _listOfImages = [];

  RxList<ImageResponseModel> getGroupedImageResponseListByIndex(int index) => _listOfImages[index].obs;

  Future<void> getImages() async {
    final listOfAllImages = await fetchImagesFromImageRepo();
    _listOfImages = generateListGroupByAlbumId(listOfAllImages);
  }

  Future<List<ImageResponseModel>> fetchImagesFromImageRepo() async {
    final response = await _imageRepo.getImagesToGallery();
    if (response.status == ApiResponseStatus.completed) {
      return response.data!;
    } else {
      return <ImageResponseModel>[];
    }
  }

  List<List<ImageResponseModel>> generateListGroupByAlbumId(List<ImageResponseModel> imageList) {
    var list = buildList(imageList);
    return List.generate(
      list.keys.length,
      (index) => list[list.keys.toList()[index]]!,
    );
  }

  Map<T, List<S>> groupBy<S, T>(Iterable<S> values, T Function(S) key) {
    var map = <T, List<S>>{};
    for (var element in values) {
      (map[key(element)] ??= <S>[]).add(element);
    }
    return map;
  }

  Map<int, List<ImageResponseModel>> buildList(List<ImageResponseModel> list) =>
      groupBy<ImageResponseModel, int>(Iterable.generate(list.length, (index) => list[index]), (ImageResponseModel s) => s.albumId);
}
