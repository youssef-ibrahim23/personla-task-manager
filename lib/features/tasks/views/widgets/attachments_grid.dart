import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:personal_task/core/utils/DB/models/attachment.dart';
import 'package:personal_task/core/utils/localization/l10n/app_localizations.dart';

class AttachmentsGrid extends StatefulWidget {
  final bool isUpdate;
  final List<Attachment> attachments;
  final Function(int)? onAttachmentDeleted;

  AttachmentsGrid({
    super.key,
    required this.attachments,
    this.isUpdate = false,
    this.onAttachmentDeleted,
  });

  @override
  State<AttachmentsGrid> createState() => _AttachmentsGridState();
}

class _AttachmentsGridState extends State<AttachmentsGrid> {
  ImageProvider _getImage(String data) {
    try {
      if (data.startsWith('/')) {
        final file = File(data);
        if (file.existsSync()) {
          return FileImage(file);
        }
      }
      return MemoryImage(base64Decode(data));
    } catch (e) {
      return const AssetImage('assets/placeholder.png');
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return widget.attachments.isEmpty
        ? Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Icon(
            Icons.photo_library,
            size: 48,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 8),
          Text(
            AppLocalizations.of(context)!.no_images_selected,
            style: TextStyle(color: Colors.grey.shade600),
          ),
        ],
      ),
    )
        : GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 1,
      ),
      itemCount: widget.attachments.length,
      itemBuilder: (context, index) {
        return Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  image: _getImage(widget.attachments[index].image),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              top: screenHeight * 0.01,
              right: screenWidth * 0.02,
              child: GestureDetector(
                onTap: () {
                  final deletedAttachment = widget.attachments[index];
                  setState(() {
                    widget.attachments.removeAt(index);
                  });
                  // Notify parent about deletion
                  if (widget.onAttachmentDeleted != null && deletedAttachment.id != null) {
                    widget.onAttachmentDeleted!(deletedAttachment.id!);
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.black54,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.close,
                    size: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
