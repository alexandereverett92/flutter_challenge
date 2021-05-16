import 'dart:convert';

import 'package:gelato_flutter_challenge/models/picsum_api_error.dart';
import 'package:gelato_flutter_challenge/models/picsum_image_data.dart';
import 'package:http/http.dart' as http;

const String picsumUrl = 'picsum.photos';

/// Specifies the number of images retrieved by the api for each "page"
const int imagesPerRequest = 20;

class PicsumApi {
  /// Formats the [Uri] object for use within api calls
  /// [page] will specify the collection of images retrieved and apply the
  /// parameter to the url.
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

  /// Access to the picsum api for listing images.
  /// [page] will specify the collection of images retrieved.
  /// https://picsum.photos/v2/list
  static Future<List<PicsumImageData>> getPhotosList({int page = 0}) async {
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
      throw const PicsumApiError('Could not load the images.');
    }
  }
}
