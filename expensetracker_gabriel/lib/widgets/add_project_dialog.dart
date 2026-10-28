import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/project_model.dart';
import '../data_providers/time_entry_provider.dart';

class AddProjectDialog extends StatefulWidget {
  final Function(Project) onAdd;

  const AddProjectDialog({super.key, required this.onAdd});

  @override
  State<AddProjectDialog> createState() => _AddProjectDialogState();
}

class _AddProjectDialogState extends State<AddProjectDialog> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add New Category'),
      content: TextField(
        controller: _controller,
        decoration: InputDecoration(
          labelText: 'Category Name',
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
  final name = _controller.text.trim();

  if (name.isEmpty) {
    return;
  }

  final newProject = Project(
    id: Provider.of<ExpenseProvider>(context, listen: false)
        .generateProjectId()
        .toString(),
    name: name,
  );

  widget.onAdd(newProject);
  _controller.clear();
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
