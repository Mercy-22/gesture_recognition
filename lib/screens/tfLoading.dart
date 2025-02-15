import 'package:flutter/material.dart';
import 'package:gesture_recognition/screens/cameraScreen.dart';
import 'package:gesture_recognition/utils/snackbar.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  Interpreter? interpreter; // Nullable interpreter

  @override
  void initState() {
    super.initState();
    loadModel();
  }

  Future<void> loadModel() async {
    try {
      interpreter = await Interpreter.fromAsset('assets/model1.tflite');
      if (interpreter == null) {
        showSnackbar(context, "Failed to load the model.");
      } else {
        showSnackbar(context, "Model loaded successfully.");
      }
      setState(() {});
    } catch (e) {
      showSnackbar(context, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: interpreter == null
            ? CircularProgressIndicator()
            : // Show loading until model loads
            CamScreen(
                interpreter:
                    interpreter), // Load camera screen after model loads
      ),
    );
  }
}
