import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/utils/DB/models/attachment.dart';
import '../../../core/utils/helpers.dart';

class PlanServices{

   Future<File> _exportImage(GlobalKey repaintKey) async {
    final boundary =
    repaintKey.currentContext!.findRenderObject() as RenderRepaintBoundary;

    ui.Image image = await boundary.toImage(pixelRatio: 3);
    ByteData? data =
    await image.toByteData(format: ui.ImageByteFormat.png);

    final bytes = data!.buffer.asUint8List();
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/plan.png');
    return file.writeAsBytes(bytes);
  }

   Future<void> shareImage(BuildContext context ,  GlobalKey repaintKey) async {
    final file = await _exportImage(repaintKey);
    await Share.shareXFiles([XFile(file.path)]);
  }

   Future<void> saveImage(BuildContext context , GlobalKey repaintKey) async {
    final file = await _exportImage(repaintKey);
    final attachment = Attachment(
      id: await Helpers.generateUniqueNumber(),
      image: file.path,
    );
    Navigator.pop(context, attachment);
  }
}