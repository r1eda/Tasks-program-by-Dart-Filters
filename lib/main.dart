// استيراد مكتبة فلاتر لتصميم واجهة المستخدم.
import 'package:flutter/material.dart';

// استيراد مكتبة Provider لإدارة حالة التطبيق.
import 'package:provider/provider.dart';

// استيراد تنفيذ خاص بمزود المظهر.
import 'theme_provider.dart';

// استيراد تنفيذ خاص بعنصر ListView.
import 'ListView.dart';

// الدالة الرئيسية التي تشغل التطبيق.
void main() {
  // تشغيل التطبيق باستخدام ChangeNotifierProvider لإدارة حالة المظهر.
  runApp(
    ChangeNotifierProvider(
      // إنشاء مثيل من ThemeProvider.
      create: (context) => ThemeProvider(),
      // تعيين واجهة المستخدم الجذرية لتكون MyApp.
      child: MyApp(),
    ),
  );
}

// فئة MyApp، تعريف الهيكل الرئيسي للتطبيق.
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // استخدام Consumer للاستماع لتغييرات حالة ThemeProvider.
    return Consumer<ThemeProvider>(
      // بناء MaterialApp باستخدام التظيم الدينامي.
      builder: (context, themeProvider, child) {
        return MaterialApp(
          // تعطيل لافتة التصحيح في الوضع التطويري.
          debugShowCheckedModeBanner: false,
          // تعيين المظهر بناءً على حالة ThemeProvider.
          theme: themeProvider.themeData,
          // تعيين الشاشة الرئيسية إلى List1().
          home: List1(),
        );
      },
    );
  }
}