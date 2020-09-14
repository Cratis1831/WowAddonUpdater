import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:path/path.dart';
import 'package:archive/archive.dart';
import 'package:wow_addon_updater/env.dart';

Future<void> unzipFile({String zipFilePath, String extractPath, String file}) async {
  print('zipPath: $zipFilePath');
  print('extractPath: $extractPath');
  final bytes = File('$zipFilePath\\$file').readAsBytesSync();

  // Decode the Zip file
  final archive = ZipDecoder().decodeBytes(bytes);

  // Extract the contents of the Zip archive to disk.
  for (final file in archive) {
    final filename = file.name;
    if (file.isFile) {
      final data = file.content as List<int>;
      File(extractPath + filename)
        ..createSync(recursive: true)
        ..writeAsBytesSync(data);
    } else {
      Directory(extractPath + filename)..create(recursive: true);
    }
  }
}

Future<String> downloadUpdate({bool isAppUpdate, bool isUnzip, Dio dio, String url, String savePath}) async {
  String fileName = basename(Uri.parse(url).path);
  //savePath = '$savePath\\$fileName';
  String filePath = '$savePath\\$fileName';
  CancelToken cancelToken = CancelToken();
  String result = 'OK';

  try {
    await dio.download(url, filePath, cancelToken: cancelToken).then((value) async {
      if (isUnzip && isAppUpdate) {
        print('unzipping');
        await unzipFile(zipFilePath: savePath, extractPath: savePath, file: fileName).then((value) async {
          var updaterFile = new File('update.bat');
          await updaterFile.writeAsString(updaterFileString).then((value) async {
            await Process.run('start', ['update.bat'], runInShell: true, stdoutEncoding: systemEncoding);
          });
        });
      } else {
        await unzipFile(zipFilePath: savePath, extractPath: savePath, file: fileName).then((value) {
          final dir = Directory(filePath);
          dir.deleteSync(recursive: true);
        });
      }
    });
  } on DioError catch (e) {
    result = e.message;
  } on SocketException catch (e) {
    result = e.message;
  }
  return result;
}
