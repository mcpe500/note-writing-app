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
        backgroundColor: Colors.yellow[400],
        body: Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  spreadRadius: 3,
                  blurRadius: 6,
                ),
              ],
            ),
            child: HomePage(username: username),
          ),
        ),
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

  List<Widget> generateWidgets() {
    List<Widget> widgets = [];
    for (var index = 0; index < array.length; index++) {
      if (searchController.text.isNotEmpty) {
        if (array[index]
            .toLowerCase()
            .contains(searchController.text.toLowerCase())) {
          widgets.add(GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (context) => WritingApp(
                        writingIndex: index, username: widget.username)),
              );
            },
            child: Card(
              child: Center(
                child: Text(
                  array[index],
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
            ),
          ));
        }
      } else {
        widgets.add(GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                  builder: (context) => WritingApp(
                      writingIndex: index, username: widget.username)),
            );
          },
          child: Card(
            child: Center(
              child: Text(
                array[index],
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
          ),
        ));
      }
    }
    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: loadArray("writingHeader_${widget.username}"),
      builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          array = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(children: [
                  Container(
                      alignment: Alignment.centerLeft,
                      child: Text("Welcome, ${widget.username}")),
                  const Spacer(),
                  Container(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => const LoginApp()),
                          );
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(4.0),
                          child: Text('Logout'),
                        ),
                      ),
                    ),
                  )
                ]),
                TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    labelText: 'Search',
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: const OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    setState(() {});
                  },
                ),
                const SizedBox(height: 24.0),
                Expanded(
                  child: GridView.count(
                      crossAxisCount: MediaQuery.of(context).size.width > 800
                          ? 4
                          : MediaQuery.of(context).size.width > 600
                              ? 3
                              : 2,
                      children: generateWidgets()),
                ),
                const SizedBox(height: 24.0),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.grey[800],
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  onPressed: () async {
                    array.add('New Item');
                    saveArray("writingHeader_${widget.username}", array);
                    List<String> writingText =
                        await loadArray("writingText_${widget.username}");
                    writingText.add('New Item Text');
                    saveArray("writingText_${widget.username}", writingText);
                    setState(() {});
                  },
                  child: const Text('Add New Item'),
                ),
                const SizedBox(height: 24.0),
              ],
            ),
          );
        }
      },
    );
  }
}
