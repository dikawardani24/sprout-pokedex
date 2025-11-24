import 'dart:async';
import 'dart:io';

String getErrorMessage(dynamic error) {
  if (error is SocketException || error is TimeoutException) {
    return 'No internet connection. Please check your network.';
  } else if (error is HttpException) {
    return 'Server error. Please try again later.';
  } else if (error is String) {
    return error;
  } else {
    return 'An unexpected error occurred. Please try again.';
  }
}