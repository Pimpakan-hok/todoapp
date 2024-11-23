import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class IconSelector extends StatelessWidget {
  final IconData? selectedIcon;
  final Function(IconData) onIconSelected;

  const IconSelector({
    super.key,
    required this.selectedIcon,
    required this.onIconSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Icon',
          style: GoogleFonts.ibmPlexSansThai(
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFFec5091),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Icons.book,
            Icons.palette,
            Icons.attach_money,
            Icons.terrain,
            Icons.favorite,
          ].map((icon) => _buildIconButton(icon)).toList(),
        ),
      ],
    );
  }

  Widget _buildIconButton(IconData icon) {
    return GestureDetector(
      onTap: () => onIconSelected(icon),
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: selectedIcon == icon
              ? const Color(0xFFec5091).withOpacity(0.5)
              : Colors.white,
        ),
        child: Icon(
          icon,
          color: selectedIcon == icon ? Colors.white : const Color(0xFFec5091),
        ),
      ),
    );
  }
}
