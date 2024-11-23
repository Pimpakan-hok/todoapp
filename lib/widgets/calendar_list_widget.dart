import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todoapp/widgets/task_card_widget.dart';
import '../pages/task_detail_screen.dart';

class CalendarListWidget extends StatefulWidget {
  final DateTime? selectedDate;
  final List<Map<String, dynamic>> tasks;
  final bool showCompleted;

  const CalendarListWidget({
    Key? key,
    required this.selectedDate,
    required this.tasks,
    required this.showCompleted,
  }) : super(key: key);

  @override
  _CalendarListWidgetState createState() => _CalendarListWidgetState();
}

class _CalendarListWidgetState extends State<CalendarListWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..forward(); // เริ่มการเคลื่อนไหวเมื่อหน้าจอเปิด
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.selectedDate == null) {
      return const Center(child: Text('No date selected'));
    }

    List<Map<String, dynamic>> filteredTasks = widget.tasks.where((task) {
      DateTime startDate = task['startDate'] is String
          ? DateTime.parse(task['startDate'])
          : task['startDate'];
      DateTime endDate = task['endDate'] is String
          ? DateTime.parse(task['endDate'])
          : task['endDate'];

      // พิมพ์ค่าที่เกี่ยวข้องเพื่อดีบัก
      print(
          "Task: ${task['title']}, Start: $startDate, End: $endDate, Completed: ${task['isCompleted']}");

      return (startDate.isBefore(
                  widget.selectedDate!.add(const Duration(days: 1))) &&
              endDate.isAfter(widget.selectedDate!) &&
              task['isCompleted'] == widget.showCompleted) ||
          (widget.selectedDate!.isAtSameMomentAs(startDate) ||
              widget.selectedDate!.isAtSameMomentAs(endDate));
    }).toList();

    if (filteredTasks.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FadeTransition(
              opacity: _animation,
              child: Transform.translate(
                offset: Offset(0, -30 * (1 - _animation.value)), // ขยับขึ้น
                child: Icon(
                  Icons.warning, // เปลี่ยนไอคอนตามต้องการ
                  size: 100,
                  color: Colors.grey, // เปลี่ยนสีไอคอนตามที่ต้องการ
                ),
              ),
            ),
            const SizedBox(height: 10),
            FadeTransition(
              opacity: _animation,
              child: Text(
                'ยังไม่มีข้อมูล',
                style: GoogleFonts.ibmPlexSansThai(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: filteredTasks.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () async {
            final updatedTask = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TaskDetailScreen(
                  taskId: filteredTasks[index]['id'] ?? '',
                  title: filteredTasks[index]['title'] ?? 'No Title',
                  subtitle: filteredTasks[index]['subtitle'] ?? 'No Subtitle',
                  isCompleted: filteredTasks[index]['isCompleted'] ?? false,
                  startDate: filteredTasks[index]['startDate'],
                  endDate: filteredTasks[index]['endDate'],
                  createdAt: filteredTasks[index]['createdAt'],
                  icon: filteredTasks[index]['icon'],
                ),
              ),
            );

            if (updatedTask != null) {
              // update the UI if necessary
            }
          },
          child: Padding(
            padding: const EdgeInsets.only(top: 0.0, left: 25.0, right: 25.0),
            child: TaskCard(
              title: filteredTasks[index]['title'] ?? 'No Title',
              startDate: filteredTasks[index]['startDate'],
              endDate: filteredTasks[index]['endDate'],
              isCompleted: filteredTasks[index]['isCompleted'] ?? false,
              icon: IconData(filteredTasks[index]['icon'],
                  fontFamily: 'MaterialIcons'),
              onToggleCompletion: (completed) {},
              showCheckbox: false, // ซ่อนช่องติ๊กใน CalendarTaskScreen
            ),
          ),
        );
      },
    );
  }
}