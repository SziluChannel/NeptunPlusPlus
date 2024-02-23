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
  bool savePassword = false;
  String secretKey = "";

  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      Future.microtask(() async {
        var settingsViewmodel =
            Provider.of<SettingsViewmodel>(context, listen: false);
        var key = await settingsViewmodel.isKeySaved();
        var pass = await settingsViewmodel.isPasswordSaved();
        setState(() {
          saveKey = key;
          savePassword = pass;
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

  Builder twoFactorAuthKey(SettingsViewmodel settingsViewmodel) {
    return Builder(builder: (context) {
      if (savePassword) {
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
                    return savedKeyArea(
                      context,
                      settingsViewmodel,
                    );
                  } else {
                    return saveKeyArea(settingsViewmodel);
                  }
                }),
              ],
            ),
          ),
        );
      } else {
        return SizedBox.shrink();
      }
    });
  }

  Row saveKeyArea(SettingsViewmodel settingsViewmodel) {
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
                  setState(() {
                    settingsViewmodel.saveAuthSecretKey(secretKey);
                    saveKey = true;
                  });
                },
          child: Text("Save"),
        ),
      ],
    );
  }

  Row savedKeyArea(BuildContext context, SettingsViewmodel settingsViewmodel) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ElevatedButton(
          onPressed: () => verifyPasswordDialog(
            context,
            () {
              Navigator.pop(context);
              secretKeyDialog(
                context,
                settingsViewmodel.secretKey,
              );
            },
            settingsViewmodel,
          ),
          child: Text("See saved key"),
        ),
        ElevatedButton(
          onPressed: () => verifyPasswordDialog(
            context,
            () {
              Navigator.pop(context);
              areYouSureDialog(context, () {
                Navigator.pop(context);
                settingsViewmodel.clearCredentials();
              });
            },
            settingsViewmodel,
          ),
          child: Text("Clear all credentials"),
        ),
      ],
    );
  }

  Future<dynamic> areYouSureDialog(BuildContext context, VoidCallback onOk) {
    return showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Are you sure?"),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text("Cancel"),
                      ),
                      ElevatedButton(
                        onPressed: () => onOk(),
                        child: Text("Ok"),
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        });
  }

  Future<dynamic> secretKeyDialog(BuildContext context, String secretKey) {
    return showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    // the exit button
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(Icons.close),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Your code:"),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SelectableText(secretKey),
                  ),
                ]),
          );
        });
  }

  Future<dynamic> verifyPasswordDialog(
    BuildContext context,
    VoidCallback onSuccess,
    SettingsViewmodel settingsViewmodel,
  ) {
    String password = "";
    return showDialog(
      context: context,
      builder: (context) {
        String errorMessage = "";
        return Dialog(
          child: StatefulBuilder(builder: (context, StateSetter stateSetter) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(Icons.close),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Enter password to show stuff!!!"),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    obscureText: true,
                    onChanged: (value) {
                      password = value;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(errorMessage),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () async {
                      var result =
                          await settingsViewmodel.verifyPassword(password);

                      stateSetter.call(() {
                        result ? onSuccess() : "";
                        errorMessage = "Invalid password!";
                      });
                    },
                    child: Text("Verify..."),
                  ),
                ),
              ],
            );
          }),
        );
      },
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
