import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../GetApiService/apiservices.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('trading12.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    print("Opening database at $path");
    return await openDatabase(path,
        version: 4, onCreate: _createDB, onUpgrade: _onUpgrade);
  }

  Future<void> _createDB(Database db, int version) async {
    try {
      print("Creating tables...");
      await db.execute('''
      CREATE TABLE IF NOT EXISTS watchlists (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL
      )
    ''');
      print("watchlists table created.");
      await db.execute('''
      CREATE TABLE IF NOT EXISTS watchlist_instruments (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        watchlist_id INTEGER,
        exchange_instrument_id TEXT NOT NULL,
        display_name TEXT NOT NULL,
        Series TEXT NOT NULL,
        exchangeSegment TEXT,
        orderIndex INTEGER,
        close TEXT,
        CompanyName TEXT,
        FOREIGN KEY (watchlist_id) REFERENCES watchlists (id) ON DELETE CASCADE
      )
    ''');
      await db.execute('''
    CREATE TABLE IF NOT EXISTS instruments (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  ExchangeSegment TEXT,
  ExchangeInstrumentID TEXT,
  InstrumentType TEXT,
  Name TEXT,
  DisplayName TEXT,
  Description TEXT,
  Series TEXT,
  NameWithSeries TEXT,
  InstrumentID TEXT,
  price_band_high TEXT,
  price_band_low TEXT,
  FreezeQty TEXT,
  TickSize TEXT,
  LotSize TEXT,
  CompanyName TEXT,
  DecimalDisplace TEXT,
  IsIndex TEXT,
  IsTradeable TEXT,
  Industry TEXT,
  UnderlyingInstrumentId TEXT,
  UnderlyingIndexName TEXT,
  ContractExpiration TEXT,
  RemainingExpiryDays TEXT,
  StrikePrice TEXT,
  OptionType TEXT
);
''');
      print("watchlist_instruments table created.");
    } catch (e) {
      print("Error creating tables: $e");
    }
  }

  Future<List<Map<String, dynamic>>> searchInDatabase(String query) async {
    final db = await database;

    // Initialize a list for dynamic whereArgs
    List<String> whereArgs = [];
    // Base where clause
    String whereClause = '''
    ExchangeSegment LIKE ? OR
    ExchangeInstrumentID LIKE ? OR
    InstrumentType LIKE ? OR
    Name LIKE ? OR
    DisplayName LIKE ? OR
    Description LIKE ? OR  
    Series LIKE ? OR
    NameWithSeries LIKE ? OR
   
    CompanyName LIKE ? OR
    UnderlyingIndexName LIKE ? OR
    ContractExpiration LIKE ? OR
    StrikePrice LIKE ?
  ''';

    // Check for specific terms in the query and adjust the where clause and whereArgs accordingly
    if (query.toUpperCase().contains('CE') ||
        query.toUpperCase().contains('PE')) {
      // For CE/PE, you might want to add specific logic here
      whereClause += ' OR OptionType LIKE ?';
      whereArgs.addAll(
          List.generate(12, (index) => '%$query%')); // For the base query
      whereArgs.add('%${query.toUpperCase()}%'); // For the CE/PE part
    } else if (DateTime.tryParse(query) != null) {
      // Handle date values (expiration date)
      DateTime expirationDate = DateTime.parse(query);
      whereClause += ' AND ContractExpiration = ?';
      whereArgs.addAll(
          List.generate(12, (index) => '%$query%')); // For the base query
      whereArgs.add(DateFormat('yyyy-MM-dd').format(expirationDate));
    } else {
      whereArgs.addAll(List.generate(12, (index) => '%$query%'));
    }

    final List<Map<String, dynamic>> results =
        await db.query('instruments', where: whereClause, whereArgs: whereArgs);

    return results;
  }

  Future<List<Map<String, dynamic>>> searchInDatabaseWith2Params(
      String part1, String query) async {
    final db = await database;

    // First filter based on part1
    String whereClausePart1 =
        "Name LIKE ? OR DisplayName LIKE ? OR StrikePrice LIKE ?";
    List<String> whereArgsPart1 = ['%$part1%', '%$part1%', '%$part1%'];

    // Perform the first query
    List<Map<String, dynamic>> firstResults = await db.query(
      'instruments',
      where: whereClausePart1,
      whereArgs: whereArgsPart1,
    );

    // If the first part is the only filter, return the results
    if (query.isEmpty || query == part1) {
      return firstResults;
    }

    // Prepare for the second filter based on the full query
    String whereClauseFullQuery = '''
    ExchangeSegment LIKE ? OR
    ExchangeInstrumentID LIKE ? OR
    InstrumentType LIKE ? OR
    Series LIKE ? OR
    NameWithSeries LIKE ? OR
    StrikePrice LIKE ? OR
    CompanyName LIKE ? OR
    UnderlyingIndexName LIKE ? OR
    ContractExpiration LIKE ? OR
    OptionType LIKE ? OR
    Description LIKE ?
  ''';
    List<String> whereArgsFullQuery = List.generate(11, (index) => '%$query%');

    // Filter the firstResults based on the full query
    List<Map<String, dynamic>> finalResults = firstResults.where((instrument) {
      // Convert the instrument map to a single string for easier searching
      String instrumentString = instrument.values.join(" ").toUpperCase();
      return instrumentString.contains(query.toUpperCase());
    }).toList();

    return finalResults;
  }

