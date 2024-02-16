import 'package:flutter/material.dart';
import 'package:neptun_app/ui/screens/timetable_screen.dart';
import 'package:neptun_app/ui/viewmodels/login_viewmodel.dart';
import 'package:neptun_app/ui/viewmodels/messages_viewmodel.dart';
import 'package:neptun_app/ui/viewmodels/personal_viewmodel.dart';
import 'package:neptun_app/ui/viewmodels/settings_viewmodel.dart';
import 'package:neptun_app/ui/viewmodels/timetable_viewmodel.dart';
import 'package:provider/provider.dart';

class NeptunApp extends StatefulWidget {
  const NeptunApp({super.key});

  @override
  State<NeptunApp> createState() => _NeptunAppState();
}

class _NeptunAppState extends State<NeptunApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => LoginViewmodel(),
        ),
        ChangeNotifierProvider(
          create: (context) => TimetableViewModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => MessagesViewmodel(),
        ),
        ChangeNotifierProvider(
          create: (context) => PersonalViewmodel(),
        ),
        ChangeNotifierProvider(
          create: (context) => SettingsViewmodel(),
        ),
      ],
      child: MaterialApp(
        title: "Neptun app",
        home: TimetableScreen(),
        theme: ThemeData.from(
          colorScheme: ColorScheme.fromSeed(
              seedColor: Color.fromARGB(255, 78, 178, 243)),
        ),
        darkTheme: ThemeData.from(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 78, 178, 243),
            brightness: Brightness.dark,
          ),
        ),
      ),
    );
  }
}
