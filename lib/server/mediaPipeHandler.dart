import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'dart:convert';

class MediapipeHandler {
  final String serverUrl;

  MediapipeHandler({required this.serverUrl});

  Future<Map<String, dynamic>?> sendImage(File imageFile) async {
    try {
      var url = Uri.parse('$serverUrl/process_image/');

      var request = http.MultipartRequest('POST', url)
        ..files.add(
          await http.MultipartFile.fromPath(
            'file',
            imageFile.path,
            contentType:
                MediaType.parse(lookupMimeType(imageFile.path) ?? 'image/jpeg'),
          ),
        );

      var response = await request.send();
      if (response.statusCode == 200) {
        String responseBody = await response.stream.bytesToString();
        return jsonDecode(responseBody);
      } else {
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }
}
