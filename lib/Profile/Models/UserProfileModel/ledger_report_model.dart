class LedgerReportModel {
  final String cocd;
  final String drAmt;
  final String crAmt;
  final String voucherDate;
  final String settlementNo;
  final String ctrCode;
  final String ctrName;
  final String transType;
  final String voucherNo;
  final String narration;
  final String billNo;
  final String coName;
  final String chqNo;
  final String expectedDate;
  final String tradingCocd;
  final String panNo;
  final String email;
  final String manualVno;
  final String bookTypeCode;
  final String billDate;
  final String mktType;
  final String groupCode;
  final String kindOfAccount;
  final String brsFlag;
  final String setlPayInDate;
  final String last2Setl;
  final String accountCode1;
  final String gatewayId;
  final String punchTime;
  final String vocType;
  final String chqImagePath;
  final String transType1;
  final String accountCode;
  final String accountName;
  final String telNo;
  final String fax;
  final String addr;
  final String openingBalance;
  final String TOTAL_BALANCE;

  LedgerReportModel({
    required this.cocd,
    required this.drAmt,
    required this.crAmt,
    required this.voucherDate,
    required this.settlementNo,
    required this.ctrCode,
    required this.ctrName,
    required this.transType,
    required this.voucherNo,
    required this.narration,
    required this.billNo,
    required this.coName,
    required this.chqNo,
    required this.expectedDate,
    required this.tradingCocd,
    required this.panNo,
    required this.email,
    required this.manualVno,
    required this.bookTypeCode,
    required this.billDate,
    required this.mktType,
    required this.groupCode,
    required this.kindOfAccount,
    required this.brsFlag,
    required this.setlPayInDate,
    required this.last2Setl,
    required this.accountCode1,
    required this.gatewayId,
    required this.punchTime,
    required this.vocType,
    required this.chqImagePath,
    required this.transType1,
    required this.accountCode,
    required this.accountName,
    required this.telNo,
    required this.fax,
    required this.addr,
    required this.openingBalance,
    required this.TOTAL_BALANCE,
  });

  // Factory method to create an instance from JSON
  factory LedgerReportModel.fromJson(List<dynamic> json) {
    return LedgerReportModel(
      cocd: json[0].toString(),
      drAmt: json[1].toString(),
      crAmt: json[2].toString(),
      voucherDate: json[3].toString(),
      settlementNo: json[4].toString(),
      ctrCode: json[5].toString(),
      ctrName: json[6].toString(),
      transType: json[7].toString(),
      voucherNo: json[8].toString(),
      narration: json[9].toString(),
      billNo: json[10].toString(),
      coName: json[11].toString(),
      chqNo: json[12].toString(),
      expectedDate: json[13].toString(),
      tradingCocd: json[14].toString(),
      panNo: json[15].toString(),
      email: json[16].toString(),
      manualVno: json[17].toString(),
      bookTypeCode: json[18].toString(),
      billDate: json[19].toString(),
      mktType: json[20].toString(),
      groupCode: json[21].toString(),
      kindOfAccount: json[22].toString(),
      brsFlag: json[23].toString(),
      setlPayInDate: json[24].toString(),
      last2Setl: json[25].toString(),
      accountCode1: json[26].toString(),
      gatewayId: json[27].toString(),
      punchTime: json[28].toString(),
      vocType: json[29].toString(),
      chqImagePath: json[30].toString(),
      transType1: json[31].toString(),
      accountCode: json[32].toString(),
      accountName: json[33].toString(),
      telNo: json[34].toString(),
      fax: json[35].toString(),
      addr: json[36].toString(),
      openingBalance: json[37].toString(),
      TOTAL_BALANCE: json[38].toString(),
    );
  }

  // Method to convert the object to JSON
  List<dynamic> toJson() {
    return [
      cocd,
      drAmt,
      crAmt,
      voucherDate,
      settlementNo,
      ctrCode,
      ctrName,
      transType,
      voucherNo,
      narration,
      billNo,
      coName,
      chqNo,
      expectedDate,
      tradingCocd,
      panNo,
      email,
      manualVno,
      bookTypeCode,
      billDate,
      mktType,
      groupCode,
      kindOfAccount,
      brsFlag,
      setlPayInDate,
      last2Setl,
      accountCode1,
      gatewayId,
      punchTime,
      vocType,
      chqImagePath,
      transType1,
      accountCode,
      accountName,
      telNo,
      fax,
      addr,
      openingBalance,
 
    ];
  }
}



