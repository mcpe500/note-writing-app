import 'package:flutter/material.dart';
import 'package:myapp/pages/home.dart';
import 'package:myapp/pages/home_local.dart';
import 'package:myapp/services/storage.dart';

class LoginApp extends StatelessWidget {
  const LoginApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.yellow[400],
        body: Center(
          child: SingleChildScrollView(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: const LoginPage(),
            ),
          ),
        ),
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
  late StorageService storage;

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    initStorage();
  }

  void initStorage() async {
    storage = await StorageService.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(Icons.email, size: 50, color: Colors.grey[800]),
          const SizedBox(height: 30),
          TextField(
            controller: usernameController,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.person),
              labelText: 'Username',
              filled: true,
              fillColor: Colors.grey[200],
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: passwordController,
            obscureText: true,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.lock),
              labelText: 'Password',
              filled: true,
              fillColor: Colors.grey[200],
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.grey[800],
              minimumSize: const Size(double.infinity, 50),
            ),
            child: const Text('Login'),
            onPressed: () async {
              List<String> accountsUsername =
                  await storage.loadArray('accountsUsername');
              List<String> accountsPassword =
                  await storage.loadArray('accountsPassword');
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
                await storage.saveArray("accountsUsername", accountsUsername);
                await storage.saveArray("accountsPassword", accountsPassword);

                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                        HomeApp(username: usernameController.text)));
              }
            },
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.grey[800],
              minimumSize: const Size(double.infinity, 50),
            ),
            child: const Text('Local Save'),
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => HomeAppLocal()));
            },
          )
        ],
      ),
    );
  }
}
