import 'dart:convert';
import 'dart:io';

Future<Map<String, dynamic>> loadJson(String path) async {
  final file = File(path);
  final jsonString = await file.readAsString();
  return jsonDecode(jsonString);
}
