import 'package:logger/logger.dart';

class MyLogger {
  static Logger log =
      Logger(printer: PrettyPrinter(colors: true, printEmojis: true));
}
