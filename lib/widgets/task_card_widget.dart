import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TaskCard extends StatelessWidget {
  final String title;
  final DateTime startDate;
  final DateTime endDate;
  final bool isCompleted;
  final IconData icon;
  final Function(bool) onToggleCompletion;
  final bool isHistoryScreen;
  final bool showCheckbox;
  final DateTime? historyDate; // วันที่จาก Firebase

  const TaskCard({
    super.key,
    required this.title,
    required this.startDate,
    required this.endDate,
    required this.isCompleted,
    required this.icon,
    required this.onToggleCompletion,
    this.historyDate,
    this.isHistoryScreen = false,
    this.showCheckbox = true,
  });

  @override
  Widget build(BuildContext context) {
    print('historyDate: $historyDate');

    final DateTime now = DateTime.now();
    final DateTime today = DateTime(now.year, now.month, now.day);
    final DateTime endDay = DateTime(endDate.year, endDate.month, endDate.day);

    final int daysLeft = endDay.difference(today).inDays;

// คำนวณจำนวนวันที่ทำงานเสร็จแล้วจาก historyDate ที่ได้รับจาก Firebase
    final int daysCompleted = historyDate != null
        ? today
            .difference(
              DateTime(historyDate!.year, historyDate!.month, historyDate!.day),
            )
            .inDays
        : 0;

    return Card(
      elevation: 6,
      margin: const EdgeInsets.symmetric(vertical: 14),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(width: 10),
            ClipOval(
              child: Container(
                color: const Color(0xFFec5091).withOpacity(0.2),
                padding: const EdgeInsets.all(5),
                child: Icon(
                  icon,
                  size: 28,
                  color: const Color(0xFFec5091),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.ibmPlexSansThai(
                      textStyle: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        decoration: isHistoryScreen
                            ? TextDecoration.none
                            : isCompleted
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    isHistoryScreen
                        ? 'สำเร็จ ${daysCompleted} วัน'
                        : isCompleted
                            ? 'เย้ สำเร็จแล้ว!!'
                            : daysLeft > 1
                                ? 'อีก $daysLeft วัน'
                                : daysLeft == 1
                                    ? 'ครบกำหนดวันนี้!'
                                    : daysLeft == 0
                                        ? 'ครบกำหนดวันนี้!'
                                        : 'ลืมกันแล้วสินะ!',
                    style: GoogleFonts.ibmPlexSansThai(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                  // แสดง historyDate
                  if (historyDate != null)
                    Text(
                      'วันที่: ${historyDate!.toLocal().toString().split(' ')[0]}',
                      style: GoogleFonts.ibmPlexSansThai(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                ],
              ),
            ),
            if (!isHistoryScreen &&
                showCheckbox) // เช็คว่าต้องแสดงช่องให้ติ๊กหรือไม่
              GestureDetector(
                onTap: () => onToggleCompletion(!isCompleted),
                child: Container(
                  width: 40,
                  height: 40,
                  alignment: Alignment.center,
                  child: FaIcon(
                    isCompleted
                        ? FontAwesomeIcons.circleCheck
                        : FontAwesomeIcons.circle,
                    color: isCompleted ? const Color(0xFF55AD9B) : Colors.grey,
                    size: 28,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
