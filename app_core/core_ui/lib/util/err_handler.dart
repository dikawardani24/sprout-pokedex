import 'dart:async';
import 'dart:io';

import 'package:core_ui/res/string_res.dart';

String getErrorMessage(dynamic error) {
  if (error is SocketException || error is TimeoutException) {
    return StringErrRes.errNoInternet;
  } else if (error is HttpException) {
    return StringErrRes.errServer;
  } else if (error is String) {
    return error;
  } else {
    return StringErrRes.errUnknown;
  }
}