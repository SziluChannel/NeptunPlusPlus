import 'package:flutter/material.dart';
import 'package:neptun_app/ui/screens/main_app_frame.dart';
import 'package:neptun_app/ui/screens/main_screen.dart';
import 'package:neptun_app/ui/viewmodels/settings_viewmodel.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({
    super.key,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool darkTheme = false;
  @override
  Widget build(BuildContext context) {
    SettingsViewmodel settingsViewmodel = context.watch();

    return AppFrame(
      child: ListView(
        children: [
          Card(
            child: Row(
              children: [
                Text("Dark theme"),
                Switch.adaptive(
                    value: darkTheme,
                    onChanged: (value) {
                      setState(() {
                        darkTheme = value;
                      });
                    }),
              ],
            ),
          ),
          Card(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text("SETTINGS"),
                ElevatedButton(
                  onPressed: () {
                    print("PRESSED!!!");
                  },
                  child: Text("SETTINGS"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
