import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:maps/path.dart';

void main() {
  runApp(OrderTrackingPage());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Google Places API Demo',
      home: PlacesScreen(),
    );
  }
}

class PlacesScreen extends StatefulWidget {
  @override
  _PlacesScreenState createState() => _PlacesScreenState();
}

String apiKey = 'AIzaSyBumOL17qUZfsuph0ohCl0RMaBEqhRC8Iw';
String source = 'salem';
String destination = 'chennai';

class _PlacesScreenState extends State<PlacesScreen> {
  final String apiUrl =
      'https://maps.googleapis.com/maps/api/place/textsearch/json?query=$source+point+of+interest&language=en&radius=50000&key=$apiKey';

  final String apiUrl2 =
      'https://maps.googleapis.com/maps/api/place/textsearch/json?query=$destination+point+of+interest&language=en&radius=50000&key=$apiKey';
  // https://maps.googleapis.com/maps/api/place/textsearch/json?query=dubai+point+of+interest&language=en&radius=2000&key

  List<String> places = [];
  List<String> places2 = [];
  List<String> intersection = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));
      // print(response.body + " hello");
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> results = data['results'];
        print(data);

        setState(() {
          places = results.map((place) => place['name'].toString()).toList();
        });
      }
      final response2 = await http.get(Uri.parse(apiUrl2));
      if (response2.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> results = data['results'];
        print(data);

        setState(() {
          places2 = results.map((place) => place['name'].toString()).toList();
        });
        findIntersection();
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void findIntersection() {
    setState(() {
      intersection = places.toSet().intersection(places2.toSet()).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Places of Interest in New York City'),
      ),
      body: ListView.builder(
        itemCount: intersection.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(intersection[index]),
          );
        },
      ),
    );
  }
}
