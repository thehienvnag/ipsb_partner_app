import 'dart:io';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class Utils {
  static double calDistance(Offset p1, Offset p2) {
    var xSquare = pow(p2.dx - p1.dx, 2);
    var ySquare = pow(p2.dy - p1.dy, 2);
    return sqrt(xSquare + ySquare);
  }

  static String genRandStr(int len) {
    var r = Random();
    const _chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890';
    return List.generate(len, (index) => _chars[r.nextInt(_chars.length)])
        .join();
  }

  static String date(DateTime? date, [String formatter = 'dd-MM-yyyy']) {
    if (date == null) return 'Date not set';
    return DateFormat(formatter).format(date);
  }

  static ImageProvider<Object> resolveFileImg(String? url, String? altUrl) {
    if ((url == null || url.isEmpty) && (altUrl == null || altUrl.isEmpty)) {
      throw Exception("Required file image or alternative image");
    }
    if (url != null && url.isNotEmpty) {
      return FileImage(File(url));
    }
    return NetworkImage(altUrl!);
  }

  static String parseDateTimeToDate(DateTime? date) {
    if (date == null) {
      return "Data not set";
    }
    var formatter = new DateFormat.yMMMEd('en-US');
    String formatDate = formatter.format(date);
    return formatDate;
  }

  /// Uuid of beacon
  ///
  /// [uuid]: uuid string
  /// [macAddress]: mac address string
  static String getUuid(String uuid, String? macAddress) {
    final Map<String, String> listUuid = const {
      "65:23:A4:38:D0:E5": "fda50693-a4e2-4fb1-afcf-c6eb07647521",
      "2C:92:E9:7B:AF:E0": "fda50693-a4e2-4fb1-afcf-c6eb07647522",
      "C3:3B:1F:7E:1B:E1": "fda50693-a4e2-4fb1-afcf-c6eb07647523",
      "17:43:CC:F0:61:D6": "fda50693-a4e2-4fb1-afcf-c6eb07647524",
      "74:6C:B8:18:9D:C8": "fda50693-a4e2-4fb1-afcf-c6eb07647525",
    };
    if (uuid == "fda50693-a4e2-4fb1-afcf-c6eb07647825" &&
        macAddress != null &&
        listUuid.containsKey(macAddress)) {
      return listUuid[macAddress]!;
    }
    return uuid;
  }

  static double average(Iterable<double> list) {
    return list.reduce((a, b) => a + b) / list.length;
  }
}
