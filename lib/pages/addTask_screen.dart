import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
//component
import 'package:todoapp/component/InputField.dart';
import 'package:todoapp/component/DateSelector.dart';
import 'package:todoapp/component/IconSelector.dart';
import 'package:todoapp/component/SaveButton.dart';
//widget
import '../widgets/datepicker_widget.dart';
//theme
import 'package:todoapp/theme/app_theme.dart';

class AddTask extends StatefulWidget {
  final String? taskId;
  final String initialTitle;
  final String initialSubtitle;
  final IconData? initialIcon;
  final DateTime initialStartDate;
  final DateTime initialEndDate;
  final bool isEditMode;
  final Function(Map<String, dynamic>) onSave;

  const AddTask({
    super.key,
    this.taskId,
    required this.initialTitle,
    required this.initialSubtitle,
    required this.initialIcon,
    required this.initialStartDate,
    required this.initialEndDate,
    required this.isEditMode,
    required this.onSave,
  });

  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTask> {
  late String title;
  late String subtitle;
  late IconData? selectedIcon;
  late DateTime startDate;
  late DateTime endDate;
  late TextEditingController titleController;
  late TextEditingController subtitleController;

  @override
  void initState() {
    super.initState();
    title = widget.initialTitle;
    subtitle = widget.initialSubtitle;
    selectedIcon = widget.initialIcon ?? Icons.check;
    startDate = widget.initialStartDate;
    endDate = widget.initialEndDate;

    // Initialize controllers
    titleController = TextEditingController(text: title);
    subtitleController = TextEditingController(text: subtitle);
  }

  @override
  void dispose() {
    // Dispose controllers
    titleController.dispose();
    subtitleController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime initialDate = isStartDate ? startDate : endDate;

    // หากกำลังเลือก endDate ให้ตั้งค่าเริ่มต้นที่ startDate เพื่อไม่ให้ย้อนกลับไปเดือนก่อนหน้า
    final DateTime? picked = await DatePickerWidget.selectDate(
      context,
      initialDate,
      isStartDate,
      minDate:
          isStartDate ? null : startDate, // กำหนดวันขั้นต่ำให้เป็น startDate
    );

    if (picked != null) {
      setState(() {
        if (isStartDate) {
          startDate = picked;
          // หาก endDate ก่อน startDate ให้ endDate เป็น startDate
          if (endDate.isBefore(startDate)) {
            endDate = startDate;
          }
        } else {
          // ตรวจสอบว่า picked >= startDate หรือไม่
          if (picked.isBefore(startDate)) {
            return; // ไม่อนุญาตให้เลือกวันที่สิ้นสุดก่อนวันที่เริ่มต้น
          }
          endDate = picked;
        }
      });
    }
  }

  // ฟังก์ชันสำหรับตรวจสอบข้อมูลก่อนบันทึก
  bool _validateInputs() {
    if (title.isEmpty) {
      _showSnackBar('อย่าลืมกรอก "หัวข้อ"');
      return false;
    }
    if (subtitle.isEmpty) {
      _showSnackBar('อย่าลืมกรอก "เนื้อหา"');
      return false;
    }
    if (selectedIcon == null) {
      _showSnackBar('อย่าลืมเลือก "ไอคอน"');
      return false;
    }
    return true;
  }

  // ฟังก์ชันสำหรับแสดง SnackBar
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          AppTheme.background(context),
          SingleChildScrollView(
            child: Center(
              child: Card(
                elevation: 8,
                margin: const EdgeInsets.only(top: 60, right: 20, left: 20),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 10),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          widget.isEditMode ? 'EDIT TASK' : 'NEW TASK',
                          style: GoogleFonts.ibmPlexSansThai(
                            textStyle: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFec5091),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 25),
                      InputField(
                        label: 'Title',
                        controller:
                            titleController, // เปลี่ยนไปใช้ titleController
                        onChanged: (value) {
                          setState(() {
                            title = value; // อัปเดต title
                          });
                        },
                      ),
                      const SizedBox(height: 25),
                      InputField(
                          label: 'Subtitle',
                          controller: subtitleController,
                          onChanged: (value) {
                            setState(() {
                              subtitle = value; // อัปเดต subtitle
                            });
                          }),
                      const SizedBox(height: 25),
                      Row(
                        children: [
                          Expanded(
                            child: DateSelector(
                              label: 'Start',
                              date: startDate,
                              isStartDate: true,
                              onTap: () => _selectDate(context, true),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: DateSelector(
                              label: 'End',
                              date: endDate,
                              isStartDate: false,
                              onTap: () => _selectDate(context, false),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 25),
                      IconSelector(
                        selectedIcon: selectedIcon,
                        onIconSelected: (icon) => setState(() {
                          selectedIcon = icon;
                        }),
                      ),
                      const SizedBox(height: 25),
                      SaveButton(
                        title: title,
                        subtitle: subtitle,
                        selectedIcon: selectedIcon,
                        startDate: startDate,
                        endDate: endDate,
                        taskId: widget.taskId,
                        isEditMode: widget.isEditMode,
                        onSave: (data) {
                          print('Title: $title');
                          print(
                              'Subtitle: $subtitle'); // เพิ่มการพิมพ์ subtitle
                          if (_validateInputs()) {
                            widget.onSave(data);
                          }
                        },
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
