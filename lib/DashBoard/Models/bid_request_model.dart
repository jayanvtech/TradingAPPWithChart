class BidRequest {
  String symbol;
  String category;
  String upiId;
  double quantity;
  double price;
  double amount;
  String boId;

  BidRequest({
    required this.symbol,
    required this.category,
    required this.upiId,
    required this.quantity,
    required this.price,
    required this.amount,
    required this.boId,
  });

  Map<String, dynamic> toJson() {
    return {
      'symbol': symbol,
      'category': category,
      'upi_id': upiId,
      'quantity': quantity,
      'price': price,
      'amount': amount,
      'BOId': boId,
    };
  }
}

// response_model.dart
class BidResponse {
  String status;
  String message;
  Data data;

  BidResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory BidResponse.fromJson(Map<String, dynamic> json) {
    return BidResponse(
      status: json['status'],
      message: json['message'],
      data: Data.fromJson(json['data']),
    );
  }
}

class Data {
  String message;
  String applicationNo;
  int bidReferenceNo;
  String exchange;

  Data({
    required this.message,
    required this.applicationNo,
    required this.bidReferenceNo,
    required this.exchange,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      message: json['message'],
      applicationNo: json['application_no'],
      bidReferenceNo: json['bid_reference_no'],
      exchange: json['exchange'],
    );
  }
}
