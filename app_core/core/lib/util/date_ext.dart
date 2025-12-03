import 'package:intl/intl.dart';

const timePattern = "Hms";
const datePattern = 'EEEEE, dd MMMM yyyy $timePattern';

extension DateHelper on DateTime? {

  String formatDateTime(String pattern) {
    final toFormat = this;
    if (toFormat != null) {
      try {
        return DateFormat(pattern).format(toFormat);
      } catch (e) {
        return "";
      }
    }
    return "";
  }

  String format() => formatDateTime(datePattern);

  String formatTime() => formatDateTime(timePattern);
}

extension DateStringHelper on String {
  DateTime? parse() {
    final toParse = this;
    if (toParse.isEmpty) return null;
    try {
      return DateFormat(datePattern).parse(toParse);
    } catch(e) {
      return null;
    }
  }
}