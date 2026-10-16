import 'dart:io';

import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class FileDownloader {
  FileDownloader._();

  static Future<void> byUrl(
    String fileUrl,
    String fileName,
    Map<String, String> headers,
  ) async {
    if (Platform.isAndroid) {
      final status = await Permission.storage.request();
      await Permission.notification.request();
      if (!status.isGranted && await Permission.storage.isPermanentlyDenied) {
        return;
      }
    }

    Directory? directory;
    if (Platform.isAndroid) {
      directory = Directory('/storage/emulated/0/Download');
    } else {
      directory = await getApplicationDocumentsDirectory();
    }

    final exDir = Directory(directory.path);
    if (!await exDir.exists()) {
      await exDir.create(recursive: true);
    }

    await FlutterDownloader.enqueue(
      url: fileUrl,
      headers: headers,
      savedDir: directory.path,
      fileName: fileName,
      showNotification: true,
      openFileFromNotification: true,
    );
  }
}
