// ignore_for_file: must_be_immutable

import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gesture_recognition/model_handler/prediction.dart';
import 'package:gesture_recognition/screens/signs.dart';
import 'package:gesture_recognition/server/mediaPipeHandler.dart';
import 'package:gesture_recognition/screens/landMarkDrawer.dart';
import 'package:gesture_recognition/utils/cameraCutOut.dart'; // To work with images
import 'package:gesture_recognition/screens/hint.dart';
import 'package:gesture_recognition/utils/convertions.dart';
import 'package:gesture_recognition/utils/imagePicker.dart';
import 'package:gesture_recognition/utils/snackbar.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

class CamScreen extends StatefulWidget {
  Interpreter? interpreter;
  CamScreen({super.key, required this.interpreter});

  @override
  State<CamScreen> createState() => _CamScreenState();
}

class _CamScreenState extends State<CamScreen> with WidgetsBindingObserver {
  var landmarks;
  bool cam = true;
  late PredictionHelper predictionHelper;
  bool hint = true;
  File? image;
  List<CameraDescription> camera = [];
  CameraController? cameraController;
  late MediapipeHandler mediapipeHandler;
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    _setupCameraController();
    mediapipeHandler = MediapipeHandler(
      serverUrl: 'http://192.168.100.66:8000',
    ); // Load the TFLite model
    predictionHelper = PredictionHelper(interpreter: widget.interpreter!);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    cameraController!.dispose();
    super.dispose();
  }

  void changeHint() {
    hint = !hint;
    setState(() {});
  }

  // Load the model

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (cameraController == null ||
        cameraController?.value.isInitialized == false) {
      return;
    }
    if (state == AppLifecycleState.paused) {
      cameraController?.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _setupCameraController();
    }
  }

  @override
  Widget build(BuildContext context) {
    return _frontPage();
  }

  Widget _frontPage() {
    if (cameraController == null ||
        cameraController?.value.isInitialized == false) {
      return const Center(child: CircularProgressIndicator());
    } else {
      return Container(
        color: Colors.black,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Stack(
                alignment: AlignmentDirectional.center,
                children: [
                  Positioned.fill(child: CameraPreview(cameraController!)),
                  Positioned.fill(
                    child: CustomPaint(
                      painter: OverlayPainter(
                        screenWidth: MediaQuery.of(context).size.width,
                        screenHeight: MediaQuery.of(context).size.height,
                        rectWidth: MediaQuery.of(context).size.width * 0.7,
                        rectHeight: MediaQuery.of(context).size.height * 0.5,
                      ),
                      child: Container(),
                    ),
                  ),
                  Positioned.fill(
                    child: Hint(
                      hint: hint,
                      function: changeHint,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: IconButton(
                        onPressed: () {
                          cam = !cam;
                          _setupCameraController();
                        },
                        icon: Icon(Icons.camera_alt),
                        color: Colors.white,
                      ),
                    ),
                  )
                ],
              ),
            ),
            Container(
              color: Colors.grey[900],
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Card(
                    color: Colors.grey[200],
                    elevation: 0,
                    child: IconButton(
                      iconSize: MediaQuery.sizeOf(context).width * 0.1,
                      onPressed: () {
                        pickImage().then((result) async {
                          if (result == null) {
                            showSnackbar(context, "No Image Selected");
                          } else if (landmarks == null) {
                            showSnackbar(context, "No Hand detected");
                          } else {
                            String name =
                                await predictionHelper.predict(landmarks);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HandLandmarkScreen(
                                  name: name,
                                  image: result,
                                  landmarks: landmarks,
                                ),
                              ),
                            ).then((onValue) {
                              _setupCameraController();
                            });
                          }
                        });
                      },
                      icon: const Icon(Icons.image),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      elevation: 0,
                      child: IconButton(
                        iconSize: MediaQuery.sizeOf(context).width * 0.17,
                        onPressed: () {
                          takePicture().then((result) async {
                            if (landmarks == null) {
                              showSnackbar(context, "No Hand detected");
                            } else {
                              String name =
                                  await predictionHelper.predict(landmarks);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => HandLandmarkScreen(
                                    name: name,
                                    image: result,
                                    landmarks: landmarks,
                                  ),
                                ),
                              ).then((onValue) {
                                _setupCameraController();
                              });
                            }
                          });
                        },
                        icon: const Icon(Icons.circle_outlined),
                      ),
                    ),
                  ),
                  Card(
                    color: Colors.grey[200],
                    elevation: 0,
                    child: IconButton(
                      iconSize: MediaQuery.sizeOf(context).width * 0.1,
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ImageGridScreen()));
                      },
                      icon: const Icon(Icons.sign_language_outlined),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }
  }

  // Setup the camera
  Future<void> _setupCameraController() async {
    List<CameraDescription> cameras = await availableCameras();

    if (cameras.isNotEmpty) {
      setState(() {
        camera = cameras;
        if (cam) {
          cameraController = CameraController(
              cameras.first, ResolutionPreset.high,
              imageFormatGroup: ImageFormatGroup.yuv420, enableAudio: false);
        } else {
          cameraController = CameraController(
              cameras.last, ResolutionPreset.high,
              imageFormatGroup: ImageFormatGroup.yuv420, enableAudio: false);
        }
      });
      cameraController?.initialize().then((_) {
        if (!mounted) return;
        setState(() {});
      }).catchError((e) {
        showSnackbar(context, e.toString());
      });
      cameraController!.setFlashMode(FlashMode.off);
      cameraController!.lockCaptureOrientation(DeviceOrientation.portraitUp);
    }
  }

  Future<ui.Image?> pickImage() async {
    try {
      image = await ImagePickerUtil.pickImageFromGallery();
      print(image);
      if (image != null) {
        await mediapipeHandler.sendImage(image!).then((onValue) {
          if (onValue != null) {
            landmarks = parseLandmarks(onValue);
          } else {
            landmarks = null;
            return null;
          }
        });
      } else {
        return null;
      }
    } catch (e) {
      showSnackbar(context, e.toString());
    }
    return fileToUiImage(image!);
  }

  Future<ui.Image> takePicture() async {
    XFile picture = await cameraController!.takePicture();
    final ui.Image image = await xFileToUiImage(picture);
    await mediapipeHandler.sendImage(File(picture.path)).then((onValue) {
      if (onValue != null) {
        landmarks = parseLandmarks(onValue);
      } else {
        landmarks = null;
      }
    });

    return image;
  }
}
