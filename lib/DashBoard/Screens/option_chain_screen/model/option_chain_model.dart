class OptionChain {
  final String? exchangeSegment;
  final String? exchangeInstrumentID;
  final String? name;
  final String? instrumentType;
  final String? displayName;
  final String? description;
  final String? series;
  final String? nameWithSeries;
  final String? instrumentID;
  // final double? highPrice;
  // final double? lowPrice;
  // final double? freezeQty;
  // final double? tickSize;
  final String? lotSize;
  final String? companyName;
  final String? decimalDisplace;
  final String? isIndex;
  final String? isTradeable;
  final String? industry;
  final String? contractExpiration;
  final String? remainingExpiryDays;
  final String? strikePrice;
  final String? optionType;
  final String? ContractExpirationString;

  OptionChain({
     this.exchangeSegment,
     this.exchangeInstrumentID,
     this.instrumentType,
     this.name,
     this.displayName,
     this.description,
     this.series,
     this.nameWithSeries,
     this.instrumentID,
    //  this.highPrice,
    //  this.lowPrice,
    //  this.freezeQty,
    //  this.tickSize,
     this.lotSize,
     this.companyName,
     this.decimalDisplace,
     this.isIndex,
     this.isTradeable,
     this.industry,
     this.contractExpiration,
     this.remainingExpiryDays,
     this.strikePrice,
     this.optionType,
      this.ContractExpirationString,
  });

  factory OptionChain.fromJson(Map<String, dynamic> json) {
    return OptionChain(
      exchangeSegment: json['ExchangeSegment'].toString() ?? '',
      exchangeInstrumentID: json['ExchangeInstrumentID'].toString() ?? '',
      instrumentType: json['InstrumentType'].toString() ?? '',
      name: json['Name'].toString() ?? '',
      displayName: json['DisplayName'].toString() ?? '',
      description: json['Description'] .toString() ?? '',
      series: json['Series'].toString() ?? '',
      nameWithSeries: json['NameWithSeries'].toString() ?? '',
      instrumentID: json['InstrumentID'].toString() ?? '', 
      // highPrice: json['PriceBand']['High'].toDouble() ?? 0.0,
      // lowPrice: json['PriceBand']['Low'].toDouble() ?? 0.0,
      // freezeQty: json['FreezeQty'].toDouble() ?? 0.0,
      // tickSize: json['TickSize'].toDouble() ?? 0.0,
      lotSize: json['LotSize'].toString() ?? '',
      companyName: json['CompanyName'].toString() ?? '',
      decimalDisplace: json['DecimalDisplace'].toString() ?? '',
      isIndex: json['IsIndex'].toString() ?? '',
      isTradeable: json['IsTradeable'] .toString() ?? '',
      industry: json['Industry'] .toString() ?? '',
      contractExpiration: json['ContractExpiration'] .toString() ?? '',
      remainingExpiryDays: json['RemainingExpiryDays'].toString() ?? '',
      strikePrice: json['StrikePrice'].toString() ?? '0',
      optionType: json['OptionType'].toString() ?? '',
      ContractExpirationString: json['ContractExpirationString'].toString().toUpperCase() ?? '',
    );
  }
}
