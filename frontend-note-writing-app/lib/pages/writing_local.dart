import 'package:flutter/material.dart';
import 'package:myapp/pages/home_local.dart';

import 'package:myapp/services/storage.dart';

class WritingApp extends StatelessWidget {
  final int writingIndex;
  const WritingApp({super.key, required this.writingIndex});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.grey,
        hintColor: Colors.amber,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Writing Note'),
          backgroundColor: Colors.yellow,
        ),
        body: WritingPage(
          writingIndex: writingIndex,
        ),
      ),
    );
  }
}

class WritingPage extends StatefulWidget {
  final int writingIndex;
  const WritingPage({super.key, required this.writingIndex});

  @override
  WritingPageState createState() => WritingPageState();
}

class WritingPageState extends State<WritingPage> {
  late StorageService storage;

  final TextEditingController titleController = TextEditingController();
  final TextEditingController textController = TextEditingController();
  List<String> writingHeaders = [];
  List<String> writingText = [];

  @override
  void initState() {
    super.initState();
    initStorage();
    loadWriting();
  }

  void initStorage() async {
    storage = await StorageService.getInstance();
  }

  void loadWriting() async {
    writingText = await storage.loadArray("writingText_local");
    writingHeaders = await storage.loadArray("writingHeader_local");
    if (widget.writingIndex < writingHeaders.length) {
      titleController.text = writingHeaders[widget.writingIndex];
      textController.text = writingText[widget.writingIndex];
    }
  }

  void saveWriting() async {
    setState(() {
      writingHeaders[widget.writingIndex] = titleController.text;
      writingText[widget.writingIndex] = textController.text;
    });
    await storage.saveArray("writingHeader_local", writingHeaders);
    await storage.saveArray("writingText_local", writingText);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Writing'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text("Do you want to save changes?"),
                  actions: [
                    TextButton(
                      child: const Text('Cancel'),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    TextButton(
                      child: const Text('No'),
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pop(context);
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => HomeAppLocal(),
                          ),
                        );
                      },
                    ),
                    TextButton(
                      child: const Text('Save'),
                      onPressed: () async {
                        saveWriting();
                        Navigator.pop(context);
                        Navigator.pop(context);
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => HomeAppLocal(),
                          ),
                        );
                      },
                    ),
                  ],
                );
              },
            );
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () async {
              setState(() {
                writingHeaders[widget.writingIndex] = titleController.text;
                writingText[widget.writingIndex] = textController.text;
              });
              await storage.saveArray("writingHeader_local", writingHeaders);
              await storage.saveArray("writingText_local", writingText);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            Expanded(
              child: TextField(
                controller: titleController,
                style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87),
                decoration: InputDecoration(
                  labelText: 'Title',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: TextField(
                controller: textController,
                style: const TextStyle(fontSize: 18, color: Colors.black87),
                decoration: InputDecoration(
                  labelText: 'Text',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                ),
                maxLines: null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
