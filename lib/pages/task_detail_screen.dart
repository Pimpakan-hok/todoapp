import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:todoapp/component/confirm_delete_dialog.dart';
// service
import 'package:todoapp/services/service.dart';
// page
import 'addTask_screen.dart';
// widget
import 'package:todoapp/widgets/task_detail_widget.dart';
// theme
import 'package:todoapp/theme/app_theme.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// ignore: must_be_immutable
class TaskDetailScreen extends StatefulWidget {
  String taskId;
  String title;
  String subtitle;
  DateTime startDate;
  DateTime endDate;
  String createdAt;
  bool isCompleted;
  int icon;
  final TaskService taskService = TaskService();

  final bool isHistoryScreen;

  TaskDetailScreen({
    super.key,
    required this.taskId,
    required this.title,
    required this.subtitle,
    required this.startDate,
    required this.endDate,
    required this.createdAt,
    required this.isCompleted,
    required int icon,
    this.isHistoryScreen = false,
  }) : icon = icon;

  @override
  _TaskDetailScreenState createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  late bool isFinished;
  String? historyDate; // เพิ่มตัวแปรเก็บ historyDate

  @override
  void initState() {
    super.initState();
    isFinished = widget.isCompleted;
  }

  @override
  Widget build(BuildContext context) {
    String formattedStartDate =
        DateFormat('yyyy-MM-dd').format(widget.startDate);
    String formattedEndDate = DateFormat('yyyy-MM-dd').format(widget.endDate);
    DateTime createdAtDateTime = DateTime.parse(widget.createdAt);
    String date = DateFormat('yyyy-MM-dd').format(createdAtDateTime);
    String time = DateFormat('HH:mm').format(createdAtDateTime);

    return Scaffold(
      appBar: AppBar(
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (value) {
              if (value == 'edit') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddTask(
                      taskId: widget.taskId,
                      initialTitle: widget.title,
                      initialSubtitle: widget.subtitle,
                      initialIcon:
                          IconData(widget.icon, fontFamily: 'MaterialIcons'),
                      initialStartDate: widget.startDate,
                      initialEndDate: widget.endDate,
                      isEditMode: true,
                      onSave: (updatedTask) {
                        setState(() {
                          widget.title = updatedTask['title'];
                          widget.subtitle = updatedTask['subtitle'];
                          widget.icon = updatedTask['icon'];
                          widget.startDate =
                              DateTime.parse(updatedTask['startDate']);
                          widget.endDate =
                              DateTime.parse(updatedTask['endDate']);
                        });
                      },
                    ),
                  ),
                );
              } else if (value == 'delete') {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return ConfirmDeleteDialog(
                      title: widget.title,
                      onConfirm: () {
                        widget.taskService
                            .deleteTask(widget.taskId)
                            .then((_) {});
                      },
                    );
                  },
                );
              }
            },
            itemBuilder: (BuildContext context) {
              List<PopupMenuEntry<String>> menuItems = [];

              if (!widget.isHistoryScreen) {
                menuItems.add(
                  PopupMenuItem<String>(
                    value: 'edit',
                    child: Text(
                      'Edit',
                      style: GoogleFonts.ibmPlexSansThai(
                        textStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFec5091),
                        ),
                      ),
                    ),
                  ),
                );
              }

              menuItems.add(
                PopupMenuItem<String>(
                  value: 'delete',
                  child: Text(
                    'Delete',
                    style: GoogleFonts.ibmPlexSansThai(
                      textStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFec5091),
                      ),
                    ),
                  ),
                ),
              );

              return menuItems;
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          AppTheme.background(context),
          Center(
            child: SingleChildScrollView(
              // Enable scrolling for smaller screens
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 40.0, bottom: 50),
                    child: Card(
                      elevation: 8,
                      margin: const EdgeInsets.all(20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(height: 30),
                            buildTextHeader(widget.title,
                                fontSize: 30, color: const Color(0xFFec5091)),
                            const SizedBox(height: 10),
                            buildTextHeaderWithIcon(
                              'Description',
                              FontAwesomeIcons.newspaper,
                            ),
                            const SizedBox(height: 5),
                            buildDetailBox(widget.subtitle),
                            const SizedBox(height: 15),
                            buildTextHeaderWithIcon(
                              'Date',
                              FontAwesomeIcons.calendar,
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                buildDateColumn('Start', formattedStartDate),
                                const SizedBox(width: 10),
                                buildDateColumn('End', formattedEndDate),
                              ],
                            ),
                            const SizedBox(height: 15),
                            buildTextHeaderWithIcon(
                              'Created',
                              FontAwesomeIcons.clock,
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                buildDateColumn('Date', date),
                                const SizedBox(width: 10),
                                buildDateColumn('Time', time),
                              ],
                            ),
                            const SizedBox(height: 20.0),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size(double.infinity, 50),
                                backgroundColor: isFinished
                                    ? const Color(0xFFF7A4C6)
                                    : const Color(0xFFec5091),
                              ),
                              onPressed: isFinished
                                  ? null
                                  : () async {
                                      DateTime now = DateTime.now();
                                      // อัปเดตสถานะการเสร็จสิ้นของงานใน Firebase
                                      await widget.taskService
                                          .updateTaskCompletion(
                                              widget.taskId, true);

                                      setState(() {
                                        isFinished = true; // อัปเดตสถานะใน UI
                                        historyDate = DateFormat('yyyy-MM-dd')
                                            .format(now); // อัปเดต historyDate
                                      });

                                      // อัปเดต historyDate ใน Firebase
                                      await widget.taskService
                                          .updateTaskHistoryDate(widget.taskId);

                                      // ปิดหน้าต่างหรือกลับไปยังหน้าก่อนหน้า
                                      Navigator.pop(context, true);
                                    },
                              child: buildButtonText('Finished'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    child: CircleAvatar(
                      radius: 40,
                      backgroundColor: const Color(0xFFec5091),
                      child: Icon(
                        IconData(widget.icon, fontFamily: 'MaterialIcons'),
                        size: 40,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
