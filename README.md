# Gesture Detection
A Flutter app that detects and predicts hand signs using a custom-trained model.

## Features
Recognizes different hand signs with up to 97% accuracy
- Uses MediaPipe for extracting hand landmarks
- Processes images locally using FastAPI
## Technology Stack
- Flutter (for the mobile app)
- TensorFlow Lite (for on-device ML)
- MediaPipe (for hand landmark detection)
- FastAPI (for local server-based processing)

## How It Works
- The app captures an image of the hand gesture.
- The image is sent to a FastAPI server.
- The server extracts hand landmarks using MediaPipe.
- The landmarks are processed by a custom-trained model to predict the sign.
- The app displays the recognized gesture.