class FundtransaferModel {
  final String cocd;
  final String drAmt;
  final String crAmt;
  final String voucherDate;
  final String settlementNo;
  final String ctrCode;
  final String ctrName;
  final String transType;
  final String voucherNo;
  final String narration;
  final String billNo;
  final String coName;
  final String chqNo;
  final String expectedDate;
  final String tradingCocd;
  final String panNo;
  final String email;
  final String manualVno;
  final String bookTypeCode;
  final String billDate;
  final String mktType;
  final String groupCode;
  final String kindOfAccount;
  final String brsFlag;
  final String setlPayInDate;
  final String last2Setl;
  final String accountCode1;
  final String gatewayId;
  final String punchTime;
  final String vocType;
  final String chqImagePath;
  final String transType1;
  final String accountCode;
  final String accountName;
  final String telNo;
  final String fax;
  final String addr;
  final String openingBalance;


  FundtransaferModel({
    required this.cocd,
    required this.drAmt,
    required this.crAmt,
    required this.voucherDate,
    required this.settlementNo,
    required this.ctrCode,
    required this.ctrName,
    required this.transType,
    required this.voucherNo,
    required this.narration,
    required this.billNo,
    required this.coName,
    required this.chqNo,
    required this.expectedDate,
    required this.tradingCocd,
    required this.panNo,
    required this.email,
    required this.manualVno,
    required this.bookTypeCode,
    required this.billDate,
    required this.mktType,
    required this.groupCode,
    required this.kindOfAccount,
    required this.brsFlag,
    required this.setlPayInDate,
    required this.last2Setl,
    required this.accountCode1,
    required this.gatewayId,
    required this.punchTime,
    required this.vocType,
    required this.chqImagePath,
    required this.transType1,
    required this.accountCode,
    required this.accountName,
    required this.telNo,
    required this.fax,
    required this.addr,
    required this.openingBalance,
 
  });

  // Factory method to create an instance from JSON
  factory FundtransaferModel.fromJson(List<dynamic> json) {
    return FundtransaferModel(
      cocd: json[0].toString(),
      drAmt: json[1].toString(),
      crAmt: json[2].toString(),
      voucherDate: json[3].toString(),
      settlementNo: json[4].toString(),
      ctrCode: json[5].toString(),
      ctrName: json[6].toString(),
      transType: json[7].toString(),
      voucherNo: json[8].toString(),
      narration: json[9].toString(),
      billNo: json[10].toString(),
      coName: json[11].toString(),
      chqNo: json[12].toString(),
      expectedDate: json[13].toString(),
      tradingCocd: json[14].toString(),
      panNo: json[15].toString(),
      email: json[16].toString(),
      manualVno: json[17].toString(),
      bookTypeCode: json[18].toString(),
      billDate: json[19].toString(),
      mktType: json[20].toString(),
      groupCode: json[21].toString(),
      kindOfAccount: json[22].toString(),
      brsFlag: json[23].toString(),
      setlPayInDate: json[24].toString(),
      last2Setl: json[25].toString(),
      accountCode1: json[26].toString(),
      gatewayId: json[27].toString(),
      punchTime: json[28].toString(),
      vocType: json[29].toString(),
      chqImagePath: json[30].toString(),
      transType1: json[31].toString(),
      accountCode: json[32].toString(),
      accountName: json[33].toString(),
      telNo: json[34].toString(),
      fax: json[35].toString(),
      addr: json[36].toString(),
      openingBalance: json[37].toString(),
   
    );
  }

  // Method to convert the object to JSON
  List<dynamic> toJson() {
    return [
      cocd,
      drAmt,
      crAmt,
      voucherDate,
      settlementNo,
      ctrCode,
      ctrName,
      transType,
      voucherNo,
      narration,
      billNo,
      coName,
      chqNo,
      expectedDate,
      tradingCocd,
      panNo,
      email,
      manualVno,
      bookTypeCode,
      billDate,
      mktType,
      groupCode,
      kindOfAccount,
      brsFlag,
      setlPayInDate,
      last2Setl,
      accountCode1,
      gatewayId,
      punchTime,
      vocType,
      chqImagePath,
      transType1,
      accountCode,
      accountName,
      telNo,
      fax,
      addr,
      openingBalance,

    ];
  }
}
