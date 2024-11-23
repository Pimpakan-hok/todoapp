import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// pages
import 'package:todoapp/pages/calendar_screen.dart';
// service
import 'package:todoapp/services/service.dart';

class HeaderWidget extends StatelessWidget {
  final String currentDate;
  final TaskService taskService;
  final DateTime selectedDate;

  const HeaderWidget({
    Key? key,
    required this.currentDate,
    required this.taskService,
    required this.selectedDate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft, // ขยับทั้งหมดไปทางซ้าย
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding:
                const EdgeInsets.only(left: 2.5), // ขยับเพิ่มเติมจากขอบซ้าย
            child: Text(
              currentDate,
              style: GoogleFonts.ibmPlexSansThai(
                fontSize: 36,
                color: Colors.white,
                fontWeight: FontWeight.bold,
                shadows: [
                  Shadow(
                    color: Colors.black.withOpacity(0.5), // สีของเงา
                    offset: const Offset(2, 2), // ตำแหน่งของเงา
                    blurRadius: 5, // ระดับความเบลอของเงา
                  ),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      StreamBuilder<List<Map<String, dynamic>>>(
                    stream: taskService.fetchTasksStream(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      }

                      final tasks = snapshot.data ?? [];
                      return CalendarTaskScreen(
                        tasks: tasks,
                        selectedDate: selectedDate,
                      );
                    },
                  ),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(10),
              child: const Icon(
                Icons.calendar_today,
                color: Colors.white,
                size: 30,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
