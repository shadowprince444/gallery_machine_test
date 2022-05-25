import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:gallery_machine_test/utils/enums/general_enums.dart';

///for storing [API] urls
class ApiUrls {
  static String baseUrl = "https://jsonplaceholder.typicode.com/photos";
}

/// Service for calling [REST] [APIs] using [Dio]
class DioClient {
  static Dio? _dioWithoutToken;

  /// helps to create a [Singleton] instance of [Dio]
  Dio get unAuthenticatedInstance {
    _dioWithoutToken ??= _initWithOutToken();
    return _dioWithoutToken!;
  }

  DioClient() {
    _dioWithoutToken ??= _initWithOutToken();
  }

  /// initializing [Dio] with [BaseOptions]
  Dio _initWithOutToken() {
    Dio _dio = Dio();
    _dio.options = BaseOptions(
      baseUrl: ApiUrls.baseUrl,
      followRedirects: false,
      validateStatus: (status) {
        if (status != null) {
          return status < 500;
        } else {
          return false;
        }
      },
      contentType: 'application/json',
      headers: {
        "X-Requested-With": "XMLHttpRequest",
        HttpHeaders.contentTypeHeader: "application/json",
      },
    );
    // _dio.options.baseUrl = ApiUrls.baseUrl;
    return _dio;
  }

  ///for [API] request and response handling
  ///[uri] is the [path] in the [URL],
  ///[method] is the [ApiMethod] enum that determines the request type(ie, [Get],[Post],[Put]..etc),
  ///[params] is the data to be sent in the body
  ///[formData] is the data to be sent in the [FormData] (used for image uploading).
  Future<Response> request({
    required String uri,
    required ApiMethod method,
    String? params,
    FormData? formData,
  }) async {
    Response? response;

    try {
      if (method == ApiMethod.post) {
        response = await _dioWithoutToken!.postUri(
          Uri.parse(uri),
          data: formData ?? params,
        );
      } else if (method == ApiMethod.put) {
        response = await _dioWithoutToken!.putUri(
          Uri.parse(uri),
          data: formData ?? params,
        );
      } else if (method == ApiMethod.delete) {
        response = await _dioWithoutToken!.deleteUri(Uri.parse(uri));
      } else if (method == ApiMethod.patch) {
        response = await _dioWithoutToken!.patchUri(Uri.parse(uri));
      } else {
        response = await _dioWithoutToken!.getUri(Uri.parse(uri));
      }

      if (response.statusCode == 200) {
        return response;
      } else if (response.statusCode == 201) {
        return response;
      } else if (response.statusCode == 422) {
        throw Exception("Un-processable request");
      } else if (response.statusCode == 400) {
        throw Exception(response.data!["message"]);
      } else if (response.statusCode == 401) {
        throw Exception("Unauthorized");
      } else if (response.statusCode == 500) {
        throw Exception("Server Error");
      } else {
        throw Exception("Something does went wrong");
      }
    } on SocketException catch (e) {
      debugPrint(e.message);
      throw Exception("Not Internet Connection");
    } on FormatException catch (e) {
      debugPrint(e.message);
      throw Exception("Bad response format");
    } on DioError catch (e) {
      debugPrint("$e");
      throw Exception(e);
    } catch (e) {
      debugPrint("$e");
      throw Exception("$e");
    }
  }
}
