import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:travely/city_info_page.dart';

class CityDetailPage extends StatefulWidget {
  final dynamic place;

  CityDetailPage({required this.place, required Map<String, dynamic> cityDetails});

  @override
  _CityDetailPageState createState() => _CityDetailPageState();
}

class _CityDetailPageState extends State<CityDetailPage> {
  List<dynamic> cities = [];

  @override
  void initState() {
    super.initState();
    fetchCities();
  }

  Future<void> fetchCities() async {
    final response = await http.get(
      Uri.parse('https://wft-geo-db.p.rapidapi.com/v1/geo/countries/${widget.place['code']}/regions?limit=10'),
      headers: {
    'x-rapidapi-key': "API",
    'x-rapidapi-host': "API"
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        cities = json.decode(response.body)['data'];
      });
    } else {
      print('Failed to load cities: ${response.statusCode}');
      print(response.body);
      throw Exception('Failed to load cities');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.place['name']} Cities'),
      ),
      body: cities.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: cities.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(cities[index]['name']),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CityInfoPage(city: cities[index]),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}

