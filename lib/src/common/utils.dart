import 'package:intl/intl.dart';

class Utils {
  static String getFormattedDate(String date) {
    List<String> dateParts = date.split('-');
    String formattedDateString =
        '${dateParts[0]}-${dateParts[1].padLeft(2, '0')}-${dateParts[2].padLeft(2, '0')}';
    final dateTime = DateTime.parse(formattedDateString);
    String formattedDate = DateFormat('MMMM d, yyyy').format(dateTime);
    return formattedDate;
  }
}
