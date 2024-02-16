import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:neptun_app/ui/screens/login_screen.dart';
import 'package:neptun_app/ui/screens/messages_screen.dart';
import 'package:neptun_app/ui/screens/personal_screen.dart';
import 'package:neptun_app/ui/screens/settings_screen.dart';
import 'package:neptun_app/ui/screens/timetable_screen.dart';
import 'package:neptun_app/ui/viewmodels/login_viewmodel.dart';
import 'package:neptun_app/ui/viewmodels/settings_viewmodel.dart';
import 'package:provider/provider.dart';

class AppFrame extends StatefulWidget {
  const AppFrame({
    super.key,
    required this.child,
    this.bottomNavigationBar,
    this.title,
  });

  final BottomAppBar? bottomNavigationBar;
  final Widget child;
  final Widget? title;

  @override
  State<AppFrame> createState() => _AppFrameState();
}

class _AppFrameState extends State<AppFrame> {
  static var selectedIndex = 1;

  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      Future.microtask(() async {
        Provider.of<SettingsViewmodel>(
          context,
          listen: false,
        ).getTheme();
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var loginViewmodel = context.watch<LoginViewmodel>();

    SchedulerBinding.instance.addPostFrameCallback((_) {});

    return Scaffold(
      body: widget.child,
      bottomNavigationBar: widget.bottomNavigationBar,
      appBar: AppBar(
        centerTitle: true,
        title: widget.title ?? Text("TITLE"),
        automaticallyImplyLeading: true,
      ),
      drawer: NavigationDrawer(
          selectedIndex: selectedIndex,
          onDestinationSelected: (value) => {
                selectedIndex = value != 0 ? value : selectedIndex,
                Navigator.pop(context),
                switch (value) {
                  0 => onLoginButtonSelected(loginViewmodel, () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                      );
                    }, () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AuthScreen(),
                        ),
                      );
                    }),
                  1 => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const TimetableScreen(),
                      ),
                    ),
                  2 => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MessagesScreen(),
                      ),
                    ),
                  3 => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PersonalScreen(),
                      ),
                    ),
                  4 => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SettingsScreen(),
                      ),
                    ),
                  _ => throw UnimplementedError("THIS IS NOT IMPLEMENTED!!!"),
                },
              },
          children: [
            NavigationDrawerDestination(
              icon: (!loginViewmodel.authenticated)
                  ? Icon(Icons.login)
                  : Icon(Icons.logout),
              label: (!loginViewmodel.authenticated)
                  ? Text("LOGIN")
                  : Text("LOGOUT"),
            ),
            NavigationDrawerDestination(
              icon: Icon(Icons.calendar_view_day),
              label: Text("TIMETABLE"),
            ),
            NavigationDrawerDestination(
              icon: Icon(Icons.message),
              label: Text("MESSAGES"),
            ),
            NavigationDrawerDestination(
              icon: Icon(Icons.account_box),
              label: Text("PERSONAL"),
            ),
            NavigationDrawerDestination(
              icon: Icon(Icons.settings),
              label: Text("SETTINGS"),
            ),
          ]),
    );
  }

  void onLoginButtonSelected(
    LoginViewmodel loginViewmodel,
    VoidCallback toLogin,
    VoidCallback toAuth,
  ) async {
    if (loginViewmodel.authenticated) {
      loginViewmodel.logout();
    } else {
      if (await loginViewmodel.getCredentialsAndAutoLogin()) {
        if (!loginViewmodel.authenticated) {
          toAuth.call();
        }
      } else {
        toLogin.call();
      }
    }
  }
}
