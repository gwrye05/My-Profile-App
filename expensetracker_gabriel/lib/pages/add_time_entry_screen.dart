
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../models/time_entry_model.dart';
import '../data_providers/time_entry_provider.dart';
import '../widgets/add_project_dialog.dart';
import '../widgets/add_task_dialog.dart';

class AddTimeEntryScreen extends StatefulWidget {
  final Expense? initialTimeEntry;

  const AddTimeEntryScreen({super.key, this.initialTimeEntry});

  @override
  State<AddTimeEntryScreen> createState() => _AddTimeEntryScreenState();
}

class _AddTimeEntryScreenState extends State<AddTimeEntryScreen> {
  late TextEditingController _titleController;
  late TextEditingController _amountController;
  late TextEditingController _noteController;

  String? _selectedProjectId;
  String? _selectedTaskId;
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();

    _titleController = TextEditingController(
      text: widget.initialTimeEntry?.title ?? '',
    );

    _amountController = TextEditingController(
      text: widget.initialTimeEntry?.amount.toString() ?? '',
    );

    _noteController = TextEditingController(
      text: widget.initialTimeEntry?.notes ?? '',
    );

    _selectedDate = widget.initialTimeEntry?.date ?? DateTime.now();

    // The existing project and task models are reused for categories and tags.
    final expense = widget.initialTimeEntry;
    if (expense != null) {
      _selectedProjectId = expense.categoryId;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ExpenseProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.initialTimeEntry == null ? 'Add Expense' : 'Edit Expense',
        ),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            buildTextField(
              _titleController,
              'Expense Name',
              TextInputType.text,
            ),
            buildTextField(
              _amountController,
              'Amount (\$)',
              const TextInputType.numberWithOptions(decimal: true),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: buildProjectDropdown(provider),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: buildTaskDropdown(provider),
            ),
            buildDateField(),
            buildTextField(
              _noteController,
              'Notes (optional)',
              TextInputType.text,
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepPurple,
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 50),
          ),
          onPressed: _saveExpense,
          child: const Text('Save Expense'),
        ),
      ),
    );
  }

  void _saveExpense() {
    final title = _titleController.text.trim();
    final amountText = _amountController.text.trim();
    final amount = double.tryParse(amountText);

    if (title.isEmpty || amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Enter an expense name and a valid amount greater than zero.'),
        ),
      );
      return;
    }

    if (_selectedProjectId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a category.')),
      );
      return;
    }

    final provider = Provider.of<ExpenseProvider>(context, listen: false);

    // Use the existing ID when editing so the expense is updated, not duplicated.
    final expense = Expense(
      id: widget.initialTimeEntry?.id ??
          provider.generateExpenseId().toString(),
      title: title,
      amount: amount,
      categoryId: _selectedProjectId!,
      date: _selectedDate,
      notes: _noteController.text.trim(),
    );

    provider.addOrUpdateExpense(expense);
    Navigator.pop(context);
  }

  Widget buildTextField(
    TextEditingController controller,
    String label,
    TextInputType type,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        keyboardType: type,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget buildDateField() {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(
        'Date: ${DateFormat('yyyy-MM-dd').format(_selectedDate)}',
      ),
      trailing: const Icon(Icons.calendar_today),
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: _selectedDate,
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
        );

        if (picked != null && mounted) {
          setState(() => _selectedDate = picked);
        }
      },
    );
  }

  Widget buildProjectDropdown(ExpenseProvider provider) {
    return DropdownButtonFormField<String>(
      initialValue: _selectedProjectId,
      decoration: const InputDecoration(
        labelText: 'Category',
        border: OutlineInputBorder(),
      ),
      items: [
        ...provider.projects.map(
          (project) => DropdownMenuItem<String>(
            value: project.id,
            child: Text(project.name),
          ),
        ),
        const DropdownMenuItem<String>(
          value: 'New',
          child: Text('Add New Category'),
        ),
      ],
      onChanged: (newValue) {
        if (newValue == 'New') {
          showDialog(
            context: context,
            builder: (_) => AddProjectDialog(
              onAdd: (newCategory) {
                provider.addProject(newCategory);
                setState(() => _selectedProjectId = newCategory.id);
              },
            ),
          );
        } else {
          setState(() => _selectedProjectId = newValue);
        }
      },
    );
  }

  Widget buildTaskDropdown(ExpenseProvider provider) {
    return DropdownButtonFormField<String>(
      initialValue: _selectedTaskId,
      decoration: const InputDecoration(
        labelText: 'Tag (optional)',
        border: OutlineInputBorder(),
      ),
      items: [
        ...provider.tasks.map(
          (task) => DropdownMenuItem<String>(
            value: task.id,
            child: Text(task.name),
          ),
        ),
        const DropdownMenuItem<String>(
          value: 'New',
          child: Text('Add New Tag'),
        ),
      ],
      onChanged: (newValue) {
        if (newValue == 'New') {
          showDialog(
            context: context,
            builder: (_) => AddTaskDialog(
              onAdd: (newTask) {
                provider.addTask(newTask);
                setState(() => _selectedTaskId = newTask.id);
              },
            ),
          );
        } else {
          setState(() => _selectedTaskId = newValue);
        }
      },
    );
  }
}
