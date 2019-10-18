import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:jobber/src/core/services/location_service.dart';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart';

class JobsProvider {
  JobsProvider() {
    _getInstance();
  }

  SharedPreferences _prefsInstance;

  final _client = Client();
  final _baseUrl = 'http://132.145.111.230:3000';

  Future<List<dynamic>> positionsFromLocation(BuildContext context) async {
    final location = Provider.of<UserLocation>(context);
    Response response;
    if (location != null) {
      final lat = Uri.encodeComponent(location.latitude.toString());
      final long = Uri.encodeComponent(location.longitude.toString());
      response = await _client.get(
        '$_baseUrl/positions/$lat/$long',
      );
    } else {
      response = await _client.get('$_baseUrl/positions');
    }
    return _handleResponse(response);
  }

  Future<List<dynamic>> savedPositions() async {
    if (_prefsInstance == null) await _getInstance();
    final savedPositions = _prefsInstance.getStringList('savedPositions') ?? [];
    final List<dynamic> positions = savedPositions.map((data) {
      try {
        return json.decode(data);
      } catch (e) {
        return null;
      }
    }).toList()
      ..removeWhere((position) => position == null);
    return positions;
  }

  Future<Map<String, dynamic>> positionFromId(String id) async {
    final saved = await savedPositions();
    final match = saved.firstWhere(
      (position) => position['id'] == id,
      orElse: () => null,
    );
    if (match != null) {
      return match;
    } else {
      final response = await _client.get(
        '$_baseUrl/positions/$id',
      );
      return _handleResponse(response, error: 'Failed to get position');
    }
  }

  dynamic _handleResponse(Response response, {String error}) {
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw error ?? 'Failed to get positions';
    }
  }

  Future<void> _getInstance() async {
    final prefs = await SharedPreferences.getInstance();
    _prefsInstance = prefs;
  }
}
