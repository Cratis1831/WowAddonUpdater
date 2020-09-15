import 'dart:io';
import 'dart:convert';

void createFile(Map<String, dynamic> content, Directory dir, String fileName, bool isUpdate) {
  File file = new File(dir.path + "\\" + fileName);
  if (isUpdate) {
    file.createSync();
    file.writeAsStringSync(jsonEncode(content));
  }
}
