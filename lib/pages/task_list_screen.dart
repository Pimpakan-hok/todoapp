import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

// Widgets
import 'package:todoapp/widgets/task_pending.dart';
import 'package:todoapp/widgets/task_completed.dart';
import 'package:todoapp/widgets/header_widget.dart';
import 'package:todoapp/widgets/expandable_section.dart';
// Pages
import 'addTask_screen.dart';
import 'history_screen.dart';
// Services
import 'package:todoapp/services/service.dart';
// Theme
import 'package:todoapp/theme/app_theme.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen>
    with SingleTickerProviderStateMixin {
  final TaskService _taskService = TaskService();
  DateTime selectedDate = DateTime.now();
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String currentDate =
        DateFormat('yyyy\nMMMM d').format(DateTime.now());
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [
          AppTheme.background(context),
          Padding(
            padding: EdgeInsets.all(
                screenWidth * 0.07), // ปรับ padding ตามขนาดหน้าจอ
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: screenHeight * 0.05),
                HeaderWidget(
                  currentDate: currentDate,
                  taskService: _taskService,
                  selectedDate: selectedDate,
                ),
                SizedBox(height: 10),
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.zero, // ตั้งค่า padding ให้เป็นศูนย์
                    children: [
                      ExpandableSection(
                        title: 'TODAY',
                        child: PendingTasks(taskService: _taskService),
                      ),
                      SizedBox(
                          height:
                              screenHeight * 0.005), // ลดระยะห่างของ SizedBox
                      ExpandableSection(
                        title: 'COMPLETED TODAY',
                        child: CompletedTasks(taskService: _taskService),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: SpeedDial(
        icon: FontAwesomeIcons.bars,
        activeIcon: FontAwesomeIcons.times,
        backgroundColor: const Color(0xFFFDCEDF),
        foregroundColor: const Color(0xFFec5091),
        overlayColor: const Color(0xFFFDCEDF),
        overlayOpacity: 0.5,
        spacing: screenWidth * 0.01,
        spaceBetweenChildren: screenWidth * 0.01,
        shape: const CircleBorder(),
        children: [
          SpeedDialChild(
            elevation: 0,
            child: const Icon(FontAwesomeIcons.clockRotateLeft,
                color: Color(0xFF295F98)),
            backgroundColor: const Color(0xFFBFECFF),
            shape: const CircleBorder(),
            label: 'ตรวจสอบงานที่สำเร็จทั้งหมด',
            labelBackgroundColor: const Color(0xFFBFECFF),
            labelStyle: GoogleFonts.ibmPlexSansThai(
              fontSize: screenWidth * 0.04, // ปรับขนาดฟอนต์ตามขนาดหน้าจอ
              color: const Color(0xFF295F98),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HistoryScreen(),
                ),
              );
            },
          ),
          SpeedDialChild(
            elevation: 0,
            child: const Icon(FontAwesomeIcons.plus, color: Color(0xFFA97155)),
            backgroundColor: const Color(0xFFF9EBC8),
            shape: const CircleBorder(),
            label: 'เพิ่มงาน',
            labelBackgroundColor: const Color(0xFFF9EBC8),
            labelStyle: GoogleFonts.ibmPlexSansThai(
              fontSize: screenWidth * 0.04, // ปรับขนาดฟอนต์ตามขนาดหน้าจอ
              color: const Color(0xFFA97155),
            ),
            onTap: () => _addTask(context),
          ),
        ],
      ),
    );
  }

  void _addTask(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddTask(
          initialTitle: '',
          initialSubtitle: '',
          initialIcon: Icons.check,
          initialStartDate: DateTime.now(),
          initialEndDate: DateTime.now().add(const Duration(days: 1)),
          isEditMode: false,
          onSave: (newTask) async {
            await _taskService.addNewTask({
              'title': newTask['title'],
              'subtitle': newTask['subtitle'],
              'icon': newTask['icon'],
              'startDate': DateFormat('yyyy-MM-dd HH:mm:ss')
                  .format(newTask['startDate']),
              'endDate':
                  DateFormat('yyyy-MM-dd HH:mm:ss').format(newTask['endDate']),
              'createdAt': DateFormat('yyyy-MM-dd HH:mm:ss')
                  .format(DateTime.now().toLocal()),
              'isCompleted': false,
            });
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Task added successfully!')),
            );
          },
        ),
      ),
    );
  }
}
