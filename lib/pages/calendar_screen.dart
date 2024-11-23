import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:todoapp/pages/addTask_screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// Theme
import 'package:todoapp/theme/app_theme.dart';
// Pages
import '../component/TaskSlidingPanel.dart';
// Widget
import '../widgets/calendar_widget.dart';
// Service
import 'package:todoapp/services/service.dart';

class CalendarTaskScreen extends StatefulWidget {
  final List<Map<String, dynamic>> tasks;
  final DateTime selectedDate;

  const CalendarTaskScreen({
    super.key,
    required this.tasks,
    required this.selectedDate,
  });

  @override
  _CalendarTaskScreenState createState() => _CalendarTaskScreenState();
}

class _CalendarTaskScreenState extends State<CalendarTaskScreen> {
  DateTime _currentDate = DateTime.now();
  DateTime? _selectedDate;
  bool showCompleted = false;
  final PanelController _panelController = PanelController();
  final TaskService _taskService = TaskService();

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.selectedDate;
  }

  void _updateMonth(int increment) {
    setState(() {
      _currentDate =
          DateTime(_currentDate.year, _currentDate.month + increment);
    });
  }

  void _onDateSelected(int day) {
    print("Selected date: $_currentDate.year, $_currentDate.month, $day");
    setState(() {
      _selectedDate = DateTime(_currentDate.year, _currentDate.month, day);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon:
              const Icon(Icons.arrow_back, color: Colors.black), // ปุ่มย้อนกลับ
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: FaIcon(FontAwesomeIcons.circlePlus, color: Color(0xFFec5091)),
            iconSize: 34,
            onPressed: () {
              _addTask(context);
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          AppTheme.backgroundCalendar(context),
          Column(
            children: [
              const SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon:
                          const Icon(Icons.arrow_back_ios, color: Colors.white),
                      onPressed: () => _updateMonth(-1),
                    ),
                    const SizedBox(width: 8.0),
                    Text(
                      DateFormat('MMMM, y').format(_currentDate),
                      style: GoogleFonts.ibmPlexSansThai(
                        textStyle: const TextStyle(
                          color: Colors.white,
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    IconButton(
                      icon: const Icon(Icons.arrow_forward_ios,
                          color: Colors.white),
                      onPressed: () => _updateMonth(1),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16.0),
                child: CalendarWidget(
                  currentDate: _currentDate,
                  selectedDate: _selectedDate,
                  onDateSelected: _onDateSelected,
                ),
              ),
            ],
          ),
          Positioned.fill(
            child: TaskSlidingPanel(
              panelController: _panelController,
              selectedDate: _selectedDate ?? DateTime.now(),
              tasks: widget.tasks.where((task) {
                DateTime startDate = task['startDate'];
                DateTime endDate = task['endDate'];
                // ตรวจสอบว่าวันที่ที่เลือกอยู่ในช่วงวันที่เริ่มต้นและสิ้นสุด
                return (_selectedDate!.isAfter(startDate) &&
                        _selectedDate!
                            .isBefore(endDate.add(Duration(days: 1)))) ||
                    _selectedDate!.isAtSameMomentAs(startDate) ||
                    (_selectedDate!.isAtSameMomentAs(endDate) &&
                       !task['isCompleted']); // เพิ่มเงื่อนไขนี้
              }).toList(), // กรองเฉพาะงานที่อยู่ในช่วงวันที่ที่เลือก// กรองเฉพาะงานที่อยู่ในช่วงวันที่ที่เลือก

              showCompleted: showCompleted,
              onShowCompletedChanged: (value) {
                print("Show Completed changed to: $value");
                setState(() => showCompleted = value);
              },
            ),
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
