import 'package:flutter/material.dart';
import 'package:myapp/pages/login.dart';
import 'package:myapp/pages/writing_local.dart';
import 'package:myapp/services/index.dart';
import 'package:myapp/services/storage.dart';

class HomeAppLocal extends StatelessWidget {
  const HomeAppLocal({super.key});

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
            child: const HomePage(),
          ),
        ),
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
                    builder: (context) => WritingApp(writingIndex: index)),
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
                  builder: (context) => WritingApp(writingIndex: index)),
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
      future: StorageService.getInstance()
          .then((s) => s.loadArray("writingHeader_local")),
      builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          array = snapshot.data ?? [];
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(children: [
                    Container(
                        alignment: Alignment.centerLeft,
                        child:
                            const Text("Welcome to the Center for Writing!")),
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
                  GridView.count(
                    shrinkWrap: true,
                    crossAxisCount: MediaQuery.of(context).size.width > 800
                        ? 4
                        : MediaQuery.of(context).size.width > 600
                            ? 3
                            : 2,
                    children: generateWidgets(),
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
                      StorageService storage =
                          await StorageService.getInstance();

                      await storage.saveArray("writingHeader_local", array);
                      List<String> writingText =
                          await storage.loadArray("writingText_local");
                      writingText.add('New Item Text');
                      await storage.saveArray("writingText_local", writingText);
                      setState(() {});
                    },
                    child: const Text('Add New Item'),
                  ),
                  const SizedBox(height: 24.0),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
