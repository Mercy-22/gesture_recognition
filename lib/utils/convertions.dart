import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:image_picker/image_picker.dart';

Future<ui.Image> xFileToUiImage(XFile file) async {
  Uint8List bytes = await file.readAsBytes(); // Convert XFile to bytes
  Completer<ui.Image> completer = Completer();
  ui.decodeImageFromList(bytes, (img) {
    completer.complete(img);
  });
  return completer.future;
}

Future<ui.Image> fileToUiImage(File file) async {
  Uint8List imageBytes = await file.readAsBytes(); // Read file as bytes
  ui.Codec codec = await ui.instantiateImageCodec(imageBytes);
  ui.FrameInfo frameInfo = await codec.getNextFrame();
  return frameInfo.image; // Return ui.Image
}

List<Map<String, double>> parseLandmarks(Map<String, dynamic> response) {
  List<dynamic> rawLandmarks = response['landmarks'];
  return rawLandmarks
      .map<Map<String, double>>((lm) => {
            'x': (lm['x'] as num).toDouble(),
            'y': (lm['y'] as num).toDouble(),
            'z': (lm['z'] as num).toDouble(),
          })
      .toList();
}

