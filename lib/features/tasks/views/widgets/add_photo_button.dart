import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/shared/image/image_services.dart';
import '../../../../core/utils/DB/models/attachment.dart';

class AddPhotoButton extends StatefulWidget {
  List<Attachment> selectedImages;
  final void Function(Attachment) onImageSelected;
  AddPhotoButton({super.key, required this.selectedImages, required this.onImageSelected});

  @override
  State<AddPhotoButton> createState() => _AddPhotoButtonState();
}

class _AddPhotoButtonState extends State<AddPhotoButton> {
  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Row(
      children: [
        Container(
          margin: EdgeInsets.only(left: screenWidth * 0.06),
          width: screenWidth * 0.8,
          child: OutlinedButton.icon(
            onPressed: () async {
              final XFile? pickedImage = await ImageServices.pickImage(context);
              if (pickedImage != null) {
                widget.onImageSelected(
                  Attachment(image: pickedImage.path),
                );
              }
            },
            icon: const Icon(Icons.add_photo_alternate),
            label: const Text('Add Images'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
      ],
    );
  }
}
