import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gemini_chat_app_tutorial/pages/daily_plan_page.dart';
import 'package:gemini_chat_app_tutorial/pages/notes_page.dart';
import 'package:gemini_chat_app_tutorial/pages/summary_page.dart';
import 'package:gemini_chat_app_tutorial/pages/quiz_page.dart';
import 'package:gemini_chat_app_tutorial/pages/pomodoro_page.dart';
import 'package:gemini_chat_app_tutorial/pages/photo_question_page.dart';
import 'package:gemini_chat_app_tutorial/pages/smart_study_plan_page.dart';
import 'package:gemini_chat_app_tutorial/pages/smart_notes_page.dart';
import 'package:gemini_chat_app_tutorial/pages/login_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> notes = [];
  String? emailPrefix;

  @override
  void initState() {
    super.initState();
    _loadEmailPrefix();
  }

  Future<void> _loadEmailPrefix() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = prefs.getString('email') ?? '';
    setState(() {
      emailPrefix = email.split('@').first;
    });
  }

  Future<void> _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("StiAI"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            if (emailPrefix != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Text(
                  'Merhaba, $emailPrefix',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
                children: [
                  _buildMenuCard(context, "Çözüm Asistanı",
                      Icons.question_answer, PhotoQuestionPage()),
                  _buildMenuCard(
                      context, "Quiz Oluştur", Icons.quiz, QuizPage()),
                  _buildMenuCard(context, "Çalışma Planı Oluştur",
                      Icons.schedule, SmartStudyPlanPage()),
                  _buildMenuCard(context, "Ders Notu Oluştur", Icons.note_add,
                      SmartNotesPage()),
                  _buildMenuCard(context, "Özet Oluştur", Icons.auto_awesome,
                      SummaryPage()),
                  _buildMenuCard(
                      context, "Pomodoro Tekniği", Icons.timer, PomodoroPage()),
                  _buildMenuCard(context, "Çalışma Planım",
                      Icons.calendar_today, DailyPlanPage()),
                  _buildMenuCard(context, "Ders Notlarım", Icons.note,
                      NotesPage(notes: notes)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuCard(
      BuildContext context, String title, IconData icon, Widget page) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => page),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 36, color: Theme.of(context).primaryColor),
                const SizedBox(height: 8),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
