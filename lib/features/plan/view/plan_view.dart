import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:personal_task/features/plan/view/widgets/color_picker_row.dart';
import '../view-model/plan_draw_view_model.dart';
import 'widgets/plan_painter.dart';

class PlanDrawView extends ConsumerStatefulWidget {
  const PlanDrawView({super.key});

  @override
  ConsumerState<PlanDrawView> createState() => _PlanDrawViewState();
}

class _PlanDrawViewState extends ConsumerState<PlanDrawView> {

  late final GlobalKey repaintKey;

  @override
  void initState() {
    super.initState();
    repaintKey = GlobalKey();
    print(repaintKey.currentWidget?.key);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(planDrawProvider);
    final vm = ref.read(planDrawProvider.notifier);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            vm.clear();
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        title: const Text('Draw Plan'),
        actions: [
          IconButton(icon: const Icon(Icons.undo), onPressed: vm.undo),
          IconButton(icon: const Icon(Icons.redo), onPressed: vm.redo),
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () async {
              await vm.shareImage(context, repaintKey);
            },
          ),
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () async {
              await vm.saveImage(context, repaintKey);
              vm.clear();
            },
          ),
          IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () async {
              vm.clear();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          ColorPickerRow(
            selected: state.selectedColor,
            onSelect: vm.changeColor,
          ),
          Slider(
            value: state.strokeWidth,
            min: 2,
            max: 12,
            onChanged: vm.changeStroke,
          ),
          Expanded(
            child: RepaintBoundary(
              key: repaintKey,
              child: GestureDetector(
                onPanStart: (d) => vm.startPath(d.localPosition),
                onPanUpdate: (d) => vm.updatePath(d.localPosition),
                onPanEnd: (_) => vm.endPath(),
                child: CustomPaint(
                  painter: PlanPainter(state.paths),
                  size: Size.infinite,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
