import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:meme_app/models/meme_models.dart';

class MemeServices {
  static Future<Meme> fetchMems(BuildContext context) async {
    final url = Uri.parse('https://api.imgflip.com/get_memes');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return Meme.fromJson(data);
      } else {
        throw Exception('Failed to load memes: HTTP ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching memes: $e');
    }
  }
}
