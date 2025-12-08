import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ImageServices {

  static Future<XFile?> pickImage(BuildContext context) async {
    final picker = ImagePicker();
    final source = await showDialog<ImageSource>(
      context: context,
      builder: (_) => AlertDialog(
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
      final XFile? image = await picker.pickImage(source: source);
      return image;
    }

    return null;
  }

  static Future<void> pickAndSetImage(
      BuildContext context, StateProvider<XFile?> provider, WidgetRef ref) async {
    final image = await pickImage(context);
    if (image != null) {
      ref.read(provider.notifier).state = image;
    }
  }
}
