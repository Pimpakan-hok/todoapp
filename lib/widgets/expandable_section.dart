import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ExpandableSection extends StatefulWidget {
  final String title;
  final Widget child;

  const ExpandableSection({
    Key? key,
    required this.title,
    required this.child,
  }) : super(key: key);

  @override
  _ExpandableSectionState createState() => _ExpandableSectionState();
}

class _ExpandableSectionState extends State<ExpandableSection> {
  bool _isExpanded = false; // สถานะการขยาย

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        dividerColor: Colors.transparent,
      ),
      child: ExpansionTile(
        title: Text(
          widget.title,
          style: GoogleFonts.ibmPlexSansThai(
            textStyle: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
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
        iconColor: Colors.transparent, // ปิดสีไอคอนดั้งเดิม
        trailing: Container(
          decoration: const BoxDecoration(
            shape: BoxShape.circle, // ทำให้เป็นวงกลม
            color: Color(0xFFFDCEDF), // สีพื้นหลัง
          ),
          padding: const EdgeInsets.all(2.0), // เพิ่มพื้นที่รอบไอคอน
          child: Icon(
            _isExpanded
                ? Icons.keyboard_arrow_up // ลูกศรขึ้นเมื่อเปิด
                : Icons.keyboard_arrow_down, // ลูกศรลงเมื่อหด
            color: const Color(0xFFec5091), // สีไอคอน
            size: 30, // ขนาดไอคอน
          ),
        ),
        children: [
          Container(
            height: 230,
            padding: const EdgeInsets.only(top: 0.0, left: 10.0, right: 10.0),
            child: widget.child,
          ),
        ],
        onExpansionChanged: (expanded) {
          setState(() {
            _isExpanded = expanded; // เปลี่ยนสถานะเมื่อเปิดหรือปิด
          });
        },
      ),
    );
  }
}
