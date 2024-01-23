import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'ListItem.dart';
import 'ListItemWidget.dart';
import 'theme_provider.dart';
import 'package:provider/provider.dart';

// فئة List1 هي واجهة المستخدم الرئيسية التي تعرض وتدير قائمة المهام.
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

  // تحميل البيانات من SharedPreferences عند تشغيل التطبيق.
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

  // حفظ البيانات في SharedPreferences عند إضافة أو تحرير عنصر.
  void _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> itemsJson = items.map((item) {
      return jsonEncode(item.toJson());
    }).toList();

    prefs.setStringList('items', itemsJson);
  }

  // حذف عنصر من القائمة.
  void _deleteTask(int index) {
    setState(() {
      items.removeAt(index);
      _saveData();
    });
  }

  // عرض حوار إضافة مهمة جديدة.
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
                ),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: descriptionController,
                decoration: InputDecoration(
                  labelText: 'Description',
                  hintText: 'Enter the task description',
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
                primary: Colors.teal[500],
                onPrimary: Colors.white,
              ),
              child: Text('Add'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(
                primary: Colors.teal[500],
              ),
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  // عرض حوار تحرير مهمة.
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
                ),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: descriptionController
                  ..text = items[index].description ?? '',
                decoration: InputDecoration(
                  labelText: 'Description',
                  hintText: 'Enter the task description',
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
                primary: Colors.teal[500],
                onPrimary: Colors.white,
              ),
              child: Text('Save'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(
                primary: Colors.teal[500],
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
          // تبديل نمط التطبيق
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
                  // أيقونة القمر أو الشمس باختلاف نمط التطبيق
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
          // العرض المركب في حالة عدم وجود مهام
          Visibility(
            visible: items.isEmpty,
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
          // عرض القائمة باستخدام ListView.builder
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