import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:personal_task/core/constants/app_colors.dart';
import 'package:personal_task/features/profile/view-models/profile_view_model.dart';
import 'package:shimmer/shimmer.dart';

import 'image_providers.dart';

class ImageWidget extends ConsumerWidget {

  const ImageWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final XFile? pickedImage = ref.watch(pickedImageProvider);

    final String? cloudImage = ref.watch(profileImageProvider);

    final double screenHeight = MediaQuery.of(context).size.height;

    Widget displayedImage;

    if (pickedImage != null) {
      displayedImage = Image.file(
        File(pickedImage.path),
        width: 100,
        height: 100,
        fit: BoxFit.cover,
      );
    } else if (cloudImage != null && cloudImage.isNotEmpty) {
      try {
        displayedImage = Image.memory(
          base64Decode(
            cloudImage.startsWith('data:image')
                ? cloudImage.split(',').last
                : cloudImage,
          ),
          width: 100,
          height: 100,
          fit: BoxFit.cover,
        );
      } catch (e) {
        displayedImage = Image.asset(
          "assets/profile-placeholder.jpeg",
          width: 100,
          height: 100,
          fit: BoxFit.cover,
        );
      }
    } else {
      displayedImage = Image.asset(
        "assets/profile-placeholder.jpeg",
        width: 100,
        height: 100,
        fit: BoxFit.cover,
      );
    }

    Future<void> pickImage() async {
      final ImagePicker picker = ImagePicker();
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
        if (image != null) {
          ref.read(pickedImageProvider.notifier).state = image;
        }
      }
    }

    return ref.watch(profileViewModelProvider).isLoading
        ? Shimmer.fromColors(
      baseColor: AppColors.primary,
      highlightColor: Colors.white,
      child: CircleAvatar(
        radius: screenHeight * 0.06,
        backgroundColor: Colors.white,
      ),
    )
        : InkWell(
      onTap: pickImage,
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.grey, width: 2),
        ),
        child: ClipOval(child: displayedImage),
      ),
    );
  }
}
