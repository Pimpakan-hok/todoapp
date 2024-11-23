import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:google_fonts/google_fonts.dart';
//components
import 'filter_button.dart';
//widgets
import '../widgets/calendar_list_widget.dart';

class TaskSlidingPanel extends StatefulWidget {
  final PanelController panelController;
  final DateTime? selectedDate;
  final List<Map<String, dynamic>> tasks;
  final bool showCompleted;
  final ValueChanged<bool> onShowCompletedChanged;

  const TaskSlidingPanel({
    Key? key,
    required this.panelController,
    required this.selectedDate,
    required this.tasks,
    required this.showCompleted,
    required this.onShowCompletedChanged,
  }) : super(key: key);

  @override
  _TaskSlidingPanelState createState() => _TaskSlidingPanelState();
}

class _TaskSlidingPanelState extends State<TaskSlidingPanel> {
  bool _isPanelOpen = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.panelController.open();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SlidingUpPanel(
      controller: widget.panelController,
      minHeight: 150,
      maxHeight: MediaQuery.of(context).size.height * 0.5,
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(20.0),
        topRight: Radius.circular(20.0),
      ),
      panel: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              if (_isPanelOpen) {
                widget.panelController.close();
              } else {
                widget.panelController.open();
              }
              setState(() {
                _isPanelOpen = !_isPanelOpen;
              });
            },
            child: Container(
              padding: const EdgeInsets.all(16.0),
              width: double.infinity,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                ),
              ),
              child: Center(
                child: Icon(
                  _isPanelOpen
                      ? Icons.keyboard_arrow_down
                      : Icons.keyboard_arrow_up,
                  color: Colors.grey,
                  size: 35.0,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 25),
            child: Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween, // จัดเรียงให้วางห่างกัน
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // วันที่
                if (widget.selectedDate != null)
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFFDCEDF).withOpacity(0.5),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.all(14.5),
                    child: Text(
                      DateFormat('dd MMMM yyyy').format(widget.selectedDate!),
                      style: GoogleFonts.ibmPlexSansThai(
                        textStyle: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFec5091),
                        ),
                      ),
                    ),
                  ),

                // ปุ่ม Filter
                Padding(
                  padding:
                      const EdgeInsets.only(right: 25.0), // ระยะห่างจากวันที่
                  child: FilterButton(
                    labels: ['ยังไม่เสร็จ', 'เสร็จสิ้น'],
                    isSelected: [!widget.showCompleted, widget.showCompleted],
                    onPressed: (int index) {
                      // Handle filter button tap
                      if (index == 0) {
                        widget.onShowCompletedChanged(false);
                      } else {
                        widget.onShowCompletedChanged(true);
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: CalendarListWidget(
              selectedDate: widget.selectedDate,
              tasks: widget.tasks,
              showCompleted: widget.showCompleted,
            ),
          ),
        ],
      ),
      onPanelOpened: () => setState(() => _isPanelOpen = true),
      onPanelClosed: () => setState(() => _isPanelOpen = false),
    );
  }
}
