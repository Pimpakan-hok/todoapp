import 'package:todoapp/services/service.dart';

class TaskListViewModel {
  final TaskService _taskService = TaskService();

  Stream<List<Map<String, dynamic>>> getPendingTasksStream() {
    return _taskService.fetchTasksStream().map((tasks) {
      return tasks.where((task) => task['isCompleted'] == false).toList();
    });
  }

  Stream<List<Map<String, dynamic>>> getCompletedTasksStream() {
    return _taskService.fetchTasksStream().map((tasks) {
      return tasks.where((task) => task['isCompleted'] == true).toList();
    });
  }

  Future<void> deleteTask(String taskId) async {
    await _taskService.deleteTask(taskId);
  }

  Future<void> updateTaskCompletion(String taskId, bool completed) async {
    await _taskService.updateTaskCompletion(taskId, completed);
  }

  Future<void> addNewTask(Map<String, dynamic> newTask) async {
    await _taskService.addNewTask(newTask);
  }
}
