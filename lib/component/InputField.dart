import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class InputField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  const InputField({
    super.key,
    required this.label,
    required this.controller,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: _buildInputDecoration(label),
      controller: controller,
      onChanged: onChanged,
      style: GoogleFonts.ibmPlexSansThai(
        textStyle: const TextStyle(
          color: Colors.black87,
          fontSize: 16,
        ),
      ),
    );
  }

  InputDecoration _buildInputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: GoogleFonts.ibmPlexSansThai(
        textStyle: const TextStyle(
          fontSize: 16,
          color: Color(0xFFec5091),
        ),
      ),
      filled: true,
      fillColor: const Color(0xFFe8e1e6),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
    );
  }
}
