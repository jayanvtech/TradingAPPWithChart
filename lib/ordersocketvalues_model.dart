// To parse this JSON data, do
//
//     final orderSocketValues = orderSocketValuesFromJson(jsonString);

import 'dart:convert';
import 'dart:convert';

import 'package:tradingapp/Position/Screens/PositionScreen/order_status.dart';

class OrderSocketValues {
  final String loginID;
  final String clientID;
  final String appOrderID;
  final String orderReferenceID;
  final String generatedBy;
  final String exchangeOrderID;
  final String orderCategoryType;
  final String exchangeSegment;
  final String exchangeInstrumentID;
  final String orderSide;
  final String orderType;
  final String productType;
  final String timeInForce;
  final String orderPrice;
  final String orderQuantity;
  final String orderStopPrice;
  final String orderStatus;
  final String orderAverageTradedPrice;
  final String leavesQuantity;
  final String cumulativeQuantity;
  final String orderDisclosedQuantity;
  final String orderGeneratedDateTime;
  final String exchangeTransactTime;
  final String lastUpdateDateTime;
  final String orderExpiryDate;
  final String cancelRejectReason;
  final String orderUniqueIdentifier;
  final String orderLegStatus;
  final String isSpread;
  final String boLegDetails;
  final String boEntryOrderId;
  final String messageCode;
  final String messageVersion;
  final String tokenID;
  final String applicationType;
  final String sequenceNumber;
  final String TradingSymbol;

  OrderSocketValues({
    required this.loginID,
    required this.clientID,
    required this.appOrderID,
    required this.orderReferenceID,
    required this.generatedBy,
    required this.exchangeOrderID,
    required this.orderCategoryType,
    required this.exchangeSegment,
    required this.exchangeInstrumentID,
    required this.orderSide,
    required this.orderType,
    required this.productType,
    required this.timeInForce,
    required this.orderPrice,
    required this.orderQuantity,
    required this.orderStopPrice,
    required this.orderStatus,
    required this.orderAverageTradedPrice,
    required this.leavesQuantity,
    required this.cumulativeQuantity,
    required this.orderDisclosedQuantity,
    required this.orderGeneratedDateTime,
    required this.exchangeTransactTime,
    required this.lastUpdateDateTime,
    required this.orderExpiryDate,
    required this.cancelRejectReason,
    required this.orderUniqueIdentifier,
    required this.orderLegStatus,
    required this.isSpread,
    required this.boLegDetails,
    required this.boEntryOrderId,
    required this.messageCode,
    required this.messageVersion,
    required this.tokenID,
    required this.applicationType,
    required this.sequenceNumber,
    required this.TradingSymbol,
  });

  factory OrderSocketValues.fromJson(Map<String, dynamic> json) {
    return OrderSocketValues(
      loginID: json['LoginID'].toString(),
      clientID: json['ClientID'].toString(),
      appOrderID: json['AppOrderID'].toString(),
      orderReferenceID: json['OrderReferenceID'].toString(),
      generatedBy: json['GeneratedBy'].toString(),
      exchangeOrderID: json['ExchangeOrderID'].toString(),
      orderCategoryType: json['OrderCategoryType'].toString(),
      exchangeSegment: json['ExchangeSegment'].toString(),
      exchangeInstrumentID: json['ExchangeInstrumentID'].toString(),
      orderSide: json['OrderSide'].toString(),
      orderType: json['OrderType'].toString(),
      productType: json['ProductType'].toString(),
      timeInForce: json['TimeInForce'].toString(),
      orderPrice: json['OrderPrice'].toString(),
      orderQuantity: json['OrderQuantity'].toString(),
      orderStopPrice: json['OrderStopPrice'].toString(),
      orderStatus: json['OrderStatus'].toString(),
      orderAverageTradedPrice: json['OrderAverageTradedPrice'].toString(),
      leavesQuantity: json['LeavesQuantity'].toString(),
      cumulativeQuantity: json['CumulativeQuantity'].toString(),
      orderDisclosedQuantity: json['OrderDisclosedQuantity'].toString(),
      orderGeneratedDateTime: json['OrderGeneratedDateTime'].toString(),
      exchangeTransactTime: json['ExchangeTransactTime'].toString(),
      lastUpdateDateTime: json['LastUpdateDateTime'].toString(),
      orderExpiryDate: json['OrderExpiryDate'].toString(),
      cancelRejectReason: json['CancelRejectReason'].toString(),
      orderUniqueIdentifier: json['OrderUniqueIdentifier'].toString(),
      orderLegStatus: json['OrderLegStatus'].toString(),
      isSpread: json['IsSpread'].toString(),
      boLegDetails: json['BoLegDetails'].toString(),
      boEntryOrderId: json['BoEntryOrderId'].toString(),
      messageCode: json['MessageCode'].toString(),
      messageVersion: json['MessageVersion'].toString(),
      tokenID: json['TokenID'].toString(),
      applicationType: json['ApplicationType'].toString(),
      sequenceNumber: json['SequenceNumber'].toString(),
      TradingSymbol: json['TradingSymbol'].toString(),
    );
  }

Map<String, dynamic> toJson() {
    return {
      'AppOrderID': appOrderID,
      'ExchangeInstrumentID': exchangeInstrumentID,
      'OrderStatus': orderStatus,
      'OrderSide': orderSide,
      'OrderType': orderType,
      'ProductType': productType,
      'CumulativeQuantity': cumulativeQuantity,
      'OrderPrice': orderPrice,
      'OrderQuantity': orderQuantity,
      'OrderGeneratedDateTime': orderGeneratedDateTime,
      'ExchangeTransactTime': exchangeTransactTime,
      'OrderAverageTradedPrice': orderAverageTradedPrice,
      'LeavesQuantity': leavesQuantity,
      'OrderReferenceID': orderReferenceID,
      'OrderCategoryType': orderCategoryType,
      'ExchangeSegment': exchangeSegment,
      'TimeInForce': timeInForce,
      'OrderStopPrice': orderStopPrice,
      'OrderDisclosedQuantity': orderDisclosedQuantity,
      'LastUpdateDateTime': lastUpdateDateTime,
      'OrderExpiryDate': orderExpiryDate,
      'CancelRejectReason': cancelRejectReason,
      'OrderUniqueIdentifier': orderUniqueIdentifier,
      'OrderLegStatus': orderLegStatus,
      'IsSpread': isSpread,
      'BoLegDetails': boLegDetails,
      'BoEntryOrderId': boEntryOrderId,
      'MessageCode': messageCode,
      'MessageVersion': messageVersion,
      'TokenID': tokenID,
      'ApplicationType': applicationType,
      'SequenceNumber': sequenceNumber,
      'TradingSymbol': TradingSymbol,
    };
  }
  static OrderStatus _mapStatus(String status) {
    switch (status.toLowerCase()) {
      case 'filled':
        return OrderStatus.successful;
      case 'pendingnew':
        return OrderStatus.pending;
      case 'rejected':
        return OrderStatus.rejected;
      case 'cancelled':
        return OrderStatus.cancelled;
      default:
        return OrderStatus.pending; // Default to pending if unknown status
    }
  }
}

