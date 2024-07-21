
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_svg/flutter_svg.dart';

class PopularPlacesPage extends StatefulWidget {
  @override
  _PopularPlacesPageState createState() => _PopularPlacesPageState();
}

class _PopularPlacesPageState extends State<PopularPlacesPage> {
  List<dynamic> places = [];
  bool isLoading = false;
  bool hasMore = true;
  int offset = 0;
  final int limit = 10;
  final int populationThreshold = 1000000; // Only fetch cities with a population over 1 million

  @override
  void initState() {
    super.initState();
    fetchPopularPlaces();
  }

  Future<void> fetchPopularPlaces() async {
    if (isLoading || !hasMore) return;

    setState(() {
      isLoading = true;
    });

    final response = await http.get(
      Uri.parse('https://wft-geo-db.p.rapidapi.com/v1/geo/cities?limit=$limit&offset=$offset&minPopulation=$populationThreshold'),
      headers: {
    'x-rapidapi-key': "API",
    'x-rapidapi-host': "API"
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> fetchedPlaces = json.decode(response.body)['data'];
      setState(() {
        places.addAll(fetchedPlaces);
        hasMore = fetchedPlaces.length == limit;
        offset += limit;
        isLoading = false;
      });
    } else {
      print('Failed to load places: ${response.statusCode}');
      print(response.body);
      throw Exception('Failed to load places');
    }
  }

  Future<Map<String, dynamic>> fetchCityDetails(String cityName) async {
    final response = await http.get(
      Uri.parse('https://en.wikipedia.org/api/rest_v1/page/summary/$cityName')
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      print('Failed to load city details: ${response.statusCode}');
      print(response.body);
      throw Exception('Failed to load city details');
    }
  }

  String getFlagUrl(String countryCode) {
    return 'https://raw.githubusercontent.com/hjnilsson/country-flags/master/svg/${countryCode.toLowerCase()}.svg';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Popular Places'),
      ),
      body: places.isEmpty && isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: places.length + 1,
                    itemBuilder: (context, index) {
                      if (index == places.length) {
                        if (hasMore) {
                          fetchPopularPlaces();
                          return Center(child: CircularProgressIndicator());
                        } else {
                          return Center(child: Text('No more places to load'));
                        }
                      }

                      final place = places[index];
                      final cityName = place['city'];
                      final countryCode = place['countryCode'];
                      final population = place['population'];
                      final country = place['country'];

                      return ListTile(
                        leading: SvgPicture.network(
                          getFlagUrl(countryCode),
                          height: 30,
                          width: 50,
                          placeholderBuilder: (context) => CircularProgressIndicator(),
                        ),
                        title: Text(cityName),
                        subtitle: Text('Country: $country\nPopulation: $population'),
                        onTap: () async {
                          final cityDetails = await fetchCityDetails(cityName);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CityDetailPage(
                                place: place,
                                cityDetails: cityDetails,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}

class CityDetailPage extends StatelessWidget {
  final dynamic place;
  final Map<String, dynamic> cityDetails;

  CityDetailPage({required this.place, required this.cityDetails});

  @override
  Widget build(BuildContext context) {
    final cityName = place['city'];
    final description = cityDetails['extract'] ?? 'No description available';
    final thumbnail = cityDetails['thumbnail'] != null ? cityDetails['thumbnail']['source'] : null;

    return Scaffold(
      appBar: AppBar(
        title: Text(cityName),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (thumbnail != null) 
              Image.network(thumbnail),
            SizedBox(height: 16.0),
            Text(
              description,
              style: TextStyle(fontSize: 16.0),
            ),
          ],
        ),
      ),
    );
  }
}

