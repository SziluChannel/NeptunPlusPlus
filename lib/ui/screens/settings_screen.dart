import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:neptun_app/ui/screens/main_app_frame.dart';
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
  bool saveKey = false;
  String secretKey = "";

  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      Future.microtask(() async {
        var result =
            await Provider.of<SettingsViewmodel>(context, listen: false)
                .isKeySaved();
        setState(() {
          saveKey = result;
        });
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SettingsViewmodel settingsViewmodel = context.watch();

    return AppFrame(
      title: Text("Settings"),
      child: ListView(
        children: [
          darkThemeSwitch(settingsViewmodel),
          twoFactorAuthKey(settingsViewmodel),
        ],
      ),
    );
  }

  Card twoFactorAuthKey(SettingsViewmodel settingsViewmodel) {
    return Card(
      child: Padding(
        padding:
            const EdgeInsets.only(left: 30, right: 30, top: 10, bottom: 10),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Save two-factor authentication secret key"),
                Switch.adaptive(
                    value: saveKey,
                    onChanged: settingsViewmodel.keySaved
                        ? null
                        : (value) {
                            setState(() {
                              saveKey = value;
                            });
                          }),
              ],
            ),
            Builder(builder: (context) {
              if (settingsViewmodel.keySaved) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        print(
                            "Enter creds to view creds dialog should pop up...");
                      },
                      child: Text("See saved key"),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        print("Are you sure dialog should pop up...");
                      },
                      child: Text("Clear all credentials"),
                    ),
                  ],
                );
              } else {
                return Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        enabled: saveKey,
                        initialValue: secretKey,
                        onChanged: (value) {
                          secretKey = value;
                        },
                      ),
                    ),
                    ElevatedButton(
                      onPressed: !saveKey
                          ? null
                          : () {
                              settingsViewmodel.saveAuthSecretKey(secretKey);
                            },
                      child: Text("Save"),
                    ),
                  ],
                );
              }
            }),
          ],
        ),
      ),
    );
  }

  Card darkThemeSwitch(SettingsViewmodel settingsViewmodel) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.only(left: 30, right: 30),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Dark theme"),
            Switch.adaptive(
                value: settingsViewmodel.darkTheme,
                onChanged: (value) {
                  setState(() {
                    settingsViewmodel.setTheme(value);
                  });
                }),
          ],
        ),
      ),
    );
  }
}
