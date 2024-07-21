
import 'package:flutter/material.dart';

class TravelChecklistPage extends StatefulWidget {
  @override
  _TravelChecklistPageState createState() => _TravelChecklistPageState();
}

class _TravelChecklistPageState extends State<TravelChecklistPage> {
  Map<String, bool> checklistItems = {
    'Passport': false,
    'Flight Tickets': false,
    'Hotel Reservations': false,
    'Travel Insurance': false,
    'Visa': false,
    'Pack Clothes': false,
    'Toiletries': false,
    'Medicine': false,
    'Travel Guide': false,
    'Phone Charger': false,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Travel Checklist'),
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () {
              final allChecked = checklistItems.values.every((item) => item);
              if (allChecked) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('All items are checked!'))
                );
              }
            },
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: checklistItems.keys.map((String key) {
          return CheckboxListTile(
            title: Text(key),
            value: checklistItems[key],
            onChanged: (bool? value) {
              setState(() {
                checklistItems[key] = value!;
              });
            },
          );
        }).toList(),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          _displayAddItemDialog(context);
        },
      ),
    );
  }

  Future<void> _displayAddItemDialog(BuildContext context) async {
    TextEditingController _textFieldController = TextEditingController();
    bool addError = false;

    return showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Add new item'),
              content: TextField(
                controller: _textFieldController,
                decoration: InputDecoration(
                  errorText: addError ? 'Item already exists' : null,
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: Text('Add'),
                  onPressed: () {
                    final newItem = _textFieldController.text.trim();
                    if (newItem.isNotEmpty && !checklistItems.containsKey(newItem)) {
                      setState(() {
                        checklistItems[newItem] = false;
                        addError = false;
                      });
                      Navigator.of(context).pop();
                    } else {
                      setState(() {
                        addError = true;
                      });
                    }
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
}

void main() => runApp(MaterialApp(
  home: TravelChecklistPage(),
));
