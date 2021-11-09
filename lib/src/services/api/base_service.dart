import 'package:get/get.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:get/get_connect/http/src/status/http_status.dart';

import 'package:ipsb_partner_app/src/data/api_helper.dart';
import 'package:ipsb_partner_app/src/data/file_upload_utils.dart';
import 'package:ipsb_partner_app/src/models/paging.dart';
import 'package:ipsb_partner_app/src/services/global_states/auth_services.dart';

abstract class BaseService<T> {
  IApiHelper _apiHelper = Get.find();

  /// Set decode function for entity
  T fromJson(Map<String, dynamic> json);

  /// Set api endpoint for entity
  String endpoint();

  Future<T?> getByIdBase(int id) async {
    final callback = () => _apiHelper.getById(endpoint(), id);
    Response res = await AuthServices.handleUnauthorized(callback);
    if (res.isOk) {
      return fromJson(res.body);
    }
  }

  Future<T?> postPure(String uri, Map<String, String> body) async {
    Response res = await _apiHelper.postOne(uri, body);
    if (res.isOk) {
      return fromJson(res.body);
    }
  }

  Future<T?> postNoAuth(String endpoint, Map<String, String> body) async {
    Response res = await _apiHelper.postOne(endpoint, body);
    if (res.statusCode == HttpStatus.ok) {
      return fromJson(res.body);
    }
  }

  /// Get paging instance from API with [query]
  Future<Paging<T>> getPagingBase(Map<String, dynamic> query) async {
    final callback = () => _apiHelper.getAll(endpoint(), query: query);
    Response res = await AuthServices.handleUnauthorized(callback);
    if (res.isOk) {
      Paging<T> paging = Paging.fromJson(res.body);
      paging.convertToList(fromJson);
      return paging;
    }
    return Paging.defaultInstance<T>();
  }

  /// Get list instances from API with [query]
  Future<List<T>> getAllBase(Map<String, dynamic> query) async {
    final paging = await getPagingBase(query);
    return paging.content ?? [];
  }

  /// Get list instances from API with [query]
  Future<int> countBase(Map<String, dynamic> query,
      [bool cacheAllow = false]) async {
    final callback = () => _apiHelper.count(endpoint() + "/count", query);
    Response res = await AuthServices.handleUnauthorized(callback);
    return res.body;
  }

  /// Post an instance with [body]
  Future<T?> postBase(Map<String, dynamic> body) async {
    final callback = () => _apiHelper.postOne(endpoint(), body);
    Response res = await AuthServices.handleUnauthorized(callback);
    if (res.statusCode == HttpStatus.created) {
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
    final callback = () => _apiHelper.postOneWithFiles(endpoint(), body, files);
    Response res = await AuthServices.handleUnauthorized(callback);
    if (res.statusCode == HttpStatus.created) {
      return fromJson(res.body);
    }
  }

  /// Post an instance with [body]
  Future<T?> postWithOneFileBase(
    Map<String, dynamic> body,
    String filePath,
  ) async {
    final callback = () => _apiHelper.postOneWithFile(
          endpoint(),
          body,
          FileUploadUtils.convertToMultipart(filePath),
        );
    Response res = await AuthServices.handleUnauthorized(callback);
    if (res.statusCode == HttpStatus.created) {
      return fromJson(res.body);
    }
  }

  /// Put an instance with [id] and [body]
  Future<bool> putBase(dynamic id, Map<String, dynamic> body) async {
    final callback = () => _apiHelper.putOne(endpoint(), id, body);
    Response res = await AuthServices.handleUnauthorized(callback);
    if (res.statusCode == HttpStatus.noContent) {
      return true;
    }
    return false;
  }

  /// Put an instance with [id] and [body]
  Future<bool> putBaseWithAdditionalSegment(
      dynamic id, String additionalSegment, Map<String, dynamic> body) async {
    final callback = () => _apiHelper.putOneWithAdditionalSegment(
        endpoint(), additionalSegment, id, body);
    Response res = await AuthServices.handleUnauthorized(callback);
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
      final callback = () => _apiHelper.putOneWithOneFile(
          endpoint() + "/" + id.toString(),
          body,
          FileUploadUtils.convertToMultipart(filePath),
          fileName);
      Response res = await AuthServices.handleUnauthorized(callback);
      if (res.statusCode == HttpStatus.noContent) {
        return true;
      }
    } else {
      final callback = () => _apiHelper.putOneWithOneFile(
          endpoint() + "/" + id.toString(), body, null, fileName);
      Response res = await AuthServices.handleUnauthorized(callback);
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
    final callback = () => _apiHelper.putOneWithFiles(endpoint(), body, files);
    Response res = await AuthServices.handleUnauthorized(callback);
    if (res.statusCode == HttpStatus.noContent) {
      return fromJson(res.body);
    }
  }

  /// Delete an instance
  Future<bool> deleteBase(dynamic id) async {
    final callback = () => _apiHelper.deleteOne(endpoint(), id);
    Response res = await AuthServices.handleUnauthorized(callback);
    return res.statusCode == HttpStatus.noContent;
  }
}
