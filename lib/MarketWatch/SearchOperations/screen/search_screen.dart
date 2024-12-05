import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tradingapp/ApiServices/apiservices.dart';
import 'package:tradingapp/MarketWatch/Screens/wishlist_instrument_details_screen.dart';
import 'package:tradingapp/sqlite_database/dbhelper.dart';

class SearchScreen extends StatefulWidget {
  final VoidCallback? onReturn;

  SearchScreen({this.onReturn});
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final ApiService _apiService = ApiService();
  List<dynamic> _searchResults = [];
  String _selectedFilter = 'ALL';
  Timer? _debounce;
  bool _isLoading = false;

  void _onSearch(String value) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(Duration(milliseconds: 500), () {
      if (value.isNotEmpty && value.length >= 2) {
        _fetchSearchResults(value);
      } else {
        setState(() {
          _searchResults = [];
        });
      }
    });
  }

  Future<void> _fetchSearchResults(String query) async {
    setState(() {
      _isLoading = true;
    });
    try {

      
      var results = await _apiService.searchInstruments(query.toUpperCase());
      setState(() {
        _searchResults = results;
        print(results);
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error: $error'),
      ));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        title: Text('Search Instruments'),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(0.0),
              child: TextFormField(
                autofocus: true,
                onChanged: _onSearch,
                decoration: InputDecoration(
                  labelText: 'Search',
                  suffixIcon: Icon(Icons.search),
                ),
              ),
            ),
            _buildFilterRow(),
            _isLoading ? CircularProgressIndicator() : _buildResultsList(),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterRow() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _filterButton('ALL'),
            _filterButton('Cash', filterCode: 'EQ'),
            _filterButton('Future', filterCode: 'FUTIDX'),
            _filterButton('Future Stock', filterCode: 'FUTSTK'),
            _filterButton('Option Index', filterCode: 'OPTIDX'),
            _filterButton('Option Stock', filterCode: 'OPTSTK'),
          ],
        ),
      ),
    );
  }

  Widget _filterButton(String title, {String? filterCode}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        border: Border.all(
          color: _selectedFilter == (filterCode ?? 'ALL')
              ? Colors.blue
              : Colors.transparent,
        ),
        borderRadius: BorderRadius.circular(5),
      ),
      child: InkWell(
        splashColor: Colors.white,
        overlayColor: MaterialStateProperty.all(Colors.transparent),
        onTap: () {
          setState(() {
            _selectedFilter = filterCode ?? 'ALL';
          });
        },
        child: Text(
          title,
          style: TextStyle(
            color: _selectedFilter == (filterCode ?? 'ALL')
                ? Colors.blue
                : Colors.black,
          ),
        ),
      ),
    );
  }

  Widget _buildResultsList() {
    if (_searchResults.isEmpty) {
      return Expanded(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Center(
              child: SvgPicture.asset(
                'assets/error_illustrations/search_error.svg',
                height: 150,
                width: 150,
                color: Colors.blue,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Ups!... no results found',
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.blue,
                  fontWeight: FontWeight.normal),
            ),
            Text(
              'Try Another Search',
              style: TextStyle(
                  fontSize: 12,
                  color: Colors.blue,
                  fontWeight: FontWeight.normal),
            ),
            SizedBox(height: 50)
          ],
        ),
      );
    }
    return Expanded(
      child: ListView.builder(
        itemCount: _searchResults.length,
        itemBuilder: (context, index) {
          var item = _searchResults[index];
          if (_selectedFilter != 'ALL' && item['Series'] != _selectedFilter) {
            return Container();
          }
          return FutureBuilder<Widget>(
            future: _buildListItem(item),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                print(snapshot.data);
                return snapshot.data ?? Container();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          );
        },
      ),
    );
  }

  Future<Widget> _buildListItem(Map<String, dynamic> item) async {
    // var close = await ApiService().GetBhavCopy(

    //   item['exchange_instrument_id'].toString(),
    //   item['exchange_segment'].toString()
    // );

    return GestureDetector(
      
      onTap: () async {
    
        ApiService().MarketInstrumentSubscribe(
            item['ExchangeSegment'].toString(),
            item['ExchangeInstrumentID'].toString());
        var close = await ApiService().GetBhavCopy(
            item['ExchangeInstrumentID'].toString(),
            item['ExchangeSegment'].toString());
            
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ViewMoreInstrumentDetailScreen(
              exchangeInstrumentId: item['ExchangeInstrumentID'].toString(),
              exchangeSegment: item['ExchangeSegment'].toString(),
              lastTradedPrice: close.toString(),
              close: close.toString(),
              displayName: item['Name'],
            ),
          ),
        );
      },
      child: ListTile(
        leading: CircleAvatar(
          radius: 20,
          child: ClipOval(
            child: SvgPicture.network(
              "https://ekyc.arhamshare.com/img//trading_app_logos//${item['Name']}.svg",
              fit: BoxFit.cover,
              height: 100,
            ),
          ),
          backgroundColor: Colors.blue[200],
        ),
        // ),

        title: GestureDetector(
          onTap: () async {
            var close = await ApiService().GetBhavCopy(
                item['ExchangeInstrumentID'].toString(),
                item['ExchangeSegment'].toString());
            ApiService().MarketInstrumentSubscribe(
                item['ExchangeSegment'].toString(),
                item['ExchangeInstrumentID'].toString());
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ViewMoreInstrumentDetailScreen(
                  exchangeInstrumentId: item['ExchangeInstrumentID'].toString(),
                  exchangeSegment: item['ExchangeSegment'].toString(),
                  lastTradedPrice: close.toString(),
                  close: close.toString(),
                  displayName: item['Name'],
                ),
              ),
            );
          },
          child: Text(item['Name'] ?? 'No name',style: TextStyle(),),
        ),
        subtitle: Text(item['CompanyName'] ?? 'No company name',style: TextStyle(fontSize: 13,color: Colors.black54),),
        trailing: IconButton(
            icon: Icon(Icons.add),
            onPressed: () async {
              var close = await ApiService().GetBhavCopy(
                  item['ExchangeInstrumentID'].toString(),
                  item['ExchangeSegment'].toString());
              _addInstrumentToWatchlist(
                item['ExchangeInstrumentID'].toString(),
                item['ExchangeSegment'].toString() == "2"
                    ? item['DisplayName']
                    : item['Name'],
                item['Series'],
                item['ExchangeSegment'].toString(),
                item['CompanyName'].toString(),
                close.toString(),
              );
            }),
      ),
    );
  }

  Color _getColorForSeries(String? series) {
    switch (series) {
      case "FUTSTK":
        return Colors.red;
      case "OPTIDX":
        return Colors.green;
      case "EQ":
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  void _addInstrumentToWatchlist(
    String exchangeInstrumentId,
    String displayName,
    String series,
    String exchangeSegment,
    String close,
    String CompanyName,
  ) async {
    final watchlists = await DatabaseHelper.instance.fetchWatchlists();
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return CupertinoActionSheet(
          title: Text(
            "Choose a watchlist to add $displayName",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          actions: <Widget>[
            ...watchlists.map((watchlist) {
              return CupertinoActionSheetAction(
                child: Text(watchlist['name']),
                onPressed: () async {
                  await DatabaseHelper.instance.addInstrumentToWatchlist(
                    watchlist['id'],
                    exchangeInstrumentId,
                    displayName,
                    series,
                    exchangeSegment,
                    watchlists.indexOf(watchlist),
                    close,
                    CompanyName,
                  );
                  await DatabaseHelper.instance.fetchWatchlists();
                  Navigator.pop(context, true);
                },
              );
            }).toList(),
            if (watchlists.length < 10)
              CupertinoActionSheetAction(
                child: Text('Create new watchlist'),
                onPressed: () => _createNewWatchlist(
                  context,
                  exchangeInstrumentId,
                  displayName,
                  series,
                  exchangeSegment,
                  close,
                  CompanyName,
                ),
              ),
          ],
          cancelButton: CupertinoActionSheetAction(
            child: Text('Cancel'),
            onPressed: () {
              Navigator.pop(context, true);
            },
          ),
        );
      },
    );
  }

  Future<void> _createNewWatchlist(
      BuildContext context,
      String exchangeInstrumentId,
      String displayName,
      String series,
      String exchangeSegment,
      String close,
      String CompanyName) async {
    TextEditingController _nameController = TextEditingController();
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('New Watchlist'),
          content: TextField(
            controller: _nameController,
            decoration: InputDecoration(hintText: 'Watchlist name'),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text('Create'),
              onPressed: () async {
                if (_nameController.text.isNotEmpty) {
                  int newWatchlistId = await DatabaseHelper.instance
                      .addWatchlist(_nameController.text);
                  await DatabaseHelper.instance.addInstrumentToWatchlist(
                    newWatchlistId,
                    exchangeInstrumentId,
                    displayName,
                    series,
                    exchangeSegment,
                    0,
                    close,
                    CompanyName,
                  );
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }
}
