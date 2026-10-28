import 'package:provider/provider.dart';

import 'package:flutter/material.dart';
import '../models/task_model.dart';
import '../data_providers/time_entry_provider.dart';

class AddTaskDialog extends StatefulWidget {
  final Function(Task) onAdd;

  const AddTaskDialog({super.key,required this.onAdd});

  @override
  State<AddTaskDialog> createState() => _AddTaskDialogState();
}

class _AddTaskDialogState extends State<AddTaskDialog> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add New Tag'),
      content: TextField(
        controller: _controller,
        decoration: InputDecoration(
          labelText: 'Tag Name',
        ),
      ),
      actions: [
        TextButton(
          child: Text('Cancel'),
          onPressed: () => Navigator.of(context).pop(),
        ),
        TextButton(
          child: Text('Add'),
          onPressed: () {
            var newTask = Task(id: Provider.of<ExpenseProvider>(context, listen: false).generateTaskId().toString(), name: _controller.text);
            widget.onAdd(newTask);
            // Update the provider and UI
            Provider.of<ExpenseProvider>(context, listen: false).addTask(newTask);
            // Clear the input field for next input
            _controller.clear();

            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
