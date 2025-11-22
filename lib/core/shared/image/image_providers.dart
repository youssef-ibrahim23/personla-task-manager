import 'package:flutter_riverpod/legacy.dart';
import 'package:image_picker/image_picker.dart';

final profileImageProvider = StateProvider<String?>((ref) => null);
final pickedImageProvider = StateProvider<XFile?>((ref) => null);