// Function to clear the SQLite database
  Future<void> clearDatabase() async {
    final db = await database;
    await db.delete('instruments');
    print("Database cleared.");
  }

  Future<void> storeInstrumentsInDatabase(List<dynamic> instruments) async {
    final db =
        await database; // Implement getDatabase to initialize the SQLite database

    for (var instrument in instruments) {
      await db.insert('instruments', {
        'ExchangeSegment': instrument['ExchangeSegment'].toString(),
        'ExchangeInstrumentID': instrument['ExchangeInstrumentID'].toString(),
        'InstrumentType': instrument['InstrumentType'].toString(),
        'Name': instrument['Name'],
        'DisplayName': instrument['DisplayName'],
        'Description': instrument['Description'],
        'Series': instrument['Series'],
        'NameWithSeries': instrument['NameWithSeries'],
        'InstrumentID': instrument['InstrumentID'].toString(),
        'price_band_high': instrument['PriceBand']['High'].toString(),
        'price_band_low': instrument['PriceBand']['Low'].toString(),
        'FreezeQty': instrument['FreezeQty'].toString(),
        'TickSize': instrument['TickSize'].toString(),
        'LotSize': instrument['LotSize'].toString(),
        'CompanyName': instrument['CompanyName'],
        'DecimalDisplace': instrument['DecimalDisplace'].toString(),
        'IsIndex': instrument['IsIndex'].toString(),
        'IsTradeable': instrument['IsTradeable'].toString(),
        'Industry': instrument['Industry'].toString(),
        'UnderlyingInstrumentId':
            instrument['UnderlyingInstrumentId'].toString(),
        'UnderlyingIndexName': instrument['UnderlyingIndexName'],
        'ContractExpiration': instrument['ContractExpiration'],
        'RemainingExpiryDays': instrument['RemainingExpiryDays'].toString(),
        'StrikePrice': instrument['StrikePrice'].toString(),
        'OptionType': instrument['OptionType'].toString(),
      });
    }
  }

// Future<List<Map<String, dynamic>>> searchInDatabase(String query) async {
//   final db = await database;

//   // Initialize a list for dynamic whereArgs
//   List<String> whereArgs = [];
//   // Base where clause
//   String whereClause = '''
//     exchange_segment LIKE ? OR
//     exchange_instrument_id LIKE ? OR
//     instrument_type LIKE ? OR
//     name LIKE ? OR
//     display_name LIKE ? OR
//     description LIKE ? OR
//     series LIKE ? OR
//     name_with_series LIKE ? OR
//     instrument_id LIKE ? OR
//     company_name LIKE ? OR
//     underlying_index_name LIKE ? OR
//     contract_expiration LIKE ? OR
//     strike_price LIKE ?
//   ''';

//   // Check for specific terms in the query and adjust the where clause and whereArgs accordingly
//   if (query.toUpperCase().contains('CE') || query.toUpperCase().contains('PE')) {
//     // For CE/PE, you might want to add specific logic here
//     whereClause += ' OR option_type LIKE ?';
//     whereArgs.addAll(List.generate(13, (index) => '%$query%')); // For the base query
//     whereArgs.add('%${query.toUpperCase()}%'); // For the CE/PE part
//   } else if (RegExp(r'\b[A-Z]{3}\b').hasMatch(query.toUpperCase())) {
//     // This is a simple regex to check for three-letter month abbreviations
//     // Adjust this logic based on your specific needs
//     whereArgs.addAll(List.generate(13, (index) => '%$query%'));
//   } else {
//     whereArgs.addAll(List.generate(13, (index) => '%$query%'));
//   }

//   final List<Map<String, dynamic>> results = await db.query(
//     'instruments',
//     where: whereClause,
//     whereArgs: whereArgs
//   );

