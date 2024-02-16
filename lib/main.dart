import 'package:flutter/material.dart';
import 'package:neptun_app/data/local/database.dart';
import 'package:neptun_app/ui/screens/main_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var _ = NeptunDatabase().database;
  runApp(const NeptunApp());
}
