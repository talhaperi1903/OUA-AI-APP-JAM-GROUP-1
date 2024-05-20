import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

class ConceptPage extends StatefulWidget {
  @override
  _ConceptPageState createState() => _ConceptPageState();
}

class _ConceptPageState extends State<ConceptPage> {
  final TextEditingController _conceptController = TextEditingController();
  final Gemini gemini = Gemini.instance;

  List<String> explanations = [];

  void _explainConcept() {
    String concept = _conceptController.text;
    if (concept.isNotEmpty) {
      String question = "Kavramı Açıkla: $concept";
      gemini.streamGenerateContent(question).listen((event) {
        String response = event.content?.parts?.fold(
                "", (previous, current) => "$previous ${current.text}") ??
            "";
        setState(() {
          explanations.add(response);
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Kavramı Açıkla"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _conceptController,
              decoration: InputDecoration(
                labelText: "Bir kavram adı girin",
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _explainConcept,
              child: const Text("Kavramı Açıkla"),
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: explanations.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(explanations[index]),
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
