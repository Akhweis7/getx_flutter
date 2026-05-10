import 'package:flutter/material.dart';
import 'package:getx/models/subtask.dart';
import 'package:getx/models/task.dart';
import 'package:getx/theme/app_theme.dart';
import 'package:getx/views/screens/subtask_tile.dart';

const double kColumnWidth = 260;

class KanbanColumn extends StatefulWidget {
  const KanbanColumn({
    super.key,
    required this.task,
    required this.onaddsubtask,
    required this.ondeletesubtask,
    required this.goal,
    required this.TechStack,
    required this.dueDate,
  });

  final Task task;
  final ValueChanged<String> onaddsubtask;
  final ValueChanged<Subtask> ondeletesubtask;
  final String goal;
  final String TechStack;
  final String dueDate;

  @override
  State<KanbanColumn> createState() => _KanbanColumnState();
}

class _KanbanColumnState extends State<KanbanColumn> {
  final TextEditingController _newsubtaskcontroller = TextEditingController();

  @override
  void dispose() {
    _newsubtaskcontroller.dispose();
    super.dispose();
  }

  void submitnewsubtask() {
    final text = _newsubtaskcontroller.text.trim();
    if (text.isEmpty) return;
    widget.onaddsubtask(text);
    _newsubtaskcontroller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: kColumnWidth,
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColors.columnBody,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          buildheader(),
          buildaddsubtaskrow(),
          Expanded(child: buildsubtasklist()),
        ],
      ),
    );
  }

  Widget buildheader() {
    return Container(
      height: 48,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: AppColors.columnHeader,
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      alignment: Alignment.center,
      child: Text(
        widget.task.title,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      ),
    );
  }

  Widget buildaddsubtaskrow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _newsubtaskcontroller,
              onSubmitted: (_) => submitnewsubtask(),
              decoration: InputDecoration(
                isDense: true,
                hintText: 'New subtask',
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 8,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          IconButton(
            tooltip: 'Add subtask',
            icon: const Icon(Icons.add_circle, color: AppColors.accent),
            onPressed: submitnewsubtask,
          ),
        ],
      ),
    );
  }

  Widget buildsubtasklist() {
    final subtasks = widget.task.subtasks;
    if (subtasks.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            'No subtasks yet.',
            style: TextStyle(color: Colors.black54),
          ),
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 4),
      itemCount: subtasks.length,
      itemBuilder: (context, index) {
        final subtask = subtasks[index];
        return SubtaskTile(
          slidekey: ValueKey('${widget.task.title}-$index-${subtask.title}'),
          subtask: subtask,
          goal: widget.goal,
          TechStack: widget.TechStack,
          dueDate: widget.dueDate,
          ondelete: () => widget.ondeletesubtask(subtask),
        );
      },
    );
  }
}
