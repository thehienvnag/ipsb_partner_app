import 'package:intl/intl.dart';

class Formatter {
  static String dateFormat(DateTime? date) {
    if (date == null) return 'Date not set';
    return DateFormat('dd-MM-yyyy').format(date);
  }

  static String fromPrice(double price) {
    final formatter = new NumberFormat("###,###,###.##");
    return formatter.format(price);
  }
}
