import 'dart:convert';

import 'package:gelato_flutter_challenge/models/picsum_image_data.dart';
import 'package:http/http.dart' as http;

const String picsumUrl = 'picsum.photos';
const int imagesPerRequest = 16;

class PicsumApi {
  static Uri constructUri({int page = 0, String path = ''}) {
    return Uri.https(
      picsumUrl,
      path,
      <String, dynamic>{
        'page': '$page',
        'limit': '$imagesPerRequest',
      },
    );
  }

  static Future<List<dynamic>> getPhotosList({int page = 0}) async {
    const String listPath = 'v2/list';

    final http.Response response =
        await http.get(constructUri(page: page, path: listPath));

    if (response.statusCode == 200) {
      final List<dynamic> images = json.decode(response.body) as List<dynamic>;

      return images
          .cast<Map<String, dynamic>>()
          .map((Map<String, dynamic> json) => PicsumImageData.fromJson(json))
          .toList();
    } else {
      // TODO(Alex): present messages relevant to the cause of the error
      throw Exception('An error has prevented images from loading.');
    }
  }
}
