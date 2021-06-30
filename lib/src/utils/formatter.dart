import 'package:intl/intl.dart';

class Formatter {
  static String dateFormat(DateTime? date) {
    if (date == null) return 'Date not set';
    return DateFormat('dd-MM-yyyy').format(date);
  }

  static String fromPrice(double price) {
    final formatter = new NumberFormat("###,###,###");

    return formatter.format(price);
  }

  static String shorten(String? s, [int n = 30]) {
    if (s == null) {
      return '';
    }
    if (s.length < n) {
      return s;
    }
    var cut = s.indexOf(' ', n);
    if (cut == -1) return s;
    return s.substring(0, cut) + ' ...';
  }
}
