import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DatePickerWidget {
  static Future<DateTime?> selectDate(
    BuildContext context,
    DateTime initialDate,
    bool isStartDate, {
    DateTime? minDate,
  }) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: minDate ??
          (isStartDate
              ? DateTime(2000)
              : initialDate), // ใช้ minDate ถ้ามี ถ้าไม่ให้ใช้ initialDate หรือ 2000
      lastDate: DateTime(2101),
      helpText: isStartDate
          ? 'เลือกวันเริ่มต้น'
          : 'เลือกวันสิ้นสุด', // หัวข้อของ DatePicker
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: const Color(0xFFec5091), // สีหลักของ DatePicker
              onPrimary: Colors.white, // สีตัวอักษรในวันที่เลือก
              onSurface:
                  const Color(0xFFec5091), // สีตัวอักษรในวันที่ไม่ได้เลือก
            ),
            dialogBackgroundColor: Colors.black, // สีพื้นหลังของ DatePicker
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFFec5091), // สีของปุ่ม
              ),
            ),
            textTheme: TextTheme(
              headlineMedium: GoogleFonts.ibmPlexSansThai(
                textStyle: const TextStyle(
                  fontSize: 24,
                  color: Colors.white, // เปลี่ยนสีตัวอักษรหัวข้อเป็นสีขาว
                ),
              ), // ฟอนต์หัวข้อ DatePicker
              labelLarge: GoogleFonts.ibmPlexSansThai(
                textStyle: const TextStyle(
                  fontSize: 16,
                  color: Colors.white, // เปลี่ยนสีตัวอักษรวันที่เป็นสีขาว
                ),
              ), // ฟอนต์วันที่
            ),
          ),
          child: child!,
        );
      },
    );

    return picked;
  }
}
