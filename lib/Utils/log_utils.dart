import 'package:flutter/material.dart';

abstract interface class LogUtil {
  static const String _defCode = '\x1B[';
  static const String _defEndCode = '\x1B[0m';
  static void _print({Object? message, String? colorCode}) {
    return debugPrint('$_defCode${colorCode}m$message$_defEndCode');
  }

  static void errorLog(Object message) => _print(message: message, colorCode: '31');

  static void successLog(Object message) => _print(message: message, colorCode: '32');

  static void debugLog(Object message) => _print(message: message, colorCode: '38;5;208');
}
