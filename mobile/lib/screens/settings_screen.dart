import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _nutAllergy = false;
  bool _dairyAllergy = false;
  bool _glutenAllergy = false;
  bool _vegetarian = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings & Preferences'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const Text(
            'Update Dietary Preferences:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          CheckboxListTile(
            title: const Text('Nut Allergy'),
            value: _nutAllergy,
            onChanged: (val) {
              setState(() {
                _nutAllergy = val ?? false;
              });
            },
          ),
          CheckboxListTile(
            title: const Text('Dairy Allergy'),
            value: _dairyAllergy,
            onChanged: (val) {
              setState(() {
                _dairyAllergy = val ?? false;
              });
            },
          ),
          CheckboxListTile(
            title: const Text('Gluten Allergy'),
            value: _glutenAllergy,
            onChanged: (val) {
              setState(() {
                _glutenAllergy = val ?? false;
              });
            },
          ),
          CheckboxListTile(
            title: const Text('Vegetarian'),
            value: _vegetarian,
            onChanged: (val) {
              setState(() {
                _vegetarian = val ?? false;
              });
            },
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // Submit updated preferences to backend or local storage
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Preferences updated!'),
                ),
              );
            },
            child: const Text('Save Preferences'),
          ),
        ],
      ),
    );
  }
}
