import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TaskDialogWidget extends StatefulWidget {
  final String initialTitle;
  final String initialSubtitle;
  final IconData? initialIcon;
  final DateTime? initialStartDate;
  final DateTime? initialEndDate;
  final Function(Map<String, dynamic>) onSave;

  const TaskDialogWidget({
    super.key,
    required this.initialTitle,
    required this.initialSubtitle,
    this.initialIcon,
    this.initialStartDate,
    this.initialEndDate,
    required this.onSave,
  });

  @override
  _TaskDialogWidgetState createState() => _TaskDialogWidgetState();
}

class _TaskDialogWidgetState extends State<TaskDialogWidget> {
  late String title;
  late String subtitle;
  late IconData? selectedIcon;
  late DateTime startDate;
  late DateTime endDate;

  @override
  void initState() {
    super.initState();
    title = widget.initialTitle;
    subtitle = widget.initialSubtitle;
    selectedIcon = widget.initialIcon;
    startDate = widget.initialStartDate ?? DateTime.now();
    endDate = widget.initialEndDate ?? DateTime.now().add(const Duration(days: 1));
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStartDate ? startDate : endDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != (isStartDate ? startDate : endDate)) {
      setState(() {
        if (isStartDate) {
          startDate = picked;
        } else {
          endDate = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('New Task'),
      content: StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(labelText: 'Title'),
                onChanged: (value) {
                  title = value;
                },
              ),
              const SizedBox(height: 10),
              TextField(
                decoration: const InputDecoration(labelText: 'Subtitle'),
                onChanged: (value) {
                  subtitle = value;
                },
              ),
              const SizedBox(height: 10),
              const Text(
                'Select Start Date:',
                style: TextStyle(fontSize: 16),
              ),
              TextButton(
                onPressed: () => _selectDate(context, true),
                child: Text(DateFormat('yyyy-MM-dd').format(startDate)),
              ),
              const SizedBox(height: 10),
              const Text(
                'Select End Date:',
                style: TextStyle(fontSize: 16),
              ),
              TextButton(
                onPressed: () => _selectDate(context, false),
                child: Text(DateFormat('yyyy-MM-dd').format(endDate)),
              ),
              const SizedBox(height: 10),
              const Text(
                'Select Icon:',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildIconButton(Icons.book, setState),
                  _buildIconButton(Icons.palette, setState),
                  _buildIconButton(Icons.attach_money, setState),
                  _buildIconButton(Icons.terrain, setState),
                ],
              ),
            ],
          );
        },
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('CANCEL'),
        ),
        ElevatedButton(
          onPressed: () {
            if (title.isNotEmpty && subtitle.isNotEmpty) {
              final newTask = {
                'title': title,
                'subtitle': subtitle,
                'icon': selectedIcon?.codePoint,
                'startDate': DateFormat('yyyy-MM-dd').format(startDate),
                'endDate': DateFormat('yyyy-MM-dd').format(endDate),
                'createdAt': DateFormat('yyyy-MM-dd HH:mm:ss')
                    .format(DateTime.now().toLocal()),
              };
              widget.onSave(newTask);
              Navigator.of(context).pop();
            }
          },
          child: const Text('ADD'),
        ),
      ],
    );
  }

  // Function to build icon button with shadow
  Widget _buildIconButton(IconData icon, StateSetter setState) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedIcon = icon; // Update the selected icon
        });
      },
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: selectedIcon == icon
              ? const Color.fromARGB(137, 104, 110, 115)
                  .withOpacity(0.5) // Highlight color when selected
              : Colors.grey[300], // Default color
        ),
        child: Icon(
          icon,
          color: selectedIcon == icon
              ? Colors.white
              : Colors.black, // Icon color based on selection
        ),
      ),
    );
  }
}
