import 'package:flutter/material.dart';

class ColorPickerRow extends StatelessWidget {
  final Color selected;
  final Function(Color) onSelect;

  ColorPickerRow({required this.selected, required this.onSelect});

  final colors = [
    Colors.black,
    Colors.red,
    Colors.blue,
    Colors.lightBlue,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.yellow,
    Colors.brown,
    Colors.pink,
    Colors.teal,
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: SizedBox(
        height: 50,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: colors.length,
          separatorBuilder: (_, __) => const SizedBox(width: 12),
          itemBuilder: (context, index) {
            final color = colors[index];
            return GestureDetector(
              onTap: () => onSelect(color),
              child: CircleAvatar(
                radius: selected == color ? 24 : 20,
                backgroundColor: color,
                child: selected == color
                    ? const Icon(Icons.check, color: Colors.white)
                    : null,
              ),
            );
          },
        ),
      ),
    );
  }
}
