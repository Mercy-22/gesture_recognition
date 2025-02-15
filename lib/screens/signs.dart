import 'package:flutter/material.dart';
import 'package:gesture_recognition/utils/signMap.dart';

class Signgrid extends StatelessWidget {
  const Signgrid({super.key});

  @override
  Widget build(BuildContext context) {
    return ImageGridScreen();
  }
}

class ImageGridScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Gallery'),
        backgroundColor: Colors.grey[300],
      ),
      body: Container(
        color: Colors.grey[900],
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: GridView.builder(
                cacheExtent: 100,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: gestureImages.length,
                itemBuilder: (context, index) {
                  String name = gestureImages.keys.elementAt(index);
                  String imageUrl = gestureImages.values.elementAt(index);

                  return Card(
                    color: Colors.grey[800],
                    child: Column(
                      children: [
                        Expanded(
                          child: Image.network(imageUrl, fit: BoxFit.cover),
                        ),
                        SizedBox(height: 5),
                        Text(name,
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                      ],
                    ),
                  );
                })),
      ),
    );
  }
}