class PostionSocketValue {
  final String loginID;
  final String accountID;
  final String tradingSymbol;
  final String exchangeSegment;
  final String exchangeInstrumentID;
  final String productType;
  final String multiplier;
  final String marketlot;
  final String buyAveragePrice;
  final String sellAveragePrice;
  final String longPosition;
  final String shortPosition;
  final String netPosition;
  final String buyValue;
  final String sellValue;
  final String netValue;
  final String unrealizedMTM;
  final String realizedMTM;
  final String mtm;
  final String bep;
  final String sumOfTradedQuantityAndPriceBuy;
  final String sumOfTradedQuantityAndPriceSell;
  final String statisticsLevel;
  final String isInterOpPosition;
  final String childPositions;
  final String messageCode;
  final String messageVersion;
  final String tokenID;
  final String applicationType;
  final String sequenceNumber;

  PostionSocketValue({
    required this.loginID,
    required this.accountID,
    required this.tradingSymbol,
    required this.exchangeSegment,
    required this.exchangeInstrumentID,
    required this.productType,
    required this.multiplier,
    required this.marketlot,
    required this.buyAveragePrice,
    required this.sellAveragePrice,
    required this.longPosition,
    required this.shortPosition,
    required this.netPosition,
    required this.buyValue,
    required this.sellValue,
    required this.netValue,
    required this.unrealizedMTM,
    required this.realizedMTM,
    required this.mtm,
    required this.bep,
    required this.sumOfTradedQuantityAndPriceBuy,
    required this.sumOfTradedQuantityAndPriceSell,
    required this.statisticsLevel,
    required this.isInterOpPosition,
    required this.childPositions,
    required this.messageCode,
    required this.messageVersion,
    required this.tokenID,
    required this.applicationType,
    required this.sequenceNumber,
  });

  factory PostionSocketValue.fromJson(Map<String, dynamic> json) {
    return PostionSocketValue(
      loginID: json['LoginID'].toString(),
      accountID: json['AccountID'].toString(),
      tradingSymbol: json['TradingSymbol'].toString(),
      exchangeSegment: json['ExchangeSegment'].toString(),
      exchangeInstrumentID: json['ExchangeInstrumentID'].toString(),
      productType: json['ProductType'].toString(),
      multiplier: json['Multiplier'].toString(),
      marketlot: json['Marketlot'].toString(),
      buyAveragePrice: json['BuyAveragePrice'].toString(),
      sellAveragePrice: json['SellAveragePrice'].toString(),
      longPosition: json['LongPosition'].toString(),
      shortPosition: json['ShortPosition'].toString(),
      netPosition: json['NetPosition'].toString(),
      buyValue: json['BuyValue'].toString(),
      sellValue: json['SellValue'].toString(),
      netValue: json['NetValue'].toString(),
      unrealizedMTM: json['UnrealizedMTM'].toString(),
      realizedMTM: json['RealizedMTM'].toString(),
      mtm: json['MTM'].toString(),
      bep: json['BEP'].toString(),
      sumOfTradedQuantityAndPriceBuy: json['SumOfTradedQuantityAndPriceBuy'].toString(),
      sumOfTradedQuantityAndPriceSell: json['SumOfTradedQuantityAndPriceSell'].toString(),
      statisticsLevel: json['StatisticsLevel'].toString(),
      isInterOpPosition: json['IsInterOpPosition'].toString(),
      childPositions: json['childPositions'].toString(),
      messageCode: json['MessageCode'].toString(),
      messageVersion: json['MessageVersion'].toString(),
      tokenID: json['TokenID'].toString(),
      applicationType: json['ApplicationType'].toString(),
      sequenceNumber: json['SequenceNumber'].toString(),
    );
  }
  
}
