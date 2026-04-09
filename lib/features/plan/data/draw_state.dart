import 'dart:ui';
import '../../../core/utils/DB/models/draw_path.dart';

class DrawState {
  final List<DrawPath> paths;
  final List<DrawPath> undonePaths;
  final Color selectedColor;
  final double strokeWidth;

  DrawState({
    required this.paths,
    required this.undonePaths,
    required this.selectedColor,
    required this.strokeWidth,
  });

  factory DrawState.initial() => DrawState(
    paths: [],
    undonePaths: [],
    selectedColor: const Color(0xFF000000),
    strokeWidth: 4,
  );

  DrawState copyWith({
    List<DrawPath>? paths,
    List<DrawPath>? undonePaths,
    Color? selectedColor,
    double? strokeWidth,
  }) {
    return DrawState(
      paths: paths ?? this.paths,
      undonePaths: undonePaths ?? this.undonePaths,
      selectedColor: selectedColor ?? this.selectedColor,
      strokeWidth: strokeWidth ?? this.strokeWidth,
    );
  }
}
