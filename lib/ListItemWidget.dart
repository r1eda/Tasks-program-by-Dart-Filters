import 'package:flutter/material.dart';
import 'ListItem.dart';

class ListItemWidget extends StatelessWidget {
  final ListItem item;
  final VoidCallback onEdit;

  ListItemWidget(this.item, this.onEdit);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ListTile(
              leading: ValueListenableBuilder<bool>(
                valueListenable: item.isCheckedNotifier,
                builder: (context, isChecked, child) {
                  return IconButton(
                    icon: Icon(
                      Icons.check_circle_sharp,
                      color: isChecked
                          ? Colors.green
                          : const Color.fromARGB(255, 170, 156, 156),
                    ),
                    onPressed: () {
                      item.isCheckedNotifier.value = !isChecked;
                    },
                  );
                },
              ),
              title: Text(
                "${item.title}",
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                "${item.description}",
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
              trailing: IconButton(
                icon: Icon(Icons.edit),
                onPressed: onEdit,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
