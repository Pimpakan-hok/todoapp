import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// ฟังก์ชันที่ใช้สร้าง Widget Icon จากค่าที่ส่งเข้ามา
Widget getIconData(dynamic iconValue) {
  if (iconValue is String) {
    switch (iconValue) {
      case 'book':
        return FaIcon(FontAwesomeIcons.book, size: 50, color: Colors.white);
      case 'palette':
        return FaIcon(FontAwesomeIcons.palette, size: 50, color: Colors.white);
      case 'attach_money':
        return FaIcon(FontAwesomeIcons.moneyBillWave, size: 50, color: Colors.white);
      case 'terrain':
        return FaIcon(FontAwesomeIcons.train, size: 50, color: Colors.white);
      case 'favorite':
        return FaIcon(FontAwesomeIcons.heart, size: 50, color: Colors.white);
      default:
        return FaIcon(FontAwesomeIcons.question, size: 50, color: Colors.white); // ไอคอนเริ่มต้น
    }
  } else if (iconValue is int) {
    switch (iconValue) {
      case 1:
        return FaIcon(FontAwesomeIcons.book, size: 50, color: Colors.white);
      case 2:
        return FaIcon(FontAwesomeIcons.palette, size: 50, color: Colors.white);
      case 3:
        return FaIcon(FontAwesomeIcons.moneyBillWave, size: 50, color: Colors.white);
      case 4:
        return FaIcon(FontAwesomeIcons.train, size: 50, color: Colors.white);
      case 5:
        return FaIcon(FontAwesomeIcons.heart, size: 50, color: Colors.white);
      default:
        return FaIcon(FontAwesomeIcons.question, size: 50, color: Colors.white); // ไอคอนเริ่มต้น
    }
  }
  // หากประเภทไม่ตรงกัน แสดงไอคอนเริ่มต้น
  return FaIcon(FontAwesomeIcons.question, size: 50, color: Colors.white); // ไอคอนเริ่มต้น
}
