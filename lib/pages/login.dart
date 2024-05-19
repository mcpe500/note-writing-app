import 'package:flutter/material.dart';
import 'package:myapp/pages/home.dart';
import 'package:myapp/utils/storage.dart';

class LoginApp extends StatelessWidget {
  const LoginApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Login')),
        body: const LoginPage(),
      ),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          TextField(
            controller: usernameController,
            decoration: const InputDecoration(labelText: 'Username'),
          ),
          TextField(
            controller: passwordController,
            decoration: const InputDecoration(labelText: 'Password'),
            obscureText: true,
          ),
          ElevatedButton(
            child: const Text('Login'),
            onPressed: () async {
              List<String> accountsUsername =
                  await loadArray('accountsUsername');
              List<String> accountsPassword =
                  await loadArray('accountsPassword');
              if (accountsUsername.contains(usernameController.text)) {
                int index = accountsUsername.indexOf(usernameController.text);
                if (passwordController.text == accountsPassword[index]) {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          HomeApp(username: usernameController.text)));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Incorrect password. Please try again.')));
                }
              } else {
                accountsUsername.add(usernameController.text);
                accountsPassword.add(passwordController.text);
                await saveArray("accountsUsername", accountsUsername);
                await saveArray("accountsPassword", accountsPassword);
              }
            },
          ),
        ],
      ),
    );
  }
}
