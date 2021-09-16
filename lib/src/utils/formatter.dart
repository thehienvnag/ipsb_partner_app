import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

class Formatter {
  static String dateFormat(DateTime? date) {
    if (date == null) return 'Date not set';
    return DateFormat('dd-MM-yyyy').format(date);
  }
  static String dateCaculator(DateTime? date){
    if (date == null) {
      return "";
    }
    int differenceInDays = new DateTime.now().difference(DateTime.parse(date.toString())).inHours;
    final fifteenAgo = new DateTime.now().subtract(new Duration(hours: differenceInDays));
    return timeago.format(fifteenAgo, locale: 'en');
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
