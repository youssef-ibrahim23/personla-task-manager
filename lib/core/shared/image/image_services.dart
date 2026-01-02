import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:personal_task/core/utils/localization/l10n/app_localizations.dart';

class ImageServices {

  static Future<XFile?> pickImage(BuildContext context) async {
    final picker = ImagePicker();
    final source = await showDialog<ImageSource>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        title: Text(AppLocalizations.of(context)!.select_image_source , style: TextStyle(color: Theme.of(context).colorScheme.primary),),
        content:  Text(AppLocalizations.of(context)!.where_do_you_want_to_pick_image , style: TextStyle(color: Theme.of(context).colorScheme.primary)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, ImageSource.camera),
            child:  Text(AppLocalizations.of(context)!.camera),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, ImageSource.gallery),
            child:  Text(AppLocalizations.of(context)!.gallery),
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
