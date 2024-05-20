import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:flutter/services.dart';

class SmartStudyPlanPage extends StatefulWidget {
  @override
  _SmartStudyPlanPageState createState() => _SmartStudyPlanPageState();
}

class _SmartStudyPlanPageState extends State<SmartStudyPlanPage> {
  final TextEditingController _studyPlanController = TextEditingController();
  final Gemini gemini = Gemini.instance;
  List<String> studyPlans = [];
  bool isLoading = false;

  void _createStudyPlan() {
    String topic = _studyPlanController.text;
    if (topic.isNotEmpty) {
      setState(() {
        isLoading = true;
      });
      String request =
          "Lütfen aşağıdaki konuda detaylı ve kapsamlı bir çalışma planı oluştur: $topic. Çalışma planı, konuya genel bir bakış, önemli alt başlıklar ve açıklamaları, önerilen çalışma materyalleri ve kaynakları, her alt başlık için önerilen çalışma süreleri ve aralıkları, özet ve tekrar stratejileri, ve değerlendirme yöntemlerini içermelidir. Planın iyi yapılandırılmış ve bilgilendirici olmasına dikkat edin.";

      List<String> responseParts = [];

      gemini.streamGenerateContent(request).listen((event) {
        String response = event.content?.parts?.fold(
                "", (previous, current) => "$previous ${current.text}") ??
            "";
        responseParts.add(response);
      }).onDone(() {
        setState(() {
          studyPlans.add(responseParts.join(" "));
          _studyPlanController.clear();
          isLoading = false;
        });
      });
    }
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Çalışma planı kopyalandı')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Akıllı Çalışma Planlayıcı"),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _studyPlanController,
              decoration: InputDecoration(
                labelText: "Çalışma konusunu girin",
                prefixIcon: const Icon(Icons.schedule),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:
                      const BorderSide(color: Colors.deepPurple, width: 2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: isLoading ? null : _createStudyPlan,
              child: isLoading
                  ? const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    )
                  : const Text("Plan Oluştur"),
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
            if (!isLoading && studyPlans.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: studyPlans.length,
                  itemBuilder: (context, index) {
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: ListTile(
                        title: Text(
                          studyPlans[index],
                          style: const TextStyle(fontSize: 16),
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.copy),
                          onPressed: () => _copyToClipboard(studyPlans[index]),
                        ),
                      ),
                    );
                  },
                ),
              ),
            if (!isLoading && studyPlans.isEmpty)
              const Center(
                child: Text(
                  'Henüz çalışma planı oluşturulmadı.',
                  style: TextStyle(fontSize: 16),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
