import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class QuestionFlowScreen extends StatefulWidget {
  final String restaurantName;

  const QuestionFlowScreen({Key? key, required this.restaurantName})
      : super(key: key);

  @override
  _QuestionFlowScreenState createState() => _QuestionFlowScreenState();
}

class _QuestionFlowScreenState extends State<QuestionFlowScreen> {
  int _spiceLevel = 0; // 0 = no spice, 1 = mild, 2 = hot, etc.
  bool _wantsMeat = false;
  bool _wantsSeafood = false;
  bool _wantsSweet = false;

  void _submitAnswers() {
    // Normally, you'd pass these to your backend or LLM endpoint
    // Then navigate to a "RecommendedDishesScreen" or show a pop-up

    // Example: Navigator.pushReplacement(...)
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Submitting your preferences...'),
      ),
    );
    // Implement your API call here
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Preferences @ ${widget.restaurantName}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text('How spicy do you want your meal?'),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => setState(() => _spiceLevel = 0),
                  child: const Text('No Spice'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        _spiceLevel == 0 ? Colors.blue : Colors.grey,
                  ),
                ),
                ElevatedButton(
                  onPressed: () => setState(() => _spiceLevel = 1),
                  child: const Text('Mild'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        _spiceLevel == 1 ? Colors.blue : Colors.grey,
                  ),
                ),
                ElevatedButton(
                  onPressed: () => setState(() => _spiceLevel = 2),
                  child: const Text('Hot'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        _spiceLevel == 2 ? Colors.blue : Colors.grey,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            CheckboxListTile(
              title: const Text('Include Meat'),
              value: _wantsMeat,
              onChanged: (val) {
                setState(() {
                  _wantsMeat = val ?? false;
                });
              },
            ),
            CheckboxListTile(
              title: const Text('Include Seafood'),
              value: _wantsSeafood,
              onChanged: (val) {
                setState(() {
                  _wantsSeafood = val ?? false;
                });
              },
            ),
            CheckboxListTile(
              title: const Text('Prefer Sweet'),
              value: _wantsSweet,
              onChanged: (val) {
                setState(() {
                  _wantsSweet = val ?? false;
                });
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitAnswers,
              child: const Text('Get Recommendations'),
            ),
          ],
        ),
      ),
    );
  }
}
