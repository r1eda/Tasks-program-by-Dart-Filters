import 'package:flutter/material.dart';

// فئة ThemeProvider تمثل مزود المظهر وتمتلك وظيفة تغيير النمط والإشعار بالتغييرات.
class ThemeProvider with ChangeNotifier {
  bool _isDarkMode = false;

  // الحصول على حالة النمط الحالية (فاتح أو داكن).
  bool get isDarkMode => _isDarkMode;

  // الحصول على بيانات المظهر الحالية بناءً على حالة النمط.
  ThemeData get themeData => _isDarkMode ? darkTheme : lightTheme;

  // تبديل النمط بين الفاتح والداكن وإعلام المستمعين بالتغيير.
  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  // تكوين المظهر الفاتح للتطبيق.
  static final ThemeData lightTheme = ThemeData(
    textTheme: TextTheme(
      bodyText1: TextStyle(
        fontFamily: 'lbc',
        fontSize: 16.0,
        fontWeight: FontWeight.bold,
      ),
      bodyText2: TextStyle(
        fontFamily: 'lbc',
        fontSize: 16.0,
        fontWeight: FontWeight.bold,
      ),
    ),
    // يمكن إضافة المزيد من تكوينات المظهر الفاتح هنا.
  );

  // تكوين المظهر الداكن للتطبيق.
  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    textTheme: TextTheme(
      bodyText1: TextStyle(
        fontFamily: 'lbc',
        fontSize: 16.0,
        fontWeight: FontWeight.bold,
      ),
      bodyText2: TextStyle(
        fontFamily: 'lbc',
        fontSize: 16.0,
        fontWeight: FontWeight.bold,
      ),
    ),
    // يمكن إضافة المزيد من تكوينات المظهر الداكن هنا.
  );

  // أيقونة القمر المستخدمة عند التبديل إلى النمط الداكن.
  static final IconData moonIcon = Icons.nightlight_round;

  // أيقونة الشمس المستخدمة عند التبديل إلى النمط الفاتح.
  static final IconData sunIcon = Icons.wb_sunny;
}