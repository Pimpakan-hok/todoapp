import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:todoapp/services/service.dart';
import 'package:uuid/uuid.dart';

class SaveButton extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData? selectedIcon;
  final DateTime startDate;
  final DateTime endDate;
  final String? taskId;
  final bool isEditMode;
  final Function(Map<String, dynamic>) onSave;

  const SaveButton({
    super.key,
    required this.title,
    required this.subtitle,
    required this.selectedIcon,
    required this.startDate,
    required this.endDate,
    required this.taskId,
    required this.isEditMode,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => _onSave(context),
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 50),
        backgroundColor: const Color(0xFFec5091),
      ),
      child: Text(
        isEditMode ? 'UPDATE' : 'CREATE',
        style: GoogleFonts.ibmPlexSansThai(
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  void _onSave(BuildContext context) async {
    // ตรวจสอบข้อมูลว่าไม่ครบในโหมดสร้าง และแสดง dialog
    if (!isEditMode &&
        (title.isEmpty || subtitle.isEmpty || selectedIcon == null)) {
      _showDialog(context, 'ข้อผิดพลาด', 'กรุณากรอกข้อมูลให้ครบ');
      return; // หยุดการดำเนินการถ้าข้อมูลไม่ครบ
    }
    print('Current Title: $title'); // ตรวจสอบค่า title ก่อน
    print('Current Subtitle: $subtitle'); // ตรวจสอบค่า subtitle ก่อน

    // บันทึกข้อมูลที่เหลือ
    final taskData = {
      'taskId': isEditMode ? taskId : const Uuid().v4(),
      'title': title,
      'subtitle': subtitle,
      'icon': selectedIcon?.codePoint,
      'createdAt': isEditMode
          ? null
          : DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
      'updatedAt': DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
      'startDate': DateFormat('yyyy-MM-dd HH:mm:ss').format(startDate),
      'endDate': DateFormat('yyyy-MM-dd HH:mm:ss').format(endDate),
      'isCompleted': false,
    };

    print('Task Data for update: $taskData');

    try {
      if (isEditMode) {
        await TaskService().updateTask(taskData);
      } else {
        await TaskService().addNewTask(taskData);
      }

      onSave(taskData);
      Navigator.of(context).pop();
    } catch (e) {
      print('Error saving task: $e');
      _showDialog(context, 'ข้อผิดพลาด',
          'เกิดข้อผิดพลาดในการบันทึกงาน กรุณาลองใหม่อีกครั้ง');
    }
  }

  // ฟังก์ชันสำหรับแสดง dialog
  void _showDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // ปิด dialog
              },
              child: const Text('ตกลง'),
            ),
          ],
        );
      },
    );
  }
}
