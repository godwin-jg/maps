import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:maps/login.dart';
// import 'package:maps/path.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Google Places API Demo',
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
    );
  }
}

class PlacesScreen extends StatefulWidget {
  @override
  _PlacesScreenState createState() => _PlacesScreenState();
}

String apiKey = 'AIzaSyBumOL17qUZfsuph0ohCl0RMaBEqhRC8Iw';

class _PlacesScreenState extends State<PlacesScreen> {
  // https://maps.googleapis.com/maps/api/place/textsearch/json?query=dubai+point+of+interest&language=en&radius=2000&key

  String source = '';
  String destination = '';
  List<String> places = [];
  List<String> places2 = [];
  List<String> intersection = [];
  TextEditingController sourceController = TextEditingController();
  TextEditingController destinationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final String apiUrl =
          'https://maps.googleapis.com/maps/api/place/textsearch/json?query=$source+point+of+interest&language=en&radius=50000&key=$apiKey';

      final String apiUrl2 =
          'https://maps.googleapis.com/maps/api/place/textsearch/json?query=$destination+point+of+interest&language=en&radius=50000&key=$apiKey';
      final response = await http.get(Uri.parse(apiUrl));
      // print(response.body + " hello");
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> results = data['results'];
        print(data);

        setState(() {
          places.clear();
          places = results.map((place) => place['name'].toString()).toList();
        });
      }
      final response2 = await http.get(Uri.parse(apiUrl2));
      if (response2.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response2.body);
        final List<dynamic> results = data['results'];
        print(data);

        setState(() {
          places2.clear();
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
      intersection.clear();
      intersection = places.toSet().union(places2.toSet()).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Places of Interests',
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/canada.jpg', // Replace with your image file
            fit: BoxFit.cover,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Card(
                  elevation: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        TextField(
                          controller: sourceController,
                          decoration:
                              InputDecoration(labelText: 'Enter Source'),
                        ),
                        SizedBox(height: 16),
                        TextField(
                          controller: destinationController,
                          decoration:
                              InputDecoration(labelText: 'Enter Destination'),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      source = sourceController.text;
                      destination = destinationController.text;
                    });
                    fetchData();
                  },
                  child: Text('Find Path'),
                ),
                SizedBox(height: 16),
                Expanded(
                  child: Card(
                    elevation: 5,
                    child: ListView.builder(
                      itemCount: intersection.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(intersection[index]),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
