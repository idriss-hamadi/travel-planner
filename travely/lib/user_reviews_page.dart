

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class UserReviewsPage extends StatefulWidget {
  @override
  _UserReviewsPageState createState() => _UserReviewsPageState();
}

class _UserReviewsPageState extends State<UserReviewsPage> {
  List<ReviewEntry> _reviews = [];

  @override
  void initState() {
    super.initState();
    _loadReviews();
  }

  Future<void> _loadReviews() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? reviewsString = prefs.getString('reviews');
    print('Loaded reviews string: $reviewsString');
    if (reviewsString != null) {
      try {
        List<dynamic> reviewsJson = jsonDecode(reviewsString);
        setState(() {
          _reviews = reviewsJson.map((json) => ReviewEntry.fromJson(json)).toList();
          print('Loaded reviews: $_reviews');
        });
      } catch (e) {
        print('Error parsing JSON: $e');
      }
    }
  }

  Future<void> _saveReviews() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<Map<String, dynamic>> reviewsJson = _reviews.map((review) => review.toJson()).toList();
    prefs.setString('reviews', jsonEncode(reviewsJson));
    print('Saved reviews: ${jsonEncode(reviewsJson)}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Reviews'),
      ),
      body: _reviews.isEmpty
          ? Center(child: Text('No reviews yet. Add your first review!'))
          : ListView.builder(
              itemCount: _reviews.length,
              itemBuilder: (context, index) {
                final review = _reviews[index];
                return Card(
                  child: ListTile(
                    title: Text(review.title),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(review.date),
                        SizedBox(height: 8),
                        Text(review.description),
                      ],
                    ),
                    isThreeLine: true,
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _displayReviewBottomSheet(context),
      ),
    );
  }

  void _displayReviewBottomSheet(BuildContext context) {
    TextEditingController titleController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();
    bool addError = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: Container(
                padding: EdgeInsets.all(16.0),
                height: MediaQuery.of(context).size.height * 0.6,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'New Review',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16),
                    TextField(
                      controller: titleController,
                      decoration: InputDecoration(
                        labelText: 'Title',
                        errorText: addError && titleController.text.isEmpty
                            ? 'Title cannot be empty'
                            : null,
                      ),
                    ),
                    SizedBox(height: 16),
                    Expanded(
                      child: TextField(
                        controller: descriptionController,
                        decoration: InputDecoration(
                          labelText: 'Description',
                          alignLabelWithHint: true,
                          errorText:
                              addError && descriptionController.text.isEmpty
                                  ? 'Description cannot be empty'
                                  : null,
                        ),
                        maxLines: null,
                        expands: true,
                      ),
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        TextButton(
                          child: Text('Cancel'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        ElevatedButton(
                          child: Text('Add'),
                          onPressed: () {
                            final title = titleController.text.trim();
                            final description =
                                descriptionController.text.trim();
                            if (title.isNotEmpty && description.isNotEmpty) {
                              setState(() {
                                _reviews.add(ReviewEntry(
                                  title: title,
                                  date: DateTime.now()
                                      .toString()
                                      .substring(0, 10),
                                  description: description,
                                ));
                                _saveReviews(); // Save reviews when a new one is added
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
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class ReviewEntry {
  final String title;
  final String date;
  final String description;

  ReviewEntry({required this.title, required this.date, required this.description});

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'date': date,
      'description': description,
    };
  }

  factory ReviewEntry.fromJson(Map<String, dynamic> json) {
    return ReviewEntry(
      title: json['title'],
      date: json['date'],
      description: json['description'],
    );
  }

  @override
  String toString() {
    return 'ReviewEntry{title: $title, date: $date, description: $description}';
  }
}

void main() {
  runApp(
    MaterialApp(
      home: UserReviewsPage(),
    ),
  );
}

