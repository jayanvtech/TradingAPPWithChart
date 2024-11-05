class Holding {
  final String isin;
  final String rmsHoldingId;
  final String clientId;
  final String exchangeNSEInstrumentId;
  final String exchangeBSEInstrumentId;
  final String exchangeMSEInstrumentId;
  final String holdingType;
  final String holdingQuantity;
  final String collateralValuationType;
  final String haircut;
  final String collateralQuantity;
  final String createdBy;
  final String lastUpdatedBy;
  final String createdOn;
  final String lastUpdatedOn;
  final String usedQuantity;
  final String isCollateralHolding;
  final String buyAvgPrice;
  final String isBuyAvgPriceProvided;
  final String authorizeQuantity;
  final String isNeedToDelete;
  final String pledgeQuantity;
  final String isPledgeHolding;
  final String DisplayName;

  Holding({
    required this.isin,
    required this.rmsHoldingId,
    required this.clientId,
    required this.exchangeNSEInstrumentId,
    required this.exchangeBSEInstrumentId,
    required this.exchangeMSEInstrumentId,
    required this.holdingType,
    required this.holdingQuantity,
    required this.collateralValuationType,
    required this.haircut,
    required this.collateralQuantity,
    required this.createdBy,
    required this.lastUpdatedBy,
    required this.createdOn,
    required this.lastUpdatedOn,
    required this.usedQuantity,
    required this.isCollateralHolding,
    required this.buyAvgPrice,
    required this.isBuyAvgPriceProvided,
    required this.authorizeQuantity,
    required this.isNeedToDelete,
    required this.pledgeQuantity,

    required this.isPledgeHolding,
    required this.DisplayName,
  });

  factory Holding.fromJson(Map<String, dynamic> json) {
    return Holding(
      isin: json['ISIN'] ?? '',
      rmsHoldingId: json['RMSHoldingId'].toString(),
      clientId: json['ClientId'] ?? '',
      exchangeNSEInstrumentId: json['ExchangeNSEInstrumentId'].toString(),
      exchangeBSEInstrumentId: json['ExchangeBSEInstrumentId'].toString(),
      exchangeMSEInstrumentId: json['ExchangeMSEInstrumentId'].toString(),
      holdingType: json['HoldingType'].toString(),
      holdingQuantity: json['HoldingQuantity'].toString(),
      collateralValuationType: json['CollateralValuationType'].toString(),
      haircut: json['Haircut'].toString(),
      collateralQuantity: json['CollateralQuantity'].toString(),
      createdBy: json['CreatedBy'] ?? '',
      lastUpdatedBy: json['LastUpdatedBy'] ?? '',
      createdOn: json['CreatedOn'] ?? '',
      lastUpdatedOn: json['LastUpdatedOn'] ?? '',
      usedQuantity: json['UsedQuantity'].toString(),
      isCollateralHolding: json['IsCollateralHolding'].toString(),
      buyAvgPrice: json['BuyAvgPrice'].toString(),
      isBuyAvgPriceProvided: json['IsBuyAvgPriceProvided'].toString(),
      authorizeQuantity: json['AuthorizeQuantity'].toString(),
      isNeedToDelete: json['IsNeedToDelete'].toString(),
      pledgeQuantity: json['PledgeQuantity'].toString(),
      isPledgeHolding: json['IsPledgeHolding'].toString(),
      DisplayName: json['DisplayName'].toString(),
    );
  }

  static List<Holding> fromJsonList(Map<String, dynamic> json) {
    List<Holding> holdings = [];
    json.forEach((key, value) {
      holdings.add(Holding.fromJson(value));
    });
    return holdings;
  }
}

class Portfolio {
  final String clientId;
  final List<Holding> holdings;

  Portfolio({
    required this.clientId,
    required this.holdings,
  });

  factory Portfolio.fromJson(Map<String, dynamic> json) {
    return Portfolio(
      clientId: json['ClientId'] ?? '',
      holdings: Holding.fromJsonList(json['RMSHoldings']['Holdings']),
    );
  }
}
