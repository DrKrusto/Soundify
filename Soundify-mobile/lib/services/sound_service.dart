import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:soundify/models/api_response.dart';
import 'package:http/http.dart' as http;
import 'package:soundify/models/paged_sounds.dart';
import '../main.dart';
import '../models/paging_options.dart';

import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart' as path;

class SoundService {
  static Future<PagedSounds?> fetchSoundsFromPaged(
      List<PagedSounds> pagedSounds,
      String search,
      bool searchForFavorites,
      PagingOptions pagingOptions) async {
    PagedSounds? pagedSound = pagedSounds
        .where((pagedSound) => pagedSound.currentPage == pagingOptions.page)
        .firstOrNull;

    if (pagedSound != null) {
      return pagedSound;
    }

    final response = searchForFavorites
        ? await getFavorites(search, pagingOptions)
        : await searchSounds(name: search, paging: pagingOptions);

    if (response.apiResponseType == ApiResponseType.success) {
      pagedSound = response.value;
      if (pagedSound == null) {
        throw Exception(response.details);
      }
      pagedSounds.add(pagedSound);
      return pagedSound;
    }

    return null;
  }

  static Future<PagedSounds?> fetchFavoritesFromPaged(
      List<PagedSounds> pagedSounds,
      String userId,
      PagingOptions pagingOptions) async {
    PagedSounds? pagedSound = pagedSounds
        .where((pagedSound) => pagedSound.currentPage == pagingOptions.page)
        .firstOrNull;

    if (pagedSound != null) {
      return pagedSound;
    }

    final response = await getFavorites(userId, pagingOptions);

    if (response.apiResponseType == ApiResponseType.success) {
      pagedSound = response.value;
      if (pagedSound == null) {
        throw Exception(response.details);
      }
      pagedSounds.add(pagedSound);
      return pagedSound;
    }

    return null;
  }

  static Future<ApiResponse<PagedSounds>> searchSounds(
      {String? name, PagingOptions? paging}) async {
    final url = Uri.parse('${MyApp.serverUrl}/Api/Sound/SearchSounds');

    final queryParameters = <String, dynamic>{
      'SearchByName': name ?? '',
      'UsePaging': paging != null ? 'true' : 'false',
      'Size': paging != null ? paging.size.toString() : '0',
      'Page': paging != null ? paging.page.toString() : '0'
    };

    final uri = url.replace(queryParameters: queryParameters);

    try {
      final response = await http.get(uri);
      final data = jsonDecode(response.body);
      final details = data['details'] as String;
      if (response.statusCode == 200) {
        return ApiResponse.success(
            PagedSounds.fromJson(data['value']), details);
      }
      return ApiResponse.badRequest(details);
    } catch (e) {
      throw Exception('Failed to get sounds: $e');
    }
  }

  static Future<XFile?> searchForSoundOnDevice() async {
    final FilePickerResult? result = await FilePicker.platform.pickFiles();
    final String? resultPath = result?.files.single.path;
    if (resultPath != null) {
      return XFile(resultPath);
    }
    return null;
  }

  static Future<ApiResponse> uploadSound(String userId, XFile sound) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('${MyApp.serverUrl}/Api/Sound/UploadSound'),
    );

    String mediaType = '';
    switch (path.extension(sound.name)) {
      case '.wav':
        mediaType = 'vnd.wav';
        break;
      case '.mp3':
        mediaType = 'mpeg';
        break;
    }

    request.fields['UploaderId'] = userId;
    request.fields['Name'] = sound.name;
    request.files.add(await http.MultipartFile.fromPath('Sound', sound.path,
        contentType: MediaType('audio', mediaType)));

    var response = await request.send();

    if (response.statusCode == 200) {
      return ApiResponse.success('', 'Sound uploaded successfully');
    }

    return ApiResponse.badRequest('Couldn\'t upload this sound');
  }

  static Future<ApiResponse<PagedSounds>> getFavorites(
      String userId, PagingOptions? paging) async {
    final url = Uri.parse('${MyApp.serverUrl}/Api/Sound/GetFavorites');

    final queryParameters = <String, dynamic>{
      'UserId': userId,
      'UsePaging': paging != null ? 'true' : 'false',
      'Size': paging != null ? paging.size.toString() : '0',
      'Page': paging != null ? paging.page.toString() : '0'
    };

    final uri = url.replace(queryParameters: queryParameters);

    try {
      final response = await http.get(uri);
      final data = jsonDecode(response.body);
      final details = data['details'] as String;
      if (response.statusCode == 200) {
        final sounds = PagedSounds.fromJson(data['value']);
        return ApiResponse.success(sounds, details);
      } else if (response.statusCode == 404) {
        return ApiResponse.notFound(details);
      } else {
        return ApiResponse.badRequest(details);
      }
    } catch (e) {
      throw Exception('Failed to get favorites: $e');
    }
  }

  static Future<ApiResponse<String>> addToFavorites(
      String userId, String soundId) async {
    final url = Uri.parse('${MyApp.serverUrl}/Api/Sound/AddToFavorites');
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({'userId': userId, 'soundId': soundId});

    final response = await http.post(url, headers: headers, body: body);
    final data = jsonDecode(response.body);
    final details = data['details'] as String;

    if (response.statusCode == 200) {
      return ApiResponse.success('added', details);
    } else if (response.statusCode == 401) {
      return ApiResponse.unauthorized(details);
    }
    return ApiResponse.badRequest(details);
  }

  static Future<ApiResponse<String>> removeFromFavorites(
      String userId, String soundId) async {
    final url = Uri.parse('${MyApp.serverUrl}/Api/Sound/DeleteFromFavorites');
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({'userId': userId, 'soundId': soundId});

    final response = await http.delete(url, headers: headers, body: body);
    final data = jsonDecode(response.body);
    final details = data['details'];

    if (response.statusCode == 200) {
      return ApiResponse.success('removed', details);
    } else if (response.statusCode == 401) {
      return ApiResponse.unauthorized(details);
    }
    return ApiResponse.badRequest(details);
  }
}
