import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';

class TaskService {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref('tasks');

  // ดึงข้อมูล tasks ทั้งหมดจาก Firebase
  Stream<List<Map<String, dynamic>>> fetchTasksStream() {
    return _dbRef.onValue.map((event) {
      final snapshot = event.snapshot;
      if (snapshot.exists) {
        Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;
        List<Map<String, dynamic>> tasks = [];
        data.forEach((key, value) {
          tasks.add({
            'id': key,
            'title': value['title'],
            'subtitle': value['subtitle'],
            'icon': value['icon'],
            'startDate': DateTime.parse(value['startDate']),
            'endDate': DateTime.parse(value['endDate']),
            'historyDate': value['historyDate'] != null
                ? DateTime.parse(value['historyDate'])
                : null,
            'createdAt': value['createdAt'],
            'isCompleted': value['isCompleted'],
          });
        });
        return tasks;
      } else {
        return [];
      }
    });
  }

  Future<void> addNewTask(Map<String, dynamic> newTask) async {
    try {
      final newTaskRef = _dbRef.push();
      newTask['createdAt'] = DateTime.now().toIso8601String();
      await newTaskRef.set(newTask);
      print('Task added successfully');
    } catch (e) {
      print('Error adding new task: $e');
    }
  }

  Future<void> updateTask(Map<String, dynamic> task) async {
    try {
      final updates = <String, dynamic>{};

      if (task['title'] != null) updates['title'] = task['title'];
      if (task['subtitle'] != null) updates['subtitle'] = task['subtitle'];
      if (task['icon'] != null) updates['icon'] = task['icon'];
      if (task['startDate'] != null)
        updates['startDate'] = DateTime.parse(task['startDate'])
            .toIso8601String(); // Convert back to string
      if (task['endDate'] != null)
        updates['endDate'] = DateTime.parse(task['endDate'])
            .toIso8601String(); // Convert back to string

      if (task['taskId'] == null) {
        print("Task ID is null, cannot update.");
        return;
      }

      updates['updatedAt'] =
          DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());

      await _dbRef.child(task['taskId']).update(updates);
      print('Task updated successfully');
    } catch (e) {
      print('Error updating task: $e');
    }
  }

  // อัปเดตสถานะการเสร็จสิ้นของงาน และบันทึก historyDate
  Future<void> updateTaskCompletion(String taskId, bool isCompleted) async {
    try {
      final now = DateTime.now();
      final historyDate = DateFormat('yyyy-MM-dd')
          .format(now); // สร้างวันที่ปัจจุบันในรูปแบบ yyyy-MM-dd

      // อัปเดตสถานะ isCompleted และบันทึก historyDate
      await _dbRef.child(taskId).update({
        'isCompleted': isCompleted,
        'historyDate': historyDate, // บันทึกวันที่ที่ทำการอัปเดต
      });

      print(
          "Task completion status updated to: $isCompleted and historyDate updated to: $historyDate");
    } catch (e) {
      print("Failed to update task: $e");
    }
  }

  // ลบงานออกจาก Firebase
  Future<void> deleteTask(String taskId) async {
    try {
      await _dbRef.child(taskId).remove();
    } catch (e) {
      print('Error deleting task: $e');
    }
  }

  // ดึงข้อมูลงานตาม taskId
  Future<Map<String, dynamic>?> getTaskById(String taskId) async {
    try {
      final snapshot = await _dbRef.child(taskId).get();
      if (snapshot.exists) {
        final data = snapshot.value as Map<dynamic, dynamic>;
        return {
          'title': data['title'],
          'subtitle': data['subtitle'],
          'icon': data['icon'],
          'startDate': data['startDate'],
          'endDate': data['endDate'],
        };
      }
    } catch (e) {
      print('Error fetching task: $e');
    }
    return null;
  }

  Future<void> deleteOldTasks() async {
    final snapshot = await _dbRef.once();
    final tasks = snapshot.snapshot.children;

    for (var task in tasks) {
      final taskData = task.value as Map<dynamic, dynamic>;
      final createdAt = DateTime.tryParse(taskData['createdAt'] ?? '');
      final now = DateTime.now();

      // เช็คว่า Task สำเร็จและเกิน 30 วัน
      if (taskData['isCompleted'] == true &&
          createdAt != null &&
          now.difference(createdAt).inDays > 30) {
        await _dbRef.child(task.key!).remove();
      }
    }
  }

  Future<void> updateTaskHistoryDate(String taskId) async {
    try {
      final now = DateTime.now();
      final historyDate =
          DateFormat('yyyy-MM-dd').format(now); // บันทึกวันที่ที่ทำการอัปเดต

      await _dbRef.child(taskId).update({
        'historyDate':
            historyDate, // บันทึก historyDate โดยไม่เกี่ยวข้องกับสถานะ
      });

      print("Task history date updated to: $historyDate");
    } catch (e) {
      print("Failed to update task history date: $e");
    }
  }

  Future<void> updateCompletedDate(String taskId, String historyDate) async {
    try {
      // อัปเดตสถานะการเสร็จสิ้น และ historyDate
      await _dbRef.child(taskId).update({
        'isCompleted': true,
        'historyDate': historyDate, // บันทึกวันที่ที่ทำการอัปเดต
      });

      print(
          "Task completion status updated to: true and historyDate updated to: $historyDate");
    } catch (e) {
      print("Failed to update task completion status: $e");
    }
  }
}
