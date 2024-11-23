import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // นำเข้า Google Fonts

class CalendarWidget extends StatelessWidget {
  final DateTime currentDate;
  final DateTime? selectedDate;
  final Function(int) onDateSelected;

  const CalendarWidget({
    super.key,
    required this.currentDate,
    required this.selectedDate,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    DateTime firstDayOfMonth = DateTime(currentDate.year, currentDate.month, 1);
    int daysInMonth = DateTime(currentDate.year, currentDate.month + 1, 0).day;
    int firstWeekday = firstDayOfMonth.weekday;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children:
              ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'].map((day) {
            return Expanded(
              child: Center(
                child: Text(
                  day,
                  style: GoogleFonts.ibmPlexSansThai(
                    // ใช้ Google Fonts ที่ต้องการ
                    color: Colors.white,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        GridView.count(
          crossAxisCount: 7,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: List.generate(daysInMonth + firstWeekday - 1, (index) {
            if (index < firstWeekday - 1) return const Center(child: Text(''));
            int day = index - firstWeekday + 2;
            bool isSelected = selectedDate != null &&
                selectedDate!.day == day &&
                selectedDate!.month == currentDate.month &&
                selectedDate!.year == currentDate.year;

            return GestureDetector(
              onTap: () => onDateSelected(day),
              child: Container(
                decoration: BoxDecoration(
                  color: isSelected ||
                          (day == DateTime.now().day &&
                              currentDate.month == DateTime.now().month)
                      ? const Color(0xFFe21f6d) // สีพื้นหลังเมื่อเลือก
                      : Colors.transparent, // พื้นหลังโปร่งใสเมื่อไม่เลือก
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  '$day',
                  style: GoogleFonts.ibmPlexSansThai(
                    // ใช้ Google Fonts ที่ต้องการ
                    color: isSelected ||
                            (day == DateTime.now().day &&
                                currentDate.month == DateTime.now().month)
                        ? Colors
                            .white // สีตัวอักษรเมื่อเลือกหรือเป็นวันปัจจุบัน
                        : Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}
