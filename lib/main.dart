import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

import 'view/pages/home_page.dart';

//* INFO, WARNING, FATAL, Exception

void main() async {
  if (kReleaseMode) {
    // Don't log anything below warnings in production.
    Logger.root.level = Level.WARNING;
  }
  Logger.root.onRecord.listen((record) {
    final logString = '${record.level.name.padRight(7)} : ${record.time} : '
        '${record.loggerName} : '
        '${record.message}';
    debugPrint(logString);
  });
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Zebrra Challenge',
      debugShowCheckedModeBanner: false,
      home: MyHomePage(title: 'News'),
    );
  }
}
