import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../pages/task_list_screen.dart';

class ConfirmDeleteDialog extends StatelessWidget {
  final VoidCallback onConfirm; // ฟังก์ชันสำหรับลบงาน
  final String title; // ชื่อของงานที่ต้องการลบ

  const ConfirmDeleteDialog({
    Key? key,
    required this.onConfirm,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'ยืนยันการลบ',
        style: GoogleFonts.ibmPlexSansThai(),
      ),
      content: Text(
        'แน่ใจใช่มั้ยว่าต้องการลบ "$title"?',
        style: GoogleFonts.ibmPlexSansThai(),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(), // ปิด dialog
          child: Text(
            'ยกเลิก',
            style: GoogleFonts.ibmPlexSansThai(),
          ),
        ),
        TextButton(
          onPressed: () {
            onConfirm(); // เรียกฟังก์ชันสำหรับลบงาน
            Navigator.of(context).pop(); // ปิด dialog
            // นำทางไปยัง TaskListScreen
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) =>
                    TaskListScreen(), // เปลี่ยนเส้นทางไปยัง TaskListScreen
              ),
            );
          },
          child: Text(
            'ลบ',
            style: GoogleFonts.ibmPlexSansThai(
              color: Colors.red, // เปลี่ยนสีให้ชัดเจน
            ),
          ),
        ),
      ],
    );
  }
}
