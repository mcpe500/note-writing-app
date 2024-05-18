import 'package:flutter/material.dart';

class HomeApp extends StatelessWidget {
  const HomeApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Home')),
        body: const HomePage(),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final TextEditingController searchController = TextEditingController();
  String username = 'Current User'; // Replace this with the actual username

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home - $username'), // Display the username in the header
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            TextField(
              controller: searchController,
              decoration: const InputDecoration(labelText: 'Search'),
            ),
            // Add a GridView for the dynamically sized columns
            Expanded(
              child: GridView.count(
                // Create a cross-axis count that adapts to the screen size
                crossAxisCount: MediaQuery.of(context).size.width > 800 ? 4 : MediaQuery.of(context).size.width > 600 ? 3 : 2,
                children: List.generate(100, (index) {
                  return Center(
                    child: Text(
                      'Item $index',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Handle button press here
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
