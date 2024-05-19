import 'package:flutter/material.dart';
import 'package:myapp/pages/login.dart';
import 'package:myapp/pages/writing.dart';
import 'package:myapp/utils/storage.dart';

class HomeApp extends StatelessWidget {
  final String username;

  const HomeApp({super.key, required this.username});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Home')),
        body: HomePage(username: username),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  final String username;

  const HomePage({super.key, required this.username});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final TextEditingController searchController = TextEditingController();
  List<String> array = [];

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: loadArray("writingHeader_${widget.username}"),
      builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(); // Show a loading spinner while waiting
        } else {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            array = snapshot.data!; // Load the data into your array
            return Scaffold(
              appBar: AppBar(
                title: Text(
                    'Home - ${widget.username}'), // Display the username in the header
                actions: <Widget>[
                  IconButton(
                    icon: const Icon(Icons.logout),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => const LoginApp()),
                      );
                    },
                  ),
                ],
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
                        crossAxisCount: MediaQuery.of(context).size.width > 800
                            ? 4
                            : MediaQuery.of(context).size.width > 600
                                ? 3
                                : 2,
                        children: List.generate(array.length, (index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (context) => WritingApp(
                                        writingIndex: index,
                                        username: widget.username)),
                              );
                            },
                            child: Center(
                              child: Text(
                                array[index],
                                style:
                                    Theme.of(context).textTheme.headlineSmall,
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                  ],
                ),
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () async {
                  // Handle button press here
                  array.add('New Item');
                  saveArray("writingHeader_${widget.username}", array);
                  List<String> writingText =
                      await loadArray("writingText_${widget.username}");
                  writingText.add('New Item Text');
                  saveArray("writingText_${widget.username}", writingText);
                  setState(() {});
                },
                tooltip: 'Increment',
                child: const Icon(Icons.add),
              ),
            );
          }
        }
      },
    );
  }
}
