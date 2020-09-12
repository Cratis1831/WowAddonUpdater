import 'dart:typed_data';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:archive/archive.dart';

Future<void> unzipFile(String path, String file) async {
  final bytes = File('$path$file').readAsBytesSync();

  // Decode the Zip file
  final archive = ZipDecoder().decodeBytes(bytes);

  // Extract the contents of the Zip archive to disk.
  for (final file in archive) {
    final filename = file.name;
    if (file.isFile) {
      final data = file.content as List<int>;
      File(path + filename)
        ..createSync(recursive: true)
        ..writeAsBytesSync(data);
    } else {
      Directory(path + filename)..create(recursive: true);
    }
  }
}

Future<String> downloadFile(String url, {String filename}) async {
  var httpClient = http.Client();
  var request = new http.Request('GET', Uri.parse(url));
  var response = httpClient.send(request);
  if (filename == null) {
    filename = basename(Uri.parse(url).path);
    print(filename);
  }
  String dir = r"C:\Program Files (x86)\World of Warcraft\_retail_\dump\";

  List<List<int>> chunks = new List();
  int downloaded = 0;

  response.asStream().listen((http.StreamedResponse r) {
    r.stream.listen((List<int> chunk) {
      // Display percentage of completion
      //print('downloadPercentage: ${downloaded / r.contentLength * 100}');
      chunks.add(chunk);
      downloaded += chunk.length;
      //Text(key: )
      return 'downloadPercentage ondata: ${downloaded / r.contentLength * 100}';
    }, onError: (r) async {
      print('re: ${r.reasonPhrase}');
      return;
    }, onDone: () async {
      // Display percentage of completion
      print('downloadPercentage ondone: ${downloaded / r.contentLength * 100}');
      print('ra: ${r.reasonPhrase}');

      // Save the file
      File file = new File('$dir/$filename');
      final Uint8List bytes = Uint8List(r.contentLength);
      int offset = 0;
      for (List<int> chunk in chunks) {
        bytes.setRange(offset, offset + chunk.length, chunk);
        offset += chunk.length;
      }
      await file.writeAsBytes(bytes);
      //await unzipFile(dir, filename);

      return "Done";
    });
  });
  return "Up to date";
}
