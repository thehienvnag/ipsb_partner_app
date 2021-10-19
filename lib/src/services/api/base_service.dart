import 'package:get/get.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:get/get_connect/http/src/status/http_status.dart';

import 'package:ipsb_partner_app/src/data/api_helper.dart';
import 'package:ipsb_partner_app/src/data/file_upload_utils.dart';
import 'package:ipsb_partner_app/src/models/paging.dart';

abstract class BaseService<T> {
  IApiHelper _apiHelper = Get.find();

  /// Set decode function for entity
  T fromJson(Map<String, dynamic> json);

  /// Set api endpoint for entity
  String endpoint();

  Future<T?> getByIdBase(int id) async {
    Response response = await _apiHelper.getById(endpoint(), id);

    if (response.isOk) {
      return fromJson(response.body);
    }
  }

  /// Get paging instance from API with [query]
  Future<Paging<T>> getPagingBase(Map<String, dynamic> query) async {
    Response res = await _apiHelper.getAll(endpoint(), query: query);
    Paging<T> paging = Paging.fromJson(res.body);
    paging.convertToList(fromJson);
    return paging;
  }

  /// Get list instances from API with [query]
  Future<List<T>> getAllBase(Map<String, dynamic> query) async {
    Response res = await _apiHelper.getAll(endpoint(), query: query);
    Paging<T> paging = Paging.fromJson(res.body);
    paging.convertToList(fromJson);
    return paging.content ?? [];
  }

  /// Get list instances from API with [query]
  Future<int> countBase(Map<String, dynamic> query,
      [bool cacheAllow = false]) async {
    // final callback = () => _apiHelper.count(endpoint() + "/count", query);
    // Response res = await AuthServices.handleUnauthorized(callback);
    Response res = await _apiHelper.count(endpoint() + "/count", query);
    print("This is body "+res.body.toString());
    return res.body;
  }

  /// Post an instance with [body]
  Future<T?> postBase(Map<String, dynamic> body) async {
    Response res = await _apiHelper.postOne(endpoint(), body);
    print("HTTP STATUS CODE: " +
        res.statusCode.toString() +
        "========================================");
    if (res.statusCode == HttpStatus.created) {
      return fromJson(res.body);
    }
    if (res.statusCode == HttpStatus.ok) {
      return fromJson(res.body);
    }
  }

  /// Post an instance with [body]
  Future<T?> postWithFilesBase(
    Map<String, dynamic> body,
    List<String> filePaths,
  ) async {
    List<MultipartFile> files = filePaths
        .map((path) => FileUploadUtils.convertToMultipart(path))
        .toList();
    Response res = await _apiHelper.postOneWithFiles(endpoint(), body, files);
    if (res.statusCode == HttpStatus.created) {
      return fromJson(res.body);
    }
  }

  /// Post an instance with [body]
  Future<T?> postWithOneFileBase(
    Map<String, dynamic> body,
    String filePath,
  ) async {
    Response res = await _apiHelper.postOneWithFile(
      endpoint(),
      body,
      FileUploadUtils.convertToMultipart(filePath),
    );
    if (res.statusCode == HttpStatus.created) {
      return fromJson(res.body);
    }
  }

  /// Put an instance with [id] and [body]
  Future<bool> putBase(dynamic id, Map<String, dynamic> body) async {
    Response res = await _apiHelper.putOne(endpoint(), id, body);
    if (res.statusCode == HttpStatus.noContent) {
      return true;
    }
    return false;
  }

  // /// Put an instance with [body] and a file path [filePath]
  // Future<T?> putWithOneFileBase(
  //   Map<String, dynamic> body,
  //   String filePath,
  // ) async {
  //   Response res = await _apiHelper.putOneWithOneFile(
  //     endpoint(),
  //     body,
  //     FileUploadUtils.convertToMultipart(filePath),
  //   );
  //   if (res.statusCode == HttpStatus.noContent) {
  //     return fromJson(res.body);
  //   }
  // }

  /// Put an instance with [body] and a file path [filePath]
  Future<bool> putWithOneFileBase(
      Map<String, dynamic> body, String filePath, int id,
      [String fileName = "imageUrl"]) async {
    if (filePath.isNotEmpty) {
      Response res = await _apiHelper.putOneWithOneFile(
          endpoint() + "/" + id.toString(),
          body,
          FileUploadUtils.convertToMultipart(filePath),
          fileName);
      if (res.statusCode == HttpStatus.noContent) {
        return true;
      }
    } else {
      Response res = await _apiHelper.putOneWithOneFile(
          endpoint() + "/" + id.toString(), body, null, fileName);
      if (res.statusCode == HttpStatus.noContent) {
        return true;
      }
    }

    return false;
  }

  /// Put an instance with [body]
  Future<T?> putWithFilesBase(
    Map<String, dynamic> body,
    List<String> filePaths,
  ) async {
    List<MultipartFile> files = filePaths
        .map((path) => FileUploadUtils.convertToMultipart(path))
        .toList();
    Response res = await _apiHelper.putOneWithFiles(endpoint(), body, files);
    if (res.statusCode == HttpStatus.noContent) {
      return fromJson(res.body);
    }
  }

  /// Delete an instance
  Future<bool> deleteBase(dynamic id) async {
    Response res = await _apiHelper.deleteOne(endpoint(), id);
    return res.statusCode == HttpStatus.noContent;
  }
}
