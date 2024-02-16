import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:neptun_app/ui/viewmodels/login_viewmodel.dart';
import 'package:provider/provider.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({
    super.key,
  });

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  Widget build(BuildContext context) {
    var loginViewmodel = context.watch<LoginViewmodel>();

    if (loginViewmodel.authenticated || !loginViewmodel.loggedIn) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        Navigator.pop(context);
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("LOGIN"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20.0),
            child: authArea(context, loginViewmodel.authenticate,
                loginViewmodel.errorMessage),
          ),
        ],
      ),
    );
  }

  Column authArea(BuildContext context, Function(String token) onAuthClicked,
      String errorMessage) {
    var token = "tokán";
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(errorMessage,
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("ENTER YOUR TOKEN!",
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            onChanged: (value) {
              token = value;
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            onPressed: () {
              onAuthClicked(token);
            },
            child: Text("NEXT!!!"),
          ),
        ),
      ],
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({
    super.key,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String uname = "";
  String pwd = "";
  bool saveCredentials = false;

  @override
  Widget build(BuildContext context) {
    var loginViewmodel = context.watch<LoginViewmodel>();

    if (loginViewmodel.authenticated) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        Navigator.pop(context);
      });
    } else if (loginViewmodel.loggedIn) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const AuthScreen(),
          ),
        );
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("LOGIN"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20.0),
            child: loginArea(
                context, loginViewmodel.login, loginViewmodel.errorMessage),
          ),
        ],
      ),
    );
  }

  Column loginArea(
      BuildContext context,
      Function(String username, String password, bool saveCredentials)
          onLoginClicked,
      String errorMessage) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            errorMessage,
            style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "ENTER YOUR CREDENTIALS!",
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            initialValue: uname,
            onChanged: (value) {
              uname = value;
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            obscureText: true,
            onChanged: (value) {
              pwd = value;
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text("Save credentials"),
              Switch.adaptive(
                value: saveCredentials,
                onChanged: (value) {
                  setState(() {
                    saveCredentials = value;
                  });
                },
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            onPressed: () {
              onLoginClicked(uname, pwd, saveCredentials);
            },
            child: Text("NEXT!!!"),
          ),
        ),
      ],
    );
  }
}
