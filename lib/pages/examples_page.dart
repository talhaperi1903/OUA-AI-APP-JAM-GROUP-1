import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

class ExamplesPage extends StatefulWidget {
  @override
  _ExamplesPageState createState() => _ExamplesPageState();
}

class _ExamplesPageState extends State<ExamplesPage> {
  final TextEditingController _examplesController = TextEditingController();
  final Gemini gemini = Gemini.instance;

  List<String> examples = [];

  void _giveExamples() {
    String topic = _examplesController.text;
    if (topic.isNotEmpty) {
      String question = "Örnekler Ver: $topic";
      gemini.streamGenerateContent(question).listen((event) {
        String response = event.content?.parts?.fold(
                "", (previous, current) => "$previous ${current.text}") ??
            "";
        setState(() {
          examples.add(response);
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Örnekler Ver"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _examplesController,
              decoration: InputDecoration(
                labelText: "Bir konu girin",
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _giveExamples,
              child: const Text("Örnekler Ver"),
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: examples.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(examples[index]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
