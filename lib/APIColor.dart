import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
class APIColor {
  static Future<String> getColorNameFromAPI(Color color) async {
    final String hexColor = color.value.toRadixString(16).padLeft(8, '0').substring(2).toUpperCase();
    final String apiUrl = 'https://www.thecolorapi.com/id?hex=$hexColor';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final Map<String, dynamic> colorData = json.decode(response.body);
        return colorData['name']['value'];
      } else {
        return 'Color Desconocido';
      }
    } catch (e) {
      return 'Error de API';
    }
  }
}