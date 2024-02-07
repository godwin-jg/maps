import 'dart:convert';
import 'package:http/http.dart' as http;

class PlacesApi {
  final String apiKey;

  PlacesApi(this.apiKey);

  Future<List<String>> getPlacePhotos(String placeId) async {
    final response = await http.get(Uri.parse(
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&fields=photos&key=$apiKey'));
    print(response.body);
    print("this is response");
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<String> photoUrls = [];

      if (data['result'] != null && data['result']['photos'] != null) {
        for (dynamic photo in data['result']['photos']) {
          final photoReference = photo['photo_reference'];
          final photoUrl =
              'https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=$photoReference&key=$apiKey';
          photoUrls.add(photoUrl);
        }
      }

      return photoUrls;
    } else {
      throw Exception('Failed to load place photos');
    }
  }
}
