

import 'package:flutter/material.dart';

class SafetyTipsPage extends StatelessWidget {
  final List<SafetyTip> _safetyTips = [
    SafetyTip(
      title: 'Research your destination',
      description: 'Ensure you know about the place you are visiting, including local customs, laws, and potential dangers.',
      icon: Icons.search,
    ),
    SafetyTip(
      title: 'Keep your valuables safe',
      description: 'Use money belts or hidden pockets to keep your money and important documents secure.',
      icon: Icons.lock,
    ),
    SafetyTip(
      title: 'Stay connected',
      description: 'Keep your phone charged and share your itinerary with friends or family.',
      icon: Icons.phone_android,
    ),
    SafetyTip(
      title: 'Stay aware of your surroundings',
      description: 'Always be aware of what\'s happening around you to avoid potential dangers.',
      icon: Icons.visibility,
    ),
    SafetyTip(
      title: 'Use reputable transportation',
      description: 'Use licensed taxis or rideshare services and avoid unmarked vehicles.',
      icon: Icons.directions_car,
    ),
    SafetyTip(
      title: 'Know emergency contacts',
      description: 'Have a list of local emergency contacts, including the nearest embassy or consulate.',
      icon: Icons.contact_phone,
    ),
    SafetyTip(
      title: 'Protect your health',
      description: 'Stay hydrated, eat well, and get enough rest. Carry any necessary medications.',
      icon: Icons.health_and_safety,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Safety Tips'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Search Tips',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                // Implement search functionality here
              },
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _safetyTips.length,
                itemBuilder: (context, index) {
                  final tip = _safetyTips[index];
                  return Card(
                    child: ListTile(
                      leading: Icon(tip.icon, size: 40),
                      title: Text(
                        tip.title,
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(tip.description),
                      trailing: Icon(Icons.keyboard_arrow_down),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text(tip.title),
                              content: Text(tip.description),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('Close'),
                                ),
                              ],
                            );
                          },
                        );
                      },
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

class SafetyTip {
  final String title;
  final String description;
  final IconData icon;

  SafetyTip({required this.title, required this.description, required this.icon});
}

void main() => runApp(MaterialApp(
  home: SafetyTipsPage(),
));
