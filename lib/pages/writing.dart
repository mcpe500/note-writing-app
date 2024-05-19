import 'package:flutter/material.dart';
import 'package:myapp/pages/home.dart';
import 'package:myapp/utils/storage.dart';

class WritingApp extends StatelessWidget {
  final int writingIndex;
  final String username;
  const WritingApp(
      {super.key, required this.writingIndex, required this.username});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Writing')),
        body: WritingPage(
          writingIndex: writingIndex,
          username: username,
        ),
      ),
    );
  }
}

class WritingPage extends StatefulWidget {
  final int writingIndex;
  final String username;
  const WritingPage(
      {super.key, required this.writingIndex, required this.username});
  @override
  WritingPageState createState() => WritingPageState();
}

class WritingPageState extends State<WritingPage> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController textController = TextEditingController();
  List<String> writingHeaders = [];
  List<String> writingText = [];

  @override
  void initState() {
    super.initState();
    loadWriting();
  }

  void loadWriting() async {
    writingText = await loadArray("writingText_${widget.username}");
    writingHeaders = await loadArray("writingHeader_${widget.username}");
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
    await saveArray("writingHeader_${widget.username}", writingHeaders);
    await saveArray("writingText_${widget.username}", writingText);
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
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) =>
                                  HomeApp(username: widget.username)),
                        );
                      },
                    ),
                    TextButton(
                      child: const Text('Save'),
                      onPressed: () async {
                        saveWriting();
                        Navigator.pop(context);
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) =>
                                  HomeApp(username: widget.username)),
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
              await saveArray(
                  "writingHeader_${widget.username}", writingHeaders);
              await saveArray("writingText_${widget.username}", writingText);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: textController,
              decoration: const InputDecoration(labelText: 'Text'),
              maxLines: null,
            ),
          ],
        ),
      ),
    );
  }
}
