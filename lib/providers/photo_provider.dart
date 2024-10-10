
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

class ProfileImageProvider with ChangeNotifier {
  File? _image;
  File? _newImage;
  String _base64Path = '';

  final _picker = ImagePicker();

  Future getImageFromGallery() async {
    final pickedImage = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      _image = File(pickedImage.path);

      //configuring the image's size using path provider and flutter image compressor library.
      final dir = await path_provider.getTemporaryDirectory();
      final targetPath = '${dir.absolute.path}/temp.jpg';
      var compressedImage = await FlutterImageCompress.compressAndGetFile(
        _image!.path,
        targetPath,
        quality: 70,
        minHeight: 540,
        minWidth: 540,
      );

      // assigning the new compressed picture path.
      _newImage = File(compressedImage!.path);
      _image = _newImage;

      //telling it to read by bytes
      var imageBytes = _newImage!.readAsBytesSync();

      //encoding it to base 64 image
      _base64Path = base64Encode(imageBytes);

      print("base64 image path:- ${_base64Path}");
    } else {
      print("No image selected");
    }
    notifyListeners();
  }

  Future getImageFromCamera() async {
    final pickedImage = await _picker.pickImage(source: ImageSource.camera);

    if (pickedImage != null) {
      _image = File(pickedImage.path);

      //configuring the image's size using path provider and flutter image compressor library.
      final dir = await path_provider.getTemporaryDirectory();
      final targetPath = '${dir.absolute.path}/temp.jpg';
      var compressedImage = await FlutterImageCompress.compressAndGetFile(
        _image!.path,
        targetPath,
        quality: 70,
        minHeight: 540,
        minWidth: 540,
      );
      // assigning the new compressed picture path.
      _newImage = File(compressedImage!.path);
      _image = _newImage;

      //telling it to read by bytes
      var imageBytes = _newImage!.readAsBytesSync();

      //encoding it to base 64 image
      _base64Path = base64Encode(imageBytes);

      print(_base64Path);
    } else {
      print("No image taken");
    }
    notifyListeners();
  }

  File? get image => _image;
  String get base64Image => _base64Path;

}
