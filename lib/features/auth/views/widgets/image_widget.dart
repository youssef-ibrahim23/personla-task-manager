import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageWidget extends StatefulWidget {

  XFile? pickedImage;

  ImageWidget({super.key, required this.pickedImage});

  @override
  State<ImageWidget> createState() => _ImageWidgetState();
}

class _ImageWidgetState extends State<ImageWidget> {

  ImagePicker imagePicker = ImagePicker();

  void _pickImage() async {
    final XFile? image = await imagePicker.pickImage(
      source: ImageSource.gallery,
    );
    if (image != null) {
      setState(() {
        widget.pickedImage = image;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _pickImage,
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.grey, width: 2),
        ),
        child: ClipOval(
          child: widget.pickedImage != null
              ? Image.file(
            File(widget.pickedImage!.path),
            width: 100,
            height: 100,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Image.asset(
                "assets/profile-placeholder.jpeg",
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              );
            },
          )
              : Image.asset(
            "assets/profile-placeholder.jpeg",
            width: 100,
            height: 100,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}