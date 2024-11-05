class TopGainersNLosers {
  final String id;
  final String symbol;
  final String series;
  final String openPrice;
  final String highPrice;
  final String lowPrice;
  final String ltp;
  final String prevPrice;
  final String netPrice;
  final String tradeQuantity;
  final String turnover;
  final String marketType;
  final String caExDt;
  final String caPurpose;
  final String perChange;
  final String sector;
  final String filter;
  final String createdAt;
  final String updatedAt;

  TopGainersNLosers({
    required this.id,
    required this.symbol,
    required this.series,
    required this.openPrice,
    required this.highPrice,
    required this.lowPrice,
    required this.ltp,
    required this.prevPrice,
    required this.netPrice,
    required this.tradeQuantity,
    required this.turnover,
    required this.marketType,
    required this.caExDt,
    required this.caPurpose,
    required this.perChange,
    required this.sector,
    required this.filter,
    required this.createdAt,
    required this.updatedAt,
  });

  factory TopGainersNLosers.fromJson(Map<String, dynamic> json) {
    return TopGainersNLosers(
      id: json['id'].toString(),
      symbol: json['symbol'].toString(),
      series: json['series'].toString(),
      openPrice: json['open_price'].toString(),
      highPrice: json['high_price'].toString(),
      lowPrice: json['low_price'].toString(),
      ltp: json['ltp'].toString(),
      prevPrice: json['prev_price'].toString(),
      netPrice: json['net_price'].toString(),
      tradeQuantity: json['trade_quantity'].toString(),
      turnover: json['turnover'].toString(),
      marketType: json['market_type'].toString(),
      caExDt: json['ca_ex_dt'].toString(),
      caPurpose: json['ca_purpose'].toString(),
      perChange: json['perChange'].toString(),
      sector: json['sector'].toString(),
      filter: json['filter'].toString(),
      createdAt: json['createdAt'].toString(),
      updatedAt: json['updatedAt'].toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'symbol': symbol,
      'series': series,
      'open_price': openPrice,
      'high_price': highPrice,
      'low_price': lowPrice,
      'ltp': ltp,
      'prev_price': prevPrice,
      'net_price': netPrice,
      'trade_quantity': tradeQuantity,
      'turnover': turnover,
      'market_type': marketType,
      'ca_ex_dt': caExDt,
      'ca_purpose': caPurpose,
      'perChange': perChange,
      'sector': sector,
      'filter': filter,
      'createdAt': createdAt,
      'updatedAt':  updatedAt,
    };
  }
}




class MostBought {
  final String id;
  final String symbol;
  final String identifier;
  final String lastPrice;
  final String pChange;
  final String quantityTraded;
  final String totalTradedVolume;
  final String totalTradedValue;
  final String previousClose;
  final String exDate;
  final String purpose;
  final String yearHigh;
  final String yearLow;
  final String change;
  final String open;
  final String closePrice;
  final String dayHigh;
  final String dayLow;
  final String lastUpdateTime;
  final String category;
  final String subCategory;
  final String createdAt;
  final String updatedAt;

  MostBought({
    required this.id,
    required this.symbol,
    required this.identifier,
    required this.lastPrice,
    required this.pChange,
    required this.quantityTraded,
    required this.totalTradedVolume,
    required this.totalTradedValue,
    required this.previousClose,
    required this.exDate,
    required this.purpose,
    required this.yearHigh,
    required this.yearLow,
    required this.change,
    required this.open,
    required this.closePrice,
    required this.dayHigh,
    required this.dayLow,
    required this.lastUpdateTime,
    required this.category,
    required this.subCategory,
    required this.createdAt,
    required this.updatedAt,
  });

  factory MostBought.fromJson(Map<String, dynamic> json) {
    return MostBought(
      id: json['id'].toString(),
      symbol: json['symbol'].toString(),
      identifier: json['identifier'].toString(),
      lastPrice: json['lastPrice'].toString(),
      pChange: json['pChange'].toString(),
      quantityTraded: json['quantityTraded'].toString(),
      totalTradedVolume: json['totalTradedVolume'].toString(),
      totalTradedValue: json['totalTradedValue'].toString(),
      previousClose: json['previousClose'].toString(),
      exDate: json['exDate'].toString(),
      purpose: json['purpose'].toString(),
      yearHigh: json['yearHigh'].toString(),
      yearLow: json['yearLow'].toString(),
      change: json['change'].toString(),
      open: json['open'].toString(),
      closePrice: json['closePrice'].toString(),
      dayHigh: json['dayHigh'].toString(),
      dayLow: json['dayLow'].toString(),
      lastUpdateTime: json['lastUpdateTime'].toString(),
      category: json['category'].toString(),
      subCategory: json['sub_category'].toString(),
      createdAt: json['createdAt'].toString(),
      updatedAt: json['updatedAt'].toString(),
    );
  }

  void setFilter(String value) {}
}



class Week52HighLowModel{
  final String id;
  final String symbol;
  final String series;
  final String companyName;
  final String new52WHL;
  final String prev52WHL;
  final String prevHLDate;
  final String ltp;
  final String prevClose;
  final String change;
  final String pChange;
  final String filter;
  final String createdAt;
  final String updatedAt;

  Week52HighLowModel({
    required this.id,
    required this.symbol,
    required this.series,
    required this.companyName,
    required this.new52WHL,
    required this.prev52WHL,
    required this.prevHLDate,
    required this.ltp,
    required this.prevClose,
    required this.change,
    required this.pChange,
    required this.filter,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Week52HighLowModel.fromJson(Map<String, dynamic> json) {
    return Week52HighLowModel(
      id: json['id'].toString(),
      symbol: json['symbol'].toString(),
      series: json['series'].toString(),
      companyName: json['companyName'].toString(),
      new52WHL: json['new52WHL'].toString(),
      prev52WHL: json['prev52WHL'].toString(),
      prevHLDate: json['prevHLDate'].toString(),
      ltp: json['ltp'].toString(),
      prevClose: json['prevClose'].toString(),
      change: json['change'].toString(),
      pChange: json['pChange'].toString(),
      filter: json['filter'].toString(),
      createdAt: json['createdAt'].toString(),
      updatedAt: json['updatedAt'].toString(),
    );
  }

  void setFilter(String value) {}
}