import 'dart:io';

import 'package:basketball_statistics/my_app.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

main() async {
  if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
    sqfliteFfiInit();
  }
  databaseFactory = databaseFactoryFfi;

  
  runApp(const MyApp());
}
