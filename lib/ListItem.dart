import 'package:flutter/foundation.dart';
class ListItem {
  int? id;
  String? title;
  String? description;
  ValueNotifier<bool> isCheckedNotifier;

  ListItem({this.id, this.title, this.description, bool isChecked = false,
  }) : isCheckedNotifier = ValueNotifier<bool>(isChecked);

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
       'isChecked': isCheckedNotifier.value,
    };
  }

  factory ListItem.fromJson(Map<String, dynamic> json) {
    return ListItem(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      isChecked: json['isChecked'] ?? false,
    );
  }
}
