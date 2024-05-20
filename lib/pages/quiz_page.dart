import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:flutter/services.dart';

class QuizPage extends StatefulWidget {
  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  final TextEditingController _quizController = TextEditingController();
  final Gemini gemini = Gemini.instance;
  List<String> quizzes = [];
  bool isLoading = false;

  void _createQuiz() {
    String topic = _quizController.text;
    if (topic.isNotEmpty) {
      setState(() {
        isLoading = true;
      });

      String question =
          "Lütfen '$topic' konusunda ayrıntılı ve doğru bir quiz oluştur.";

      List<String> responseParts = [];

      gemini.streamGenerateContent(question).listen((event) {
        String response = event.content?.parts?.fold(
                "", (previous, current) => "$previous ${current.text}") ??
            "";
        responseParts.add(response);
      }).onDone(() {
        setState(() {
          quizzes.add(responseParts.join(" "));
          _quizController.clear();
          isLoading = false;
        });
      });
    }
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Metin kopyalandı')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Quiz Oluştur"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _quizController,
              decoration: InputDecoration(
                labelText: "Quiz konusu girin",
                prefixIcon: Icon(Icons.question_answer),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: isLoading ? null : _createQuiz,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: isLoading
                  ? CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    )
                  : const Text("Quiz Oluştur"),
            ),
            SizedBox(height: 16),
            Expanded(
              child: quizzes.isEmpty
                  ? Center(
                      child: Text(
                        "Henüz quiz oluşturulmadı.",
                        style: TextStyle(fontSize: 16),
                      ),
                    )
                  : ListView.builder(
                      itemCount: quizzes.length,
                      itemBuilder: (context, index) {
                        return Card(
                          margin: EdgeInsets.symmetric(vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            title: Text(
                              quizzes[index],
                              style: TextStyle(fontSize: 16),
                            ),
                            trailing: IconButton(
                              icon: Icon(Icons.copy),
                              onPressed: () => _copyToClipboard(quizzes[index]),
                            ),
                          ),
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
