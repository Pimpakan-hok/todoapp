// Import packages
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
// Widget
import '../widgets/task_card_widget.dart';
// Pages
import '../pages/task_detail_screen.dart';
// Services
import 'package:todoapp/services/service.dart';

class PendingTasks extends StatefulWidget {
  final TaskService taskService;

  const PendingTasks({required this.taskService, super.key});

  @override
  _PendingTasksState createState() => _PendingTasksState();
}

class _PendingTasksState extends State<PendingTasks>
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
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: widget.taskService.fetchTasksStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final tasks = snapshot.data ?? [];
        final pendingTasks =
            tasks.where((task) => task['isCompleted'] == false).toList();

        // เช็คว่ามี pendingTasks หรือไม่
        if (pendingTasks.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    return Transform.translate(
                      offset:
                          Offset(0, -30 * (1 - _animation.value)), // ขยับขึ้น
                      child: Icon(
                        FontAwesomeIcons
                            .clipboardCheck, // เปลี่ยนไอคอนตามต้องการ
                        size: 80,
                        color: Colors.white, // เปลี่ยนสีไอคอนตามที่ต้องการ
                      ),
                    );
                  },
                ),
                const SizedBox(height: 10),
                FadeTransition(
                  opacity: _animation,
                  child: Text(
                    'NO TASK',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: EdgeInsets.zero, // Remove padding around the ListView
          itemCount: pendingTasks.length,
          itemBuilder: (context, index) {
            final task = pendingTasks[index];
            return Dismissible(
              key: Key(task['id'].toString()), // ใช้ ID เพื่อหลีกเลี่ยงการซ้ำ
              background: Container(
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(16), // ให้ขอบโค้ง
                ),
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: const Icon(
                  FontAwesomeIcons.trash,
                  color: Colors.white,
                  size: 30, // ขนาดไอคอน
                ),
              ),
              confirmDismiss: (direction) async {
                return await _showConfirmDialog(context, task['title']);
              },
              onDismissed: (direction) async {
                await widget.taskService
                    .deleteTask(task['id']); // เรียกฟังก์ชันลบงาน
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${task['title']} deleted')),
                );
              },
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TaskDetailScreen(
                        taskId: task['id'],
                        title: task['title'],
                        subtitle: task['subtitle'],
                        isCompleted: task['isCompleted'],
                        startDate: task['startDate'],
                        endDate: task['endDate'],
                        createdAt: task['createdAt'], // Use 'createdAt'
                        icon: task['icon'] is int
                            ? task['icon']
                            : Icons
                                .help.codePoint, // Check if the value is an int
                      ),
                    ),
                  );
                },
                child: SizedBox(
                  width: double.infinity,
                  child: TaskCard(
                    title: task['title'],
                    startDate: task['startDate'],
                    endDate: task['endDate'],
                    isCompleted: task['isCompleted'],
                    icon: IconData(task['icon'], fontFamily: 'MaterialIcons'),
                    onToggleCompletion: (completed) async {
                      await widget.taskService
                          .updateTaskCompletion(task['id'], completed);
                    },
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<bool?> _showConfirmDialog(BuildContext context, String title) {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Task'),
          content: Text('แน่ใจใช่มั้ยว่าจะลบ "$title"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false), // ยกเลิกการลบ
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true), // ยืนยันการลบ
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
