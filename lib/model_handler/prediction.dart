import 'dart:typed_data';
import 'package:tflite_flutter/tflite_flutter.dart';

class PredictionHelper {
  Interpreter interpreter;

  // Define class labels (must match training order)
  static const List<String> classLabels = [
    'ain',
    'aleff',
    'bb',
    'dal',
    'dha',
    'dhad',
    'fa',
    'gaaf',
    'ghain',
    'ha',
    'haa',
    'jeem',
    'kaaf',
    'khaa',
    'laam',
    'meem',
    'nun',
    'ra',
    'saad',
    'seen',
    'sheen',
    'ta',
    'taa',
    'thaa',
    'thal',
    'waw',
    'ya',
    'zay'
  ];

  PredictionHelper({required this.interpreter});

  Future<String> predict(List<Map<String, double>> landmarks) async {
    // Convert landmarks to Float32List
    Float32List inputTensor = formatLandmarksForModel(landmarks);

    // Reshape into [1, 63, 1] for the model
    List input = [
      List.generate(63, (i) => [inputTensor[i]])
    ];

    // Prepare output tensor with correct shape [1, 28]
    List<List<double>> output = List.generate(1, (_) => List.filled(28, 0.0));

    // Run the model
    interpreter.run(input, output);

    // Get the class index with the highest probability
    int predictedIndex =
        output.first.indexOf(output.first.reduce((a, b) => a > b ? a : b));

    // Return the predicted class name
    return classLabels[predictedIndex];
  }

  // Convert landmarks into Float32List with shape [63]
  static Float32List formatLandmarksForModel(
      List<Map<String, double>> landmarks) {
    List<double> flattened = [];

    for (var lm in landmarks) {
      flattened.add(lm['x']!);
      flattened.add(lm['y']!);
      flattened.add(lm['z']!);
    }

    return Float32List.fromList(flattened); // Shape: [63]
  }
}
