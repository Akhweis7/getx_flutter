import 'package:flutter/material.dart';
import 'package:getx/models/subtask.dart';
import 'package:getx/models/task.dart';
import 'package:getx/views/screens/kanban.dart';

class KanbanBoardScreen extends StatefulWidget {
  const KanbanBoardScreen({super.key, required this.username});

  final String username;

  @override
  State<KanbanBoardScreen> createState() => _KanbanBoardScreenState();
}

class _KanbanBoardScreenState extends State<KanbanBoardScreen> {
  final TextEditingController _columnnamecontroller = TextEditingController();
  final List<Task> _tasks = []; //Task.sampleList();

  @override
  void dispose() {
    _columnnamecontroller.dispose();
    super.dispose();
  }

  void addcolumn() {
    final title = _columnnamecontroller.text.trim();
    if (title.isEmpty) return;
    setState(() {
      _tasks.add(Task(title: title));
      _columnnamecontroller.clear();
    });
  }

  void addsubtask(int columnindex, String title) {
    setState(() {
      _tasks[columnindex].subtasks.add(
        Subtask(title: title, username: widget.username),
      );
    });
  }

  void deletesubtask(int columnindex, Subtask subtask) {
    setState(() {
      _tasks[columnindex].subtasks.remove(subtask);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kanban Board - ${widget.username}'),
        centerTitle: false,
      ),
      body: Column(
        children: [
          buildaddcolumnbar(),
          Expanded(child: buildboard()),
        ],
      ),
    );
  }

  Widget buildaddcolumnbar() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _columnnamecontroller,
              onSubmitted: (_) => addcolumn(),
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
            onPressed: addcolumn,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }

  Widget buildboard() {
    if (_tasks.isEmpty) {
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
      itemCount: _tasks.length,
      itemBuilder: (context, index) {
        return KanbanColumn(
          goal: 'Goal',
          TechStack: 'TechStack',
          dueDate: 'Due Date',
          task: _tasks[index],
          onaddsubtask: (title) => addsubtask(index, title),
          ondeletesubtask: (subtask) => deletesubtask(index, subtask),
        );
      },
    );
  }
}
