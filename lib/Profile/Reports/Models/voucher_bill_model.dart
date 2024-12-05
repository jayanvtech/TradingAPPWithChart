class VoucherBillModel {
  final String instType;
  final String samt;
  final String netAmt;
  final String netQty;
  final String expiryDate;
  final String scripBrk;
  final String bseScripSymbol;
  final String nseScripSymbol;
  final String bfQty;
  final String bfRate;
  final String bfAmt;
  final String isin;
  final String closingAmt;
  final String clPriced;
  final String aeQty;
  final String aeRate;
  final String aeAmt;
  final String scripName;
  final String billNo;
  final String bQty;
  final String sQty;
  final String bRate;
  final String sRate;
  final String bAmt;
  final String isin1;
  final String closeRate;

  VoucherBillModel({
    required this.instType,
    required this.samt,
    required this.netAmt,
    required this.netQty,
    required this.expiryDate,
    required this.scripBrk,
    required this.bseScripSymbol,
    required this.nseScripSymbol,
    required this.bfQty,
    required this.bfRate,
    required this.bfAmt,
    required this.isin,
    required this.closingAmt,
    required this.clPriced,
    required this.aeQty,
    required this.aeRate,
    required this.aeAmt,
    required this.scripName,
    required this.billNo,
    required this.bQty,
    required this.sQty,
    required this.bRate,
    required this.sRate,
    required this.bAmt,
    required this.isin1,
    required this.closeRate,
  });

  factory VoucherBillModel.fromJson(Map<String, dynamic> json) {
    return VoucherBillModel(
      instType: json['INST_TYPE'],
      samt: json['SAMT'],
      netAmt: json['NETAMT'],
      netQty: json['NETQTY'],
      expiryDate: json['EXPIRY_DATE'],
      scripBrk: json['SCRIPBRK'],
      bseScripSymbol: json['BSE_SCRIP_SYMBOL'],
      nseScripSymbol: json['NSE_SCRIP_SYMBOL'],
      bfQty: json['BFQTY'],
      bfRate: json['BFRATE'],
      bfAmt: json['BFAMT'],
      isin: json['ISIN'],
      closingAmt: json['CLOSINGAMT'],
      clPriced: json['CLPRICED'],
      aeQty: json['AEQTY'],
      aeRate: json['AERATE'],
      aeAmt: json['AEAMT'],
      scripName: json['SCRIP_NAME'],
      billNo: json['BILL_NO'],
      bQty: json['BQTY'],
      sQty: json['SQTY'],
      bRate: json['BRATE'],
      sRate: json['SRATE'],
      bAmt: json['BAMT'],
      isin1: json['ISIN1'],
      closeRate: json['CLOSERATE'] ?? "0.0",
    );
  }
}
