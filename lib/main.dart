import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tourist Places',
      home: TouristPlacesScreen(),
    );
  }
}

class TouristPlacesScreen extends StatelessWidget {
  final List<String> touristPlaces = [
    'Eiffel Tower, Paris',
    'Machu Picchu, Peru',
    'Great Wall of China, China',
    'Pyramids of Giza, Egypt',
    'Statue of Liberty, USA',
    'Taj Mahal, India',
    'Sydney Opera House, Australia',
    'Colosseum, Italy',
    'Santorini, Greece',
    'Banff National Park, Canada',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tourist Places'),
      ),
      body: ListView.builder(
        itemCount: touristPlaces.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(touristPlaces[index]),
            onTap: () {
              // You can add navigation or other actions when a place is tapped.
              // For simplicity, we'll just print the place name for now.
              print('Selected: ${touristPlaces[index]}');
            },
          );
        },
      ),
    );
  }
}
