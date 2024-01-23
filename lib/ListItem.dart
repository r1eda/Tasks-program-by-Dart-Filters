import 'package:flutter/foundation.dart';

// فئة ListItem تمثل عنصرًا فرديًا في قائمة وتحتوي على بياناته وحالة تحققه.
class ListItem {
  int? id;
  String? title;
  String? description;
  ValueNotifier<bool> isCheckedNotifier;

  // البناء الرئيسي لإنشاء عنصر ListItem مع القيم الافتراضية.
  ListItem({
    this.id,
    this.title,
    this.description,
    bool isChecked = false,
  }) : isCheckedNotifier = ValueNotifier<bool>(isChecked);

  // تحويل بيانات العنصر إلى تنسيق JSON.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'isChecked': isCheckedNotifier.value,
    };
  }

  // تكوين عنصر ListItem باستخدام بيانات JSON.
  factory ListItem.fromJson(Map<String, dynamic> json) {
    return ListItem(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      isChecked: json['isChecked'] ?? false,
    );
  }
}