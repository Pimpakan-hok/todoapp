import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../services/service.dart';
import '../theme/app_theme.dart';
import '../widgets/task_card_widget.dart';
import 'task_detail_screen.dart';

class HistoryScreen extends StatefulWidget {
  final TaskService _taskService = TaskService();

  HistoryScreen({super.key});

  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen>
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
    return Scaffold(
      appBar: AppBar(),
      body: Stack(
        children: [
          AppTheme.background(context), // ใช้พื้นหลังจาก AppTheme
          Padding(
            padding: EdgeInsets.all(MediaQuery.of(context).size.width *
                0.05), // ปรับ padding ให้เป็น responsive
            child: StreamBuilder<List<Map<String, dynamic>>>(
              stream: widget._taskService.fetchTasksStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                widget._taskService.deleteOldTasks();

                final tasks = snapshot.data ?? [];
                final completedTasks =
                    tasks.where((task) => task['isCompleted']).toList();

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFec5091),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.all(
                          MediaQuery.of(context).size.width *
                              0.03), // ปรับ padding ให้เป็น responsive
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  'Task ที่สำเร็จทั้งหมด: ${completedTasks.length}',
                                  style: GoogleFonts.ibmPlexSansThai(
                                    fontSize: 18,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'หมายเหตุ: Task ที่สำเร็จเกิน 30 วันจะถูกลบอัตโนมัติ',
                            style: GoogleFonts.ibmPlexSansThai(
                              fontSize: 14,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: completedTasks.isNotEmpty
                          ? ListView.builder(
                              itemCount: completedTasks.length,
                              itemBuilder: (context, index) {
                                final task = completedTasks[index];
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => TaskDetailScreen(
                                          taskId: task['id'],
                                          title: task['title'],
                                          subtitle: task['subtitle'],
                                          startDate: task['startDate'],
                                          endDate: task['endDate'],
                                          createdAt: task['createdAt'],
                                          isCompleted: task['isCompleted'],
                                          icon: task['icon'],
                                          isHistoryScreen: true,
                                        ),
                                      ),
                                    );
                                  },
                                  child: TaskCard(
                                    title: task['title'],
                                    startDate: task['startDate'],
                                    endDate: task['endDate'],
                                    isCompleted: task['isCompleted'],
                                    icon: IconData(task['icon'],
                                        fontFamily: 'MaterialIcons'),
                                    historyDate: task['historyDate'],
                                    onToggleCompletion: (newValue) {},
                                    isHistoryScreen: true,
                                  ),
                                );
                              },
                            )
                          : Center(
                              child: AnimatedBuilder(
                                animation: _animation,
                                builder: (context, child) {
                                  return Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Transform.translate(
                                        offset: Offset(
                                            0, -30 * (1 - _animation.value)),
                                        child: Icon(
                                          FontAwesomeIcons.hourglass,
                                          size: 100,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      FadeTransition(
                                        opacity: _animation,
                                        child: Text(
                                          'ยังไม่มี Task ที่สำเร็จ',
                                          style: GoogleFonts.ibmPlexSansThai(
                                            fontSize: 18,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
