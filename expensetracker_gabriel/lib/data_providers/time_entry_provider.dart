
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:localstorage/localstorage.dart';

import '../models/time_entry_model.dart';
import '../models/project_model.dart';
import '../models/task_model.dart';

class ExpenseProvider with ChangeNotifier {
  final LocalStorage storage;

  List<Expense> _expenses = [];
  List<Task> _tasks = [];
  List<Project> _projects = [];

  List<Expense> get expenses => _expenses;
  List<Project> get projects => _projects;
  List<Task> get tasks => _tasks;

  ExpenseProvider(this.storage) {
    _loadProjectsFromStorage();
    _loadTasksFromStorage();
    _loadExpensesFromStorage();
  }

  void _loadExpensesFromStorage() {
    final storedExpenses = storage.getItem('expenses');

    if (storedExpenses != null) {
      final List<dynamic> decoded = jsonDecode(storedExpenses);

      _expenses = decoded
          .map((item) => Expense.fromJson(
                Map<String, dynamic>.from(item),
              ))
          .toList();
    } else {
      _saveExpensesToStorage();
    }
  }

  void _loadProjectsFromStorage() {
    final storedProjects = storage.getItem('projects');

    if (storedProjects != null) {
      final List<dynamic> decoded = jsonDecode(storedProjects);

      _projects = decoded
          .map((item) => Project.fromJson(
                Map<String, dynamic>.from(item),
              ))
          .toList();
    } else {
      _saveProjectsToStorage();
    }
  }

  void _loadTasksFromStorage() {
    final storedTasks = storage.getItem('tasks');

    if (storedTasks != null) {
      final List<dynamic> decoded = jsonDecode(storedTasks);

      _tasks = decoded
          .map((item) => Task.fromJson(
                Map<String, dynamic>.from(item),
              ))
          .toList();
    } else {
      _saveTasksToStorage();
    }
  }

  void _saveExpensesToStorage() {
    storage.setItem(
      'expenses',
      jsonEncode(_expenses.map((expense) => expense.toJson()).toList()),
    );
  }

  void _saveProjectsToStorage() {
    storage.setItem(
      'projects',
      jsonEncode(_projects.map((project) => project.toJson()).toList()),
    );
  }

  void _saveTasksToStorage() {
    storage.setItem(
      'tasks',
      jsonEncode(_tasks.map((task) => task.toJson()).toList()),
    );
  }

  // Add an expense.
  void addExpense(Expense expense) {
    _expenses.add(expense);
    _saveExpensesToStorage();
    notifyListeners();
  }

  // Add a new expense or update an existing one.
  void addOrUpdateExpense(Expense expense) {
    final index = _expenses.indexWhere((item) => item.id == expense.id);

    if (index != -1) {
      _expenses[index] = expense;
    } else {
      _expenses.add(expense);
    }

    _saveExpensesToStorage();
    notifyListeners();
  }

  // Delete an expense.
  void deleteExpense(String id) {
    _expenses.removeWhere((expense) => expense.id == id);
    _saveExpensesToStorage();
    notifyListeners();
  }

  // Add a category.
  void addProject(Project project) {
    if (!_projects.any(
      (item) => item.name == project.name,
    )) {
      _projects.add(project);
      _saveProjectsToStorage();
      notifyListeners();
    }
  }

  // Add a tag.
  void addTask(Task task) {
    if (!_tasks.any(
      (item) => item.name == task.name,
    )) {
      _tasks.add(task);
      _saveTasksToStorage();
      notifyListeners();
    }
  }

  // Delete a category.
  void deleteProject(String id) {
    _projects.removeWhere((project) => project.id == id);
    _saveProjectsToStorage();
    notifyListeners();
  }

  // Delete a tag.
  void deleteTask(String id) {
    _tasks.removeWhere((task) => task.id == id);
    _saveTasksToStorage();
    notifyListeners();
  }

  int generateProjectId() => _projects.length;

  int generateTaskId() => _tasks.length;

  int generateExpenseId() => _expenses.length;
}
