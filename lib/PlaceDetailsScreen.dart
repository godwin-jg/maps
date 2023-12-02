import 'package:flutter/material.dart';
import 'package:maps/PlacesApi.dart';
import 'package:maps/constants.dart';

class PlaceDetailsScreen extends StatefulWidget {
  final String placeId;
  final String name;

  PlaceDetailsScreen(this.placeId, this.name);

  @override
  _PlaceDetailsScreenState createState() => _PlaceDetailsScreenState();
}

class _PlaceDetailsScreenState extends State<PlaceDetailsScreen> {
  final placesApi = PlacesApi(google_api_key);
  List<String> placePhotos = [];

  @override
  void initState() {
    super.initState();
    fetchPlacePhotos();
  }

  Future<void> fetchPlacePhotos() async {
    try {
      final photos = await placesApi.getPlacePhotos(widget.placeId);
      setState(() {
        placePhotos = photos;
      });
    } catch (e) {
      print('Error fetching place photos: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name),
      ),
      body: placePhotos.isEmpty
          ? Center(
              // Loading indicator while data is being fetched
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: placePhotos.length,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 5,
                  margin: EdgeInsets.all(10),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.network(
                      placePhotos[index],
                      fit: BoxFit.cover, // Adjust the BoxFit as needed
                    ),
                  ),
                );
              },
            ),
    );
  }
}
