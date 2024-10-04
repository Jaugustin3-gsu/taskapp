import 'package:flutter/material.dart';

void main() {
  runApp(TasksApp());
}

class TasksApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tasks App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TaskHomePage(),
    );
  }
}

class Task {
  String description;
  bool isCompleted;

  Task({required this.description, this.isCompleted = false});
}

class TaskHomePage extends StatefulWidget {
  @override
  _TaskHomePageState createState() => _TaskHomePageState();
}

class _TaskHomePageState extends State<TaskHomePage> {
  final List<Task> _tasks = []; // Store tasks as Task objects
  final TextEditingController _taskController = TextEditingController(); // Controller for input

  // Function to add task
  void _addTask() {

    if (_taskController.text.isNotEmpty) {
      
      setState(() {
        _tasks.add(Task(description: _taskController.text));
        _taskController.clear();
      });
    }
  }

  // Show tasks in a bottom sheet
  void _viewTasks() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder( // Use StatefulBuilder to maintain state within the bottom sheet
            builder: (BuildContext context, StateSetter setModalState) {
              return Container(
                height: 300,
                child: ListView.builder(
                  itemCount: _tasks.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(
                        _tasks[index].description,
                        style: TextStyle(
                          decoration: _tasks[index].isCompleted
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                        ),
                      ),
                      onTap: () {
                        // Toggle task completion when the task is tapped
                        setModalState(() {
                          _tasks[index].isCompleted = !_tasks[index].isCompleted;
                        });
                      },
                      leading: Checkbox(
                        value: _tasks[index].isCompleted,
                        onChanged: (bool? value) {
                          setModalState(() {
                            _tasks[index].isCompleted = value ?? false;
                          });
                        },
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          setModalState(() {
                            _tasks.removeAt(index); // Remove task at the current index
                          });
                        },
                      ),
                    );
                  },
                ),
              );
            },
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task Manager'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            // Text field for user to input task
            TextField(
              controller: _taskController,
              decoration: InputDecoration(labelText: 'Enter Task'),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _addTask, // Add task on button press
                  child: Text('Add Task'),
                ),
                ElevatedButton(
                  onPressed: _viewTasks, // View tasks list in bottom sheet
                  child: Text('View Tasks'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
