import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:intl/intl.dart';

import 'package:collection/collection.dart';

import '../data_providers/time_entry_provider.dart';

import '../models/time_entry_model.dart';

import 'add_time_entry_screen.dart';

import '../models/project_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final _allEntryTabLabel = 'All Expenses';

  final _groupByCategoryTabLabel = 'By Category';

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense Tracker'),

        backgroundColor: Colors.deepPurple,

        foregroundColor: Colors.white,

        bottom: TabBar(
          controller: _tabController,

          indicatorColor: Colors.white,

          labelColor: Colors.white,

          unselectedLabelColor: Colors.white70,

          tabs: [
            Tab(text: _allEntryTabLabel),

            Tab(text: _groupByCategoryTabLabel),
          ],
        ),
      ),

      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,

          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.deepPurple),

              child: Text(
                'Expense Tracker',

                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),

            ListTile(
              leading: const Icon(Icons.category, color: Colors.deepPurple),

              title: const Text('Manage Categories'),

              onTap: () {
                Navigator.pop(context);

                Navigator.pushNamed(context, '/manage_projects');
              },
            ),

            ListTile(
              leading: const Icon(Icons.label, color: Colors.deepPurple),

              title: const Text('Manage Tags'),

              onTap: () {
                Navigator.pop(context);

                Navigator.pushNamed(context, '/manage_tasks');
              },
            ),
          ],
        ),
      ),

      body: TabBarView(
        controller: _tabController,

        children: [buildExpensesByDate(), buildExpensesByCategory()],
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple,

        foregroundColor: Colors.white,

        tooltip: 'Add Expense',

        onPressed: () {
          Navigator.push(
            context,

            MaterialPageRoute(builder: (context) => AddTimeEntryScreen()),
          );
        },

        child: const Icon(Icons.add),
      ),
    );
  }

  Widget buildExpensesByDate() {
    return Consumer<ExpenseProvider>(
      builder: (context, provider, child) {
        if (provider.expenses.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,

              children: [
                Icon(Icons.receipt_long, size: 50, color: Colors.deepPurple),

                SizedBox(height: 8),

                Text('No expenses yet!', style: TextStyle(fontSize: 24)),

                Text(
                  'Tap + to add your first expense.',

                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          itemCount: provider.expenses.length,

          itemBuilder: (context, index) {
            final expense = provider.expenses[index];

            final formattedDate = DateFormat(
              'MMM dd, yyyy',
            ).format(expense.date);

            return Dismissible(
              key: Key(expense.id),

              direction: DismissDirection.endToStart,

              onDismissed: (direction) {
                provider.deleteExpense(expense.id);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Expense deleted')),
                );
              },

              background: Container(
                color: Colors.red,

                padding: const EdgeInsets.symmetric(horizontal: 20),

                alignment: Alignment.centerRight,

                child: const Icon(Icons.delete, color: Colors.white),
              ),

              child: Card(
                color: Colors.purple[50],

                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),

                child: ListTile(
                  isThreeLine: true,

                  title: Text(
                    '${provider.projects.firstWhere(
                      (project) => project.id == expense.categoryId,

                      orElse: () => Project(id: '', name: 'Unknown'),
                    ).name} - ${expense.title}',
                  ),

                  subtitle: Text(
                    'Category: ${provider.projects.firstWhere(
                      (project) => project.id == expense.categoryId,
                      orElse: () => Project(id: '', name: 'Unknown'),
                    ).name}'
                    '\nDate: $formattedDate'
                    '\nNotes: ${expense.notes.isNotEmpty ? expense.notes : 'None'}',
                  ),

                  trailing: Text(
                    NumberFormat.currency(symbol: '\$').format(expense.amount),

                    style: const TextStyle(
                      fontWeight: FontWeight.bold,

                      fontSize: 16,

                      color: Colors.deepPurple,
                    ),
                  ),

                  onTap: () {
                    Navigator.push(
                      context,

                      MaterialPageRoute(
                        builder: (context) =>
                            AddTimeEntryScreen(initialTimeEntry: expense),
                      ),
                    );
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget buildExpensesByCategory() {
    return Consumer<ExpenseProvider>(
      builder: (context, provider, child) {
        if (provider.expenses.isEmpty) {
          return const Center(
            child: Text(
              'Add an expense to see your categories.',

              style: TextStyle(fontSize: 18),
            ),
          );
        }

        final grouped = groupBy(
          provider.expenses,

          (Expense expense) => provider.projects
              .firstWhere(
                (project) => project.id == expense.categoryId,
                orElse: () => Project(id: '', name: 'Unknown'),
              )
              .name,
        );

        return ListView(
          children: grouped.entries.map((entry) {
            final total = entry.value.fold<double>(
              0.0,

              (sum, expense) => sum + expense.amount,
            );

            return Card(
              margin: const EdgeInsets.all(10),

              child: ExpansionTile(
                leading: const Icon(Icons.category, color: Colors.deepPurple),

                title: Text(
                  entry.key,

                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),

                trailing: Text(
                  NumberFormat.currency(symbol: '\$').format(total),

                  style: const TextStyle(
                    color: Colors.deepPurple,

                    fontWeight: FontWeight.bold,
                  ),
                ),

                children: entry.value.map((expense) {
                  return ListTile(
                    title: Text(expense.title),

                    subtitle: Text(
                      DateFormat('MMM dd, yyyy').format(expense.date),
                    ),

                    trailing: Text(
                      NumberFormat.currency(
                        symbol: '\$',
                      ).format(expense.amount),
                    ),
                  );
                }).toList(),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
