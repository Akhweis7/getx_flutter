import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx/controllers/kanban_controller.dart';
import 'package:getx/views/screens/kanban.dart';

class KanbanBoardScreen extends StatelessWidget {
  const KanbanBoardScreen({super.key, required this.username});

  final String username;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(KanbanController());

    return Scaffold(
      appBar: AppBar(
        title: Text('Kanban Board - $username'),
        centerTitle: false,
      ),
      body: Column(
        children: [
          _buildAddColumnBar(controller),
          Expanded(child: _buildBoard(controller)),
        ],
      ),
    );
  }

  Widget _buildAddColumnBar(KanbanController controller) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller.columnNameController,
              onSubmitted: (_) => controller.addTask(),
              decoration: InputDecoration(
                hintText: 'Enter column name',
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          IconButton.filled(
            tooltip: 'Add column',
            onPressed: controller.addTask,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }

  Widget _buildBoard(KanbanController controller) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }
      if (controller.tasks.isEmpty) {
        return const Center(
          child: Text(
            'No columns yet. Add one above to get started.',
            style: TextStyle(color: Colors.black54),
          ),
        );
      }
      return ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: controller.tasks.length,
        itemBuilder: (context, index) {
          final task = controller.tasks[index];
          return KanbanColumn(
            goal: 'Goal',
            TechStack: 'TechStack',
            dueDate: 'Due Date',
            task: task,
            onaddsubtask: (title) =>
                controller.addSubtask(task.id, title, username),
            ondeletesubtask: (subtask) =>
                controller.deleteSubtask(task.id, subtask),
          );
        },
      );
    });
  }
}
