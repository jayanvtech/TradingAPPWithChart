class StockModel {
  final String exchangeSegment;
  final String exchangeInstrumentID;
  final String instrumentType;
  final String name;
  final String displayName;
  final String description;
  final String series;
  final String nameWithSeries;
  final String instrumentID;
  final PriceBand priceBand;
  final String freezeQty;
  final String tickSize;
  final String lotSize;
  final String companyName;
  final String decimalDisplace;
  final String isIndex;
  final String isTradeable;
  final String industry;

  StockModel({
    required this.exchangeSegment,
    required this.exchangeInstrumentID,
    required this.instrumentType,
    required this.name,
    required this.displayName,
    required this.description,
    required this.series,
    required this.nameWithSeries,
    required this.instrumentID,
    required this.priceBand,
    required this.freezeQty,
    required this.tickSize,
    required this.lotSize,
    required this.companyName,
    required this.decimalDisplace,
    required this.isIndex,
    required this.isTradeable,
    required this.industry,
  });

  // Factory method to parse from JSON
  factory StockModel.fromJson(Map<String, dynamic> json) {
    return StockModel(
      exchangeSegment: json['ExchangeSegment'].toString(),
      exchangeInstrumentID: json['ExchangeInstrumentID'].toString(),
      instrumentType: json['InstrumentType'].toString(),
      name: json['Name'].toString(),
      displayName: json['DisplayName'].toString(),
      description: json['Description'].toString(),
      series: json['Series'].toString(),
      nameWithSeries: json['NameWithSeries'].toString(),
      instrumentID: json['InstrumentID'].toString(),
      priceBand: PriceBand.fromJson(json['PriceBand']),
      freezeQty: json['FreezeQty'].toString(),
      tickSize: json['TickSize'].toString(),
      lotSize: json['LotSize'].toString(),
      companyName: json['CompanyName'].toString(),
      decimalDisplace: json['DecimalDisplace'].toString(),
      isIndex: json['IsIndex'].toString(),
      isTradeable: json['IsTradeable'].toString(),
      industry: json['Industry'].toString(),
    );
  }
}

class PriceBand {
  final String high;
  final String low;
  final String highString;
  final String lowString;
  final String creditRating;
  final String highExecBandString;
  final String lowExecBandString;
  final String highExecBand;
  final String lowExecBand;
  final String terRange;

  PriceBand({
    required this.high,
    required this.low,
    required this.highString,
    required this.lowString,
    required this.creditRating,
    required this.highExecBandString,
    required this.lowExecBandString,
    required this.highExecBand,
    required this.lowExecBand,
    required this.terRange,
  });

  // Factory method to parse from JSON
  factory PriceBand.fromJson(Map<String, dynamic> json) {
    return PriceBand(
      high: json['High'].toString(),
      low: json['Low'].toString(),
      highString: json['HighString'].toString(),
      lowString: json['LowString'].toString(),
      creditRating: json['CreditRating'].toString(),
      highExecBandString: json['HighExecBandString'].toString(),
      lowExecBandString: json['LowExecBandString'].toString(),
      highExecBand: json['HighExecBand'].toString(),
      lowExecBand: json['LowExecBand'].toString(),
      terRange: json['TERRange'].toString(),
    );
  }
}
