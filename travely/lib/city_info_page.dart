import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CityInfoPage extends StatefulWidget {
  final dynamic city;

  CityInfoPage({required this.city});

  @override
  _CityInfoPageState createState() => _CityInfoPageState();
}

class _CityInfoPageState extends State<CityInfoPage> {
  dynamic cityInfo;

  @override
  void initState() {
    super.initState();
    fetchCityInfo();
  }

  Future<void> fetchCityInfo() async {
    final response = await http.get(
      Uri.parse('https://wft-geo-db.p.rapidapi.com/v1/geo/cities/${widget.city['id']}'),
      headers: {
    'x-rapidapi-key': "API",
    'x-rapidapi-host': "API"
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        cityInfo = json.decode(response.body)['data'];
      });
    } else {
      print('Failed to load city info: ${response.statusCode}');
      print(response.body);
      throw Exception('Failed to load city info');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.city['name']),
      ),
      body: cityInfo == null
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('City: ${cityInfo['name']}', style: TextStyle(fontSize: 24)),
                  Text('Population: ${cityInfo['population']}', style: TextStyle(fontSize: 18)),
                  Text('Region: ${cityInfo['region']}', style: TextStyle(fontSize: 18)),
                  // Add more details as needed
                ],
              ),
            ),
    );
  }
}
