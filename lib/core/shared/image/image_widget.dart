import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shimmer/shimmer.dart';

import '../../constants/app_colors.dart';
import 'image_services.dart';

class ImageWidget extends ConsumerWidget {
  final StateProvider<XFile?> pickedImageProvider;
  final String? cloudImage;
  final bool state;

  const ImageWidget({
    super.key,
    required this.pickedImageProvider,
    this.cloudImage,
    required this.state,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pickedImage = ref.watch(pickedImageProvider);

    Widget displayedImage;

    if (pickedImage != null) {
      displayedImage = Image.file(
        File(pickedImage.path),
        width: 100,
        height: 100,
        fit: BoxFit.cover,
      );
    } else if (cloudImage != null && cloudImage!.isNotEmpty) {
      try {
        displayedImage = Image.memory(
          base64Decode(
            cloudImage!.contains(',')
                ? cloudImage!.split(',').last
                : cloudImage!,
          ),
          width: 100,
          height: 100,
          fit: BoxFit.cover,
        );
      } catch (_) {
        displayedImage = Image.asset("assets/profile-placeholder.jpeg");
      }
    } else {
      displayedImage = Image.asset("assets/profile-placeholder.jpeg");
    }

    return state
        ? Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey.withOpacity(0.3), width: 2),
            ),
            child: Shimmer.fromColors(
              baseColor: AppColors.primary,
              highlightColor: Colors.white,
              child: Container(
                width: double.infinity,
                height: double.infinity,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
              ),
            ),
          )
        : InkWell(
            onTap: () => ImageServices.pickAndSetImage(
              context,
              pickedImageProvider,
              ref,
            ),
            borderRadius: BorderRadius.circular(50),
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ClipOval(child: displayedImage),
            ),
          );
  }
}
