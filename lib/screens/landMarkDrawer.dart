import 'package:flutter/material.dart';
import 'dart:ui' as ui;

import 'package:gesture_recognition/utils/landMarkDrawing.dart';
import 'package:google_fonts/google_fonts.dart';

class HandLandmarkScreen extends StatelessWidget {
  final String name;
  final ui.Image image;
  final List<Map<String, double>> landmarks;

  const HandLandmarkScreen(
      {required this.image, required this.landmarks, required this.name});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          color: Colors.black,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.6,
                width: MediaQuery.of(context).size.width,
                child: CustomPaint(
                  size: Size(image.width.toDouble(), image.height.toDouble()),
                  painter: LandmarkPainter(image: image, landmarks: landmarks),
                ),
              ),
              Container(
                child: Text(
                  name,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                      fontFamily: GoogleFonts.abel().fontFamily),
                ),
              ),
              Card(
                color: Colors.grey[900],
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconButton(
                        iconSize: 40,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.01,
              )
            ],
          ),
        ),
      ),
    );
  }
}
