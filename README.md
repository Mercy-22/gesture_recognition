# Gesture Detection
A Flutter app that detects and predicts hand signs using a 1DCNN custom-trained model.

## Features
- Recognizes different hand signs with up to 97% accuracy
- Uses MediaPipe for extracting hand landmarks
- Processes images locally using FastAPI
- Flutter UI with a screen showcasing all signs
- Local FastAPI Server for processing images and returning hand landmarks
  
## Technology Stack
- Flutter (Dart) - Frontend UI
- TensorFlow/Keras - Model Training
- MediaPipe Hands - Landmark Extraction
- FastAPI - Backend for processing images
- 1D-CNN Architecture - Gesture Classification
## Model Training
The sign recognition model is trained using a 1D Convolutional Neural Network (1D-CNN) on an RGB alphabet dataset.

![image](https://github.com/user-attachments/assets/7c0d8e5a-78a3-4ea4-a400-a6d31c9fedec)

### Training Workflow
- Extract Hand Landmarks using MediaPipe
- Preprocess Landmarks (Normalize & Scale)
- Train a 1D-CNN Model on labeled hand signs
- Optimize & Convert Model for mobile deployment (TensorFlow Lite)
- Use in Flutter App for prediction
  

## How It Works
- The app captures an image of the hand gesture.
- The image is sent to a FastAPI server.
- The server extracts hand landmarks using MediaPipe.
- The landmarks are processed by a custom-trained model to predict the sign.
- The app displays the recognized gesture.





https://github.com/user-attachments/assets/b6ec6b04-533c-4a2a-8386-22585c775027

https://github.com/user-attachments/assets/84f16de2-942b-42d4-8748-803d8b119533


