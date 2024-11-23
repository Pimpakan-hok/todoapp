import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FilterButton extends StatelessWidget {
  final List<String> labels; // ปรับให้รองรับหลายป้ายชื่อ
  final List<bool> isSelected; // สถานะของตัวเลือก
  final ValueChanged<int> onPressed; // Callback เมื่อมีการกด

  const FilterButton({
    Key? key,
    required this.labels,
    required this.isSelected,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ToggleButtons(
      children: labels.map((label) {
        return Padding(
          padding: const EdgeInsets.all(10),
          child: Text(
            label,
            style: GoogleFonts.ibmPlexSansThai(
              textStyle: const TextStyle(fontWeight: FontWeight.bold , fontSize: 12),
            ),
          ),
        );
      }).toList(),
      isSelected: isSelected,
      selectedColor: Colors.white,
      color: const Color(0xFFec5091),
      fillColor: const Color(0xFFec5091),
      borderColor: const Color(0xFFFDCEDF),
      borderRadius: BorderRadius.circular(8),
      onPressed: onPressed,
    );
  }
}
