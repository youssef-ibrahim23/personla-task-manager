import 'package:flutter_riverpod/legacy.dart';
import 'package:image_picker/image_picker.dart';

final profileImageProvider = StateProvider<String?>((ref) => null);
StateProvider<XFile?> profilePickedImageProvider = StateProvider<XFile?>((ref) => null);

StateProvider<XFile?> registerPickedImageProvider = StateProvider<XFile?>((ref) => null , isAutoDispose: true);