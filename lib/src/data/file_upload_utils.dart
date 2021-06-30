import 'dart:io';

import 'package:get/get.dart';

class FileUploadUtils {
  static MultipartFile convertToMultipart(String path) {
    return MultipartFile(File(path),
        filename: 'imageUrl', contentType: 'application/x-tar');
  }
}
