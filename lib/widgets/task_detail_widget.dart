import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart'; // นำเข้า Font Awesome

Widget buildTextHeader(String text,
    {double fontSize = 18, Color color = Colors.black}) {
  return Align(
    alignment: Alignment.centerLeft,
    child: Text(
      text,
      style: GoogleFonts.ibmPlexSansThai(
        textStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    ),
  );
}

Widget buildDetailBox(String text) {
  return Container(
    height: 50,
    decoration: BoxDecoration(
      color: const Color(0xFFe8e1e6),
      borderRadius: BorderRadius.circular(10),
    ),
    alignment: Alignment.centerLeft,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Text(
        text,
        style: GoogleFonts.ibmPlexSansThai(
          // เปลี่ยนฟอนต์ที่นี่
          textStyle: const TextStyle(color: Colors.black87, fontSize: 16),
        ),
      ),
    ),
  );
}

Widget buildDateColumn(String label, String date) {
  return Expanded(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.ibmPlexSansThai(
            textStyle: const TextStyle(
              fontSize: 16, // ขนาดฟอนต์ของ label
              fontWeight: FontWeight.bold, // ตั้งค่าให้หนา
              color: Color(0xFFec5091), // สีของข้อความ
            ),
          ),
        ),
        buildDetailBox(date), // ใช้ buildDetailBox ที่มีฟอนต์แล้ว
      ],
    ),
  );
}

Widget buildTextHeaderWithIcon(String text, IconData icon) {
  return Row(
    mainAxisAlignment:
        MainAxisAlignment.start, // ใช้ start เพื่อจัดให้อยู่เริ่มต้น
    crossAxisAlignment: CrossAxisAlignment.center, // จัดให้อยู่กลางในแนวตั้ง
    children: [
      Padding(
        padding:
            const EdgeInsets.only(bottom: 2.0), // เพิ่มระยะห่างด้านบนและล่าง
        child: FaIcon(
          icon,
          color: const Color(0xFFec5091),
          size: 18, // ปรับขนาดไอคอนที่นี่
        ),
      ),
      const SizedBox(width: 8), // เว้นระยะระหว่างไอคอนและข้อความ
      buildTextHeader(text, fontSize: 20, color: const Color(0xFFec5091)),
    ],
  );
}

Widget buildButtonText(String text) {
  return Text(
    text,
    style: GoogleFonts.ibmPlexSansThai(
      // ใช้ฟอนต์เดียวกัน
      textStyle: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    ),
  );
}
