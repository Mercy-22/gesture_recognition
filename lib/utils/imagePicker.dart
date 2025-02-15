import 'dart:io';
import 'package:image_picker/image_picker.dart';

class ImagePickerUtil {
  static final ImagePicker _picker = ImagePicker();

  // Function to pick an image from the gallery
  static Future<File?> pickImageFromGallery() async {
    try {
      final XFile? pickedImage =
          await _picker.pickImage(source: ImageSource.gallery);
      if (pickedImage != null) {
        return File(pickedImage.path);
      }
    } catch (e) {
      print(e.toString());
    }
    return null;
  }
}
