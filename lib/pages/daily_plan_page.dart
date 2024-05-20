import 'package:flutter/material.dart';

class DailyPlanPage extends StatefulWidget {
  @override
  _DailyPlanPageState createState() => _DailyPlanPageState();
}

class _DailyPlanPageState extends State<DailyPlanPage> {
  final TextEditingController _goalController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  List<String> plan = [];

  void _createPlan() {
    String goal = _goalController.text;
    String time = _timeController.text;

    if (goal.isNotEmpty && time.isNotEmpty) {
      setState(() {
        plan.add("Hedef: $goal - Süre: $time saat");
      });
    }
  }

  void _setReminder(String plan) {
    // Burada hatırlatıcı ayarlamak için kod ekleyebilirsiniz
    // Örneğin, bir alarm veya bildirim planlayabilirsiniz.
    print("Hatırlatıcı ayarlandı: $plan");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Günlük Çalışma Planı"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _goalController,
              decoration: InputDecoration(
                labelText: "Hedefinizi girin",
                prefixIcon: Icon(Icons.flag),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _timeController,
              decoration: InputDecoration(
                labelText: "Süreyi girin (saat)",
                prefixIcon: Icon(Icons.timer),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _createPlan,
              child: const Text("Plan Oluştur"),
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: plan.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(plan[index]),
                    trailing: IconButton(
                      icon: Icon(Icons.alarm),
                      onPressed: () => _setReminder(plan[index]),
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
