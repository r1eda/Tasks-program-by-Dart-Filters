import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'ListItem.dart';
import 'ListItemWidget.dart';
import 'theme_provider.dart';
import 'package:provider/provider.dart';

class List1 extends StatefulWidget {
  @override
  _List1State createState() => _List1State();
}

class _List1State extends State<List1> {
  List<ListItem> items = [];
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> itemsJson = prefs.getStringList('items') ?? [];

    setState(() {
      items = itemsJson.map((itemJson) {
        final Map<String, dynamic> json = Map<String, dynamic>.from(
          jsonDecode(itemJson) as Map<String, dynamic>,
        );
        return ListItem.fromJson(json);
      }).toList();
    });
  }

  void _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> itemsJson = items.map((item) {
      return jsonEncode(item.toJson());
    }).toList();

    prefs.setStringList('items', itemsJson);
  }

  void _deleteTask(int index) {
    setState(() {
      items.removeAt(index);
      _saveData();
    });
  }

  void _showAddTaskDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Task'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: titleController,
                decoration: InputDecoration(
                  labelText: 'Title',
                  hintText: 'Enter the task title',
                  // You can customize more styling options here
                ),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: descriptionController,
                decoration: InputDecoration(
                  labelText: 'Description',
                  hintText: 'Enter the task description',
                  // You can customize more styling options here
                ),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                setState(() {
                  items.add(
                    ListItem(
                      title: titleController.text,
                      description: descriptionController.text,
                    ),
                  );
                  _saveData();
                  titleController.clear();
                  descriptionController.clear();
                });
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.teal[500], // Button color
                onPrimary: Colors.white, // Text color
              ),
              child: Text('Add'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(
                primary: Colors.teal[500], // Text color
              ),
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _editTask(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Task'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: titleController..text = items[index].title ?? '',
                decoration: InputDecoration(
                  labelText: 'Title',
                  hintText: 'Enter the task title',
                  // You can customize more styling options here
                ),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: descriptionController
                  ..text = items[index].description ?? '',
                decoration: InputDecoration(
                  labelText: 'Description',
                  hintText: 'Enter the task description',
                  // You can customize more styling options here
                ),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                setState(() {
                  items[index].title = titleController.text;
                  items[index].description = descriptionController.text;
                  _saveData();
                  titleController.clear();
                  descriptionController.clear();
                });
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.teal[500], // Button color
                onPrimary: Colors.white, // Text color
              ),
              child: Text('Save'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(
                primary: Colors.teal[500], // Text color
              ),
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.teal[500],
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 8),
            Text('Task List'),
          ],
        ),
        actions: [
          InkWell(
            onTap: () {
              themeProvider.toggleTheme();
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Switch(
                    value: themeProvider.isDarkMode,
                    onChanged: (value) {
                      themeProvider.toggleTheme();
                    },
                    activeColor: Colors.white,
                    inactiveThumbColor: Colors.amber,
                    thumbColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                        return themeProvider.isDarkMode
                            ? Colors.indigo
                            : Colors.amber;
                      },
                    ),
                    inactiveTrackColor: Colors.amber.withOpacity(0.7),
                    activeTrackColor: Colors.indigo.withOpacity(0.7),
                    overlayColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                        return themeProvider.isDarkMode
                            ? Colors.indigo.withOpacity(0.2)
                            : Colors.amber.withOpacity(0.2);
                      },
                    ),
                  ),
                  CircleAvatar(
                    backgroundColor: Colors.transparent,
                    child: Icon(
                      themeProvider.isDarkMode
                          ? Icons.nightlight_round
                          : Icons.wb_sunny,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          // Positioned.fill في حالة القائمة فارغة
          Visibility(
            visible: items.isEmpty, // إظهارها فقط إذا كانت القائمة فارغة
            child: Positioned.fill(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add_task,
                      size: 50,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'قم بأضافة مهامك',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // ListView.builder
          ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              return Dismissible(
                key: Key(items[index].id.toString()),
                onDismissed: (direction) {
                  _deleteTask(index);
                },
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.only(right: 20.0),
                  child: Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                ),
                child: ListItemWidget(items[index], () {
                  _editTask(index);
                }),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTaskDialog,
        backgroundColor: Colors.teal[500],
        child: Icon(Icons.add),
      ),
    );
  }
}
