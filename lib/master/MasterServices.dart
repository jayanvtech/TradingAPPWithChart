import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tradingapp/Utils/const.dart/app_config.dart';

class DatabaseHelperMaster {
  static final DatabaseHelperMaster _instance = DatabaseHelperMaster._internal();
  factory DatabaseHelperMaster() => _instance;

  static Database? _database;

  DatabaseHelperMaster._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'instruments1.db');
    return await openDatabase(path, version: 1, onCreate: _createDatabase);
  }

  Future<void> _createDatabase(Database db, int version) async {
    await db.execute('''
      CREATE TABLE instruments (
        id INTEGER PRIMARY KEY,
        exchangeSegment TEXT,
        exchangeInstrumentID TEXT,
        instrumentType TEXT,
        name TEXT,
        description TEXT,
        series TEXT,
        nameWithSeries TEXT,
        instrumentID TEXT,
        priceBandHigh TEXT,
        priceBandLow TEXT,
        freezeQty TEXT,
        tickSize TEXT,
        lotSize TEXT,
        multiplier TEXT,
        displayName TEXT,
        isin TEXT,
        priceNumerator TEXT,
        priceDenominator TEXT
      )
    ''');
  }

  Future<void> insertOrUpdateInstruments(List<Map<String, dynamic>> instruments) async {
    final db = await database;
    for (var instrument in instruments) {
      await db.insert(
        'instruments',
        instrument,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  Future<List<Map<String, dynamic>>> getInstruments() async {
    final db = await database;
    return await db.query('instruments');
  }

  Future<List<Map<String, dynamic>>> getInstrumentsByISIN(String isin) async {
    final db = await database;
    return await db.rawQuery(
      'SELECT * FROM instruments WHERE TRIM(LOWER(isin)) = ?',
      [isin.toLowerCase().trim()],
    );
  }

  Future<List<Map<String, dynamic>>> getInstrumentsByInstrumentID(String ExchangeNSEInstrumentId) async {
    final db = await database;
    return await db.query(
      'instruments',
      where: 'exchangeInstrumentID = ?',
      whereArgs: [ExchangeNSEInstrumentId],
    );
  }

  Future<Map<String, dynamic>?> getInstrumentsBySymbol(String symbol) async {
    final db = await database;
    final seriesList = [
      "EQ",
      "N5",
      "SG",
      "BE",
      "N1",
      "SM",
      "GS",
      "N0",
      "NL",
      "NV",
      "MF",
      "NA",
      "NP",
      "NT",
      "AR",
      "SPOT",
      "N2",
      "TB",
      "N6",
      "N9",
      "NQ",
      "ZJ",
      "ST",
      "IV",
      "NR",
      "ZI",
      "BZ",
      "NO",
      "NC",
      "RR",
      "ZT",
      "NH",
      "ZM",
      "NE",
      "NK",
      "N3",
      "NF",
      "NS",
      "NU",
      "NZ",
      "AU",
      "ND",
      "ZF",
      "T0",
      "NN",
      "N7",
      "Z6",
      "GB",
      "N4",
      "ZR",
      "X1",
      "BA",
      "YT",
      "NG",
      "NW",
      "YW",
      "E1",
      "AZ",
      "N8",
      "BC",
      "AB",
      "NI",
      "ZV",
      "NB",
      "Z1",
      "IT",
      "Y8",
      "Y2",
      "AD",
      "ZX",
      "ZY",
      "W1",
      "ZW",
      "YK",
      "Y4",
      "NM",
      "D1",
      "ZD",
      "Z9",
      "YO",
      "ZN",
      "AX",
      "BV",
      "YX",
      "NY",
      "YS",
      "ZG",
      "YR",
      "ZE",
      "YJ",
      "AA",
      "NX",
      "Z5",
      "AV",
      "Y6",
      "Z3",
      "YQ",
      "ZK",
      "NJ",
      "Z8",
      "YN",
      "ZH",
      "BS",
      "ZZ",
      "Y7",
      "AS",
      "AW",
      "Z7",
      "YH",
      "Z0",
      "AT",
      "ZS",
      "ZO",
      "YL",
      "BX",
      "BF",
      "BI",
      "BR",
      "YD",
      "YI",
      "Y9",
      "ZC",
      "AN",
      "Y3",
      "BW",
      "YC",
      "YA",
      "YB",
      "Y1",
      "ZP",
      "BU",
      "ZL",
      "YZ",
      "P1",
      "M1",
      "AM",
      "AG",
      "ZA",
      "AC",
      "AK",
      "ZQ",
      "YV",
      "AJ",
      "YU",
      "AP",
      "ZB",
      "AI",
      "AL",
      "YM",
      "Z2",
      "YP",
      "AO",
      "Z4",
      "AH",
      "AY",
      "Y5",
      "Y0",
      "BH",
      "AQ",
      "YY",
      "BD",
      "ZU",
      "YG"
    ];

    final result = await db.query(
      'instruments',
      columns: ['exchangeInstrumentID', 'exchangeSegment', 'name'],
      where: 'name = ? AND exchangeSegment = ? AND series IN (${List.filled(seriesList.length, '?').join(', ')})',
      whereArgs: [symbol, 'NSECM', ...seriesList],
      orderBy: "CASE series " +
          seriesList.asMap().entries.map((entry) => "WHEN '${entry.value}' THEN ${entry.key + 1}").join(' ') +
          " ELSE ${seriesList.length + 1} END",
      limit: 1,
    );

    if (result.isNotEmpty) {
      print(result.first);
      return result.first;
    } else {
      return null;
    }
  }
}

class ApiServiceMaster {
 var baseUrl= AppConfig.baseUrl;
  Future<void> fetchInstruments() async {
    final response = await http.post(
      Uri.parse(
          '$baseUrl/apimarketdata/instruments/master'),
      headers: {"Content-Type": "application/json"},
      body: json.encode({
        "exchangeSegmentList": ["NSECM", "BSECM"]
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['type'] == 'success') {
        // Parse the result and insert/update into SQLite
        List<Map<String, dynamic>> instruments = parseInstruments(data['result']);
        await DatabaseHelperMaster().insertOrUpdateInstruments(instruments);
        print('Instruments fetched and stored successfully SQLITE');
      }
    } else {
      throw Exception('Failed to load instruments');
    }
  }

  List<Map<String, dynamic>> parseInstruments(String result) {
    List<Map<String, dynamic>> instruments = [];
    List<String> lines = result.split('\n');

    for (var line in lines) {
      if (line.isNotEmpty) {
        List<String> values = line.split('|');
        instruments.add({
          'exchangeSegment': values[0].toString(),
          'exchangeInstrumentID': values[1].toString(),
          'instrumentType': values[2].toString(),
          'name': values[3].toString(),
          'description': values[4].toString(),
          'series': values[5].toString(),
          'nameWithSeries': values[6].toString(),
          'instrumentID': values[7].toString(),
          'priceBandHigh': values[8].toString(),
          'priceBandLow': values[9].toString(),
          'freezeQty': values[10].toString(),
          'tickSize': values[11].toString(),
          'lotSize': values[12].toString(),
          'multiplier': values[13].toString(),
          'displayName': values[14].toString(),
          'isin': values[15].toString(),
          'priceNumerator': values[16].toString(),
          'priceDenominator': values[17].toString(),
        });
      }
    }

    return instruments;
  }

  Future<void> checkAndFetchInstruments() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    DateTime? lastFetchTime = DateTime.tryParse(prefs.getString('lastFetchTime') ?? '');

    DateTime now = DateTime.now();
    bool shouldFetch = false;

    if (lastFetchTime == null || now.difference(lastFetchTime).inDays > 0) {
      // First time in the day or app installed
      print('First time in the day or app installed');
      shouldFetch = true;
    } else if (now.hour == 10 && now.minute == 0) {
      print('7 AM');
      // Check if it's 7 AM
      shouldFetch = true;
    }

    if (shouldFetch) {
      print('Fetching instruments...');
      await fetchInstruments();
      await prefs.setString('lastFetchTime', now.toIso8601String());
    }
  }
}
