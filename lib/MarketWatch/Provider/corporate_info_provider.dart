import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tradingapp/MarketWatch/model/corporate_info_model.dart';
import 'package:http/http.dart' as http;

class CorporateInfoProvider with ChangeNotifier {
  // CorporateInfo? _corporateInfo;
  bool _isLoading = false;
  // Nullable CorporateInfo
//CorporateInfo? get corporateInfo => _corporateInfo;  // Getter returns nullable CorporateInfo

  bool get isLoading => _isLoading;

  Future<void> fetchCorporateInfo(String symbol) async {
    final url =
        'http://180.211.116.158:8080/mobile/api/v1/stock-analysis/top-corp-info-equity?symbol=$symbol';
    try {
      _isLoading = true;
      notifyListeners();

      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // _corporateInfo = CorporateInfo.fromJson(data['data']);
        // print(_corporateInfo);
      } else {
        throw Exception('Failed to load corporate info');
      }
    } catch (error) {
      throw error;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refreshCorporateInfo(String symbol) async {
    await fetchCorporateInfo(symbol);
  }
}

class CorportateProvider with ChangeNotifier {
  IRCTCData? irctcData;

  Future<void> fetchIRCTCData() async {
    final url =
        'http://180.211.116.158:8080/mobile/api/v1/stock-analysis/top-corp-info-equity?symbol=IRCTC'; // Replace with your actual API endpoint
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        irctcData = IRCTCData.fromJson(data['data']);
        notifyListeners();
      } else {
        throw Exception('Failed to load data');
      }
    } catch (error) {
      throw error;
    }
  }
}
