import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import './indonesia_model.dart';
import './world_model.dart';

class CoronaProvider with ChangeNotifier {
  IndonesiaModel summary;
  WorldModel world;
  String updated;

  Future<void> getData() async {
    final url = 'https://kawalcovid19.harippe.id/api/summary';
    final response = await http.get(url);
    final result = json.decode(response.body) as Map<String, dynamic>;

    summary = IndonesiaModel(
      confirmed: result['confirmed']['value'],
      recovered: result['recovered']['value'],
      deaths: result['deaths']['value'],
      activeCare: result['activeCare']['value'],
    );

    updated = result['metadata']['lastUpdatedAt'];

    final worldPositive = 'https://api.kawalcorona.com/positif/';
    final responsePositive = await http.get(worldPositive);
    final resultPositive = json.decode(responsePositive.body);

    final worldRecovered = 'https://api.kawalcorona.com/sembuh/';
    final responseRecovered = await http.get(worldRecovered);
    final resultRecovered = json.decode(responseRecovered.body);

    final worldDeaths = 'https://api.kawalcorona.com/meninggal/';
    final responseDeaths = await http.get(worldDeaths);
    final resultDeaths = json.decode(responseDeaths.body);

    world = WorldModel(
      confirmed: resultPositive['value'],
      deaths: resultRecovered['value'],
      recovered: resultDeaths['value'],
    );
    notifyListeners();
  }
}