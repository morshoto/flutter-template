import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  bool _isNutAllergy = false;
  bool _isDairyAllergy = false;
  bool _isGlutenAllergy = false;
  bool _isVegetarian = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome to Dishcovery'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Tell us about your dietary preferences!',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 16),
            CheckboxListTile(
              title: const Text('Nut Allergy'),
              value: _isNutAllergy,
              onChanged: (val) {
                setState(() {
                  _isNutAllergy = val ?? false;
                });
              },
            ),
            CheckboxListTile(
              title: const Text('Dairy Allergy'),
              value: _isDairyAllergy,
              onChanged: (val) {
                setState(() {
                  _isDairyAllergy = val ?? false;
                });
              },
            ),
            CheckboxListTile(
              title: const Text('Gluten Allergy'),
              value: _isGlutenAllergy,
              onChanged: (val) {
                setState(() {
                  _isGlutenAllergy = val ?? false;
                });
              },
            ),
            CheckboxListTile(
              title: const Text('Vegetarian'),
              value: _isVegetarian,
              onChanged: (val) {
                setState(() {
                  _isVegetarian = val ?? false;
                });
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Save preferences to backend or local storage as needed
                // Then navigate to Home
                Navigator.pushReplacementNamed(context, '/home');
              },
              child: const Text('Get Started'),
            ),
          ],
        ),
      ),
    );
  }
}
