import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:flutter/services.dart';
import 'notes_page.dart';

class SmartNotesPage extends StatefulWidget {
  const SmartNotesPage({super.key});

  @override
  _SmartNotesPageState createState() => _SmartNotesPageState();
}

class _SmartNotesPageState extends State<SmartNotesPage> {
  final TextEditingController _notesController = TextEditingController();
  final Gemini gemini = Gemini.instance;
  List<String> notes = [];
  bool isLoading = false;

  void _createNote() {
    String topic = _notesController.text;
    if (topic.isNotEmpty) {
      setState(() {
        isLoading = true;
      });
      String request =
          "Lütfen aşağıdaki konuda detaylı ve kapsamlı notlar oluştur: $topic. Notlar, konuya genel bir bakış, önemli alt başlıklar ve açıklamaları, anahtar noktalar, örnekler ve açıklayıcı detaylar içermelidir. Notların iyi yapılandırılmış ve bilgilendirici olmasına dikkat edin.";

      List<String> responseParts = [];

      gemini.streamGenerateContent(request).listen((event) {
        String response = event.content?.parts?.fold(
                "", (previous, current) => "$previous ${current.text}") ??
            "";
        responseParts.add(response);
      }).onDone(() {
        setState(() {
          notes.add(responseParts.join(" "));
          _notesController.clear();
          isLoading = false;
        });
      });
    }
  }

  void _navigateToNotesPage() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => NotesPage(notes: notes),
    ));
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Not kopyalandı')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Akıllı Not Alma"),
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
            icon: const Icon(Icons.notes),
            onPressed: _navigateToNotesPage,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _notesController,
              decoration: InputDecoration(
                labelText: "Not konusu girin",
                prefixIcon: const Icon(Icons.note_add),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: isLoading ? null : _createNote,
              child: isLoading
                  ? const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    )
                  : const Text("Not Oluştur"),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                    vertical: 12.0, horizontal: 24.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (isLoading) const CircularProgressIndicator(),
            if (!isLoading && notes.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: notes.length,
                  itemBuilder: (context, index) {
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: ListTile(
                        title: Text(
                          notes[index],
                          style: const TextStyle(fontSize: 16, height: 1.5),
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.copy),
                          onPressed: () => _copyToClipboard(notes[index]),
                        ),
                      ),
                    );
                  },
                ),
              ),
            if (!isLoading && notes.isEmpty)
              const Center(
                child: Text(
                  'Henüz not oluşturulmadı.',
                  style: TextStyle(fontSize: 16),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