//   print("Results: $results");
//   return results;
// }

  Future<DateTime?> getLatestWatchlistUpdateTimestamp(int watchlistId) async {
    final db = await database;
    final result = await db.query(
      'watchlist_instruments',
      columns: ['MAX(last_modified)'],
      where: 'watchlist_id = ?',
      whereArgs: [watchlistId],
    );
    if (result.isNotEmpty && result.first['MAX(last_modified)'] != null) {
      return DateTime.parse(result.first['MAX(last_modified)'].toString());
    }
    return null;
  }

  Future<int> deleteInstrumentByExchangeInstrumentId(
      int watchlistId, String exchangeInstrumentId) async {
    final db = await instance.database;
    return await db.delete(
      'watchlist_instruments',
      where: 'watchlist_id = ? AND exchange_instrument_id = ?',
      whereArgs: [watchlistId, exchangeInstrumentId],
    );
  }

  Future<int> addWatchlist(String name) async {
    final db = await instance.database;
    // Check if there are already 10 watchlists
    List<Map> existing = await db.query('watchlists');
    if (existing.length >= 10) {
      throw Exception('Maximum of 10 watchlists reached.');
    }
    return await db.insert(
      'watchlists',
      {'name': name},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> addInstrumentToWatchlist(
      int watchlistId,
      String exchangeInstrumentId,
      String displayName,
      String Series,
      String exchangeSegment,
      int orderIndex,
      String CompanyName,
      String close) async {
    final db = await instance.database;
    final json = {
      'watchlist_id': watchlistId,
      'exchange_instrument_id': exchangeInstrumentId,
      'display_name': displayName,
      'Series': Series,
      'exchangeSegment': exchangeSegment,
      'orderIndex': orderIndex,
      'close': close,
      'CompanyName': CompanyName,
    };
    return await db.insert(
      'watchlist_instruments',
      json,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> fetchWatchlists() async {
    final db = await instance.database;
    return await db.query('watchlists');
  }

  Future<List<Map<String, dynamic>>> fetchInstrumentsByWatchlist(
      int watchlistId) async {
    final db = await instance.database;
    return await db.query(
      'watchlist_instruments',
      where: 'watchlist_id = ?',
      whereArgs: [watchlistId],
      orderBy: 'orderIndex ASC',
    );
  }

  Future<void> updateOrderIndex(int id, int newIndex) async {
    final db = await database;
    await db.update(
      'watchlist_instruments',
      {'orderIndex': newIndex},
      where: 'id = ?',
      whereArgs: [id],
    );
    print("Order index updated for id $id to $newIndex");
  }

  Future<void> updateAllCloseValues() async {
    final db = await database;
    final instruments = await db.query('watchlist_instruments');

    for (var instrument in instruments) {
      try {
        String closeValue = await ApiService().GetBhavCopy(
          instrument['exchange_instrument_id'] as String,
          instrument['exchangeSegment'] as String,
        );
        await db.update('watchlist_instruments', {'close': closeValue},
            where: 'id = ?', whereArgs: [instrument['id']]);
      } catch (e) {
        print(
            'Error updating close value for instrument ID ${instrument['id']}: $e');
      }
    }
  }

  Future<void> updateOrderIndexForWatchlist(
      int watchlistId, List<int> newOrder) async {
    final db = await database;
    List<Map<String, dynamic>> instruments =
        await fetchInstrumentsByWatchlist(watchlistId);
    for (int i = 0; i < instruments.length; i++) {
      await updateOrderIndex(instruments[i]['id'], newOrder[i]);
    }
  }

  Future<int> deleteInstrumentFromWatchlist(int id) async {
    final db = await instance.database;
    return await db
        .delete('watchlist_instruments', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteWatchlist(int id) async {
    final db = await instance.database;
    await db.delete('watchlist_instruments',
        where: 'watchlist_id = ?', whereArgs: [id]);
    return await db.delete('watchlists', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    try {
      if (oldVersion < 6) {
        // Assume this change is in version 2
        await db.execute('''
          CREATE TABLE watchlist_instruments (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            watchlist_id INTEGER,
            exchange_instrument_id INTEGER,
            display_name TEXT,
            Series TEXT,
            exchangeSegment INTEGER,
            orderIndex INTEGER,
            close TEXT,
      CompanyName TEXT,
            FOREIGN KEY(watchlist_id) REFERENCES watchlists(id),
          )
        ''');
      }
    } catch (e) {
      print("Error upgrading database: $e");
    }
  }

  Future<void> close() async {
    final db = await instance.database;
    db.close();
  }
}
