import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:personal_task/core/constants/app_colors.dart';
import 'package:personal_task/core/utils/localization/l10n/app_localizations.dart';

import '../../../../core/shared/image/image_services.dart';
import '../../../../core/utils/DB/models/attachment.dart';

class AddPhotoButton extends StatefulWidget {
  final List<Attachment> selectedImages;
  final void Function(Attachment) onImageSelected;
  const AddPhotoButton({super.key, required this.selectedImages, required this.onImageSelected});

  @override
  State<AddPhotoButton> createState() => _AddPhotoButtonState();
}

class _AddPhotoButtonState extends State<AddPhotoButton> {
  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
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
            icon: Icon(Icons.add_photo_alternate , color: AppColors.primary,),
            label: Text(AppLocalizations.of(context)!.add_images , style: TextStyle(color: AppColors.primary),),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
      ],
    );
  }
}
