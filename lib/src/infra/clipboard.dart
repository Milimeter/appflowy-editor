import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:clipboard/clipboard.dart';

class AppFlowyClipboardData {
  const AppFlowyClipboardData({
    this.text,
    this.html,
  });
  final String? text;
  final String? html;
}

class AppFlowyClipboard {
  static AppFlowyClipboardData? _mockData;

  static Future<void> setData({
    String? text,
    String? html,
  }) async {
    if (!kIsWeb && Platform.isWindows && html != null) {
      if (!html.startsWith('<html><body>')) {
        html = '<html><body>$html</body></html>';
      }
    }

    await FlutterClipboard.copy(text ?? '');

    // The `clipboard` package currently does not support HTML clipboard data natively,
    // so you might need to find a way to handle HTML data on the clipboard in another manner
    // or wait for possible future updates if HTML support is essential.
  }

  static Future<AppFlowyClipboardData> getData() async {
    if (_mockData != null) {
      return _mockData!;
    }

    final text = await FlutterClipboard.paste();

    // As noted earlier, retrieving HTML data from the clipboard isn't supported by
    // the `clipboard` package. You'll need to handle HTML content differently or skip it.
    String? html; // Currently, HTML can't be retrieved.

    return AppFlowyClipboardData(
      text: text,
      html: html,
    );
  }

  @visibleForTesting
  static void mockSetData(AppFlowyClipboardData? data) {
    _mockData = data;
  }
}
