import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:personal_task/features/plan/services/plan_services.dart';
import '../../../core/utils/DB/models/draw_path.dart';
import '../data/draw_state.dart';

final planDrawProvider =
StateNotifierProvider.autoDispose<PlanDrawViewModel, DrawState>(
      (ref) => PlanDrawViewModel(),
);

class PlanDrawViewModel extends StateNotifier<DrawState> {
  PlanDrawViewModel() : super(DrawState.initial());

  PlanServices planServices = PlanServices();

  Path? _currentPath;

  void startPath(Offset position) {
    _currentPath = Path()
      ..moveTo(position.dx, position.dy);

    state = state.copyWith(
      paths: [
        ...state.paths,
        DrawPath(_currentPath!, state.selectedColor, state.strokeWidth)
      ],
      undonePaths: [],
    );
  }

  void updatePath(Offset position) {
    _currentPath?.lineTo(position.dx, position.dy);
    state = state.copyWith();
  }

  void endPath() {
    _currentPath = null;
  }

  void undo() {
    if (state.paths.isEmpty) return;
    final last = state.paths.last;

    state = state
      .copyWith(
        paths: [...state.paths]..removeLast(),
        undonePaths: [...state.undonePaths, last],
      );
  }

  void redo() {
    if (state.undonePaths.isEmpty) return;
    final last = state.undonePaths.last;

    state = state.copyWith(
      paths: [...state.paths, last],
      undonePaths: [...state.undonePaths]..removeLast(),
    );
  }

  void changeColor(Color color) {
    state = state.copyWith(selectedColor: color);
  }

  void changeStroke(double value) {
    state = state.copyWith(strokeWidth: value);
  }

  void clear() {
    state = DrawState.initial();
  }

  Future<void> shareImage(BuildContext context, GlobalKey repaintKey) async {
    await planServices.shareImage(context, repaintKey);
  }

  Future<void> saveImage(BuildContext context, GlobalKey repaintKey) async {
    await planServices.saveImage(context, repaintKey);
  }
}
