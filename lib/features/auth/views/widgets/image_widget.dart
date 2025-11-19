import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:personal_task/features/auth/view-models/register_view_model.dart';


class ImageWidget extends ConsumerWidget {

  @override
  Widget build(BuildContext context , WidgetRef ref) {
    final image = ref.watch(pickedImageProvider);
    void pickImage() async {
      final ImagePicker imagePicker = ImagePicker();

      final ImageSource? source = await showDialog<ImageSource>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Select Image Source'),
          content: const Text('Where do you want to pick the image from?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, ImageSource.camera),
              child: const Text('Camera'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, ImageSource.gallery),
              child: const Text('Gallery'),
            ),
          ],
        ),
      );

      if (source != null) {
        final XFile? image = await imagePicker.pickImage(source: source);
        if (image != null) {
          ref.read(pickedImageProvider.notifier).state = image;
        }
      }
    }

    return InkWell(
      onTap: pickImage,
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.grey, width: 2),
        ),
        child: ClipOval(
          child: image != null
              ? Image.file(
            File(image!.path),
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