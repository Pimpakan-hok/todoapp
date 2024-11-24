import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// widget
import '../widgets/task_card_widget.dart';
// pages
import '../pages/task_detail_screen.dart';
// services
import 'package:todoapp/services/service.dart';
// google fonts
import 'package:google_fonts/google_fonts.dart';

class CompletedTasks extends StatefulWidget {
  final TaskService taskService;

  const CompletedTasks({required this.taskService, super.key});

  @override
  _CompletedTasksState createState() => _CompletedTasksState();
}

class _CompletedTasksState extends State<CompletedTasks>
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
        final today = DateTime.now();
        final startOfToday =
            DateTime(today.year, today.month, today.day); // เริ่มต้นวันปัจจุบัน

         final completedTasks = tasks.where((task) {
          final isCompleted = task['isCompleted'];
          final completedDate = DateTime.parse(task['completedDate'] ??
              task['createdAt']); // ใช้ 'completedDate' แทน 'createdAt' ถ้ามี

          // เช็คว่าคืองานที่เสร็จในวันนี้หรือก่อนหน้านี้ 1 วัน
          return isCompleted &&
              completedDate.isAfter(startOfToday.subtract(Duration(days: 1))) &&
              completedDate.isBefore(startOfToday.add(Duration(days: 1))) &&
              _isTaskRecent(completedDate);
        }).toList();

        if (completedTasks.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FadeTransition(
                  opacity: _animation,
                  child: Transform.translate(
                    offset: Offset(0, -30 * (1 - _animation.value)), // ขยับขึ้น
                    child: Icon(
                      FontAwesomeIcons.clipboardCheck,
                      size: 80,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                FadeTransition(
                  opacity: _animation,
                  child: Text(
                    'NO COMPLETED TASKS',
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
          padding: EdgeInsets.zero,
          itemCount: completedTasks.length,
          itemBuilder: (context, index) {
            final task = completedTasks[index];
            return Dismissible(
              key: Key(task['id'].toString()),
              background: Container(
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(16),
                ),
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: const Icon(
                  FontAwesomeIcons.trash,
                  color: Colors.white,
                  size: 30,
                ),
              ),
              confirmDismiss: (direction) async {
                return await _showConfirmDialog(context, task['title']);
              },
              onDismissed: (direction) async {
                await widget.taskService.deleteTask(task['id']);
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
                        createdAt: task['createdAt'],
                        icon: task['icon'] is int
                            ? task['icon']
                            : Icons.help.codePoint,
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

  bool _isTaskRecent(DateTime completedDate) {
    final now = DateTime.now();
    final difference = now.difference(completedDate);
    return difference.inMinutes <= 5;
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
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
