import 'package:logger/logger.dart';

var logger = Logger(
  // Use the default LogFilter (-> only log in debug mode)
  printer: PrettyPrinter(
      stackTraceBeginIndex: 0,
      methodCount: 0,
      noBoxingByDefault: true), // Use the PrettyPrinter to format and print log
  output: null,
);
appLog(var data, {Level? level}) {
  switch (level) {
    case Level.debug:
      logger.d(data);
      break;
    case Level.error:
      logger.e(data);
      break;
    case Level.info:
      logger.i(data);
      break;
    case Level.warning:
      logger.w(data);
      break;
    case Level.verbose:
      logger.v(data);
      break;
    case Level.wtf:
      logger.wtf(data);
      break;

    default:
      logger.i(data);
  }
}
