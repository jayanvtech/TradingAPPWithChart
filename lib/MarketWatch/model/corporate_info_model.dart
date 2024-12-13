class StockCorporateDetailModel {
  List<Announcement> latestAnnouncements;
  List<CorporateAction> corporateActions;
  Map<String, List<ShareholdingPattern>> shareholdingPatterns;
  List<FinancialResult> financialResults;
  List<BoardMeeting> boardMeetings;

  StockCorporateDetailModel({
    required this.latestAnnouncements,
    required this.corporateActions,
    required this.shareholdingPatterns,
    required this.financialResults,
    required this.boardMeetings,
  });

  factory StockCorporateDetailModel.fromJson(Map<String, dynamic> json) {
    return StockCorporateDetailModel(
      latestAnnouncements: (json['data']['latest_announcements']['data'] as List).map((item) => Announcement.fromJson(item)).toList(),
      corporateActions: (json['data']['corporate_actions']['data'] as List).map((item) => CorporateAction.fromJson(item)).toList(),
      shareholdingPatterns: (json['data']['shareholdings_patterns']['data'] as Map<String, dynamic>).map(
        (key, value) => MapEntry(
          key,
          (value as List).map((item) => ShareholdingPattern.fromJson(item)).toList(),
        ),
      ),
      financialResults: (json['data']['financial_results']['data'] as List).map((item) => FinancialResult.fromJson(item)).toList(),
      boardMeetings: (json['data']['borad_meeting']['data'] as List).map((item) => BoardMeeting.fromJson(item)).toList(),
    );
  }
}

class Announcement {
  final String symbol;
  final String broadcastDate;
  final String subject;

  Announcement({required this.symbol, required this.broadcastDate, required this.subject});

  factory Announcement.fromJson(Map<String, dynamic> json) {
    return Announcement(
      symbol: json['symbol'],
      broadcastDate: json['broadcastdate'],
      subject: json['subject'],
    );
  }
}

class CorporateAction {
  final String symbol;
  final String exDate;
  final String purpose;

  CorporateAction({required this.symbol, required this.exDate, required this.purpose});

  factory CorporateAction.fromJson(Map<String, dynamic> json) {
    return CorporateAction(
      symbol: json['symbol'],
      exDate: json['exdate'],
      purpose: json['purpose'],
    );
  }
}

class ShareholdingPattern {
  final String category;
  final String percentage;
  final String key;

  ShareholdingPattern({required this.category, required this.percentage, required this.key});

  factory ShareholdingPattern.fromJson(Map<String, dynamic> json) {
    return ShareholdingPattern(
      key: json.keys.first,
      category: json.keys.first,
      percentage: json.values.first.toString().trim(),
    );
  }

  get entries => null;

  get keys => null;
}

class FinancialResult {
  final String fromDate;
  final String toDate;
  final String expenditure;
  final String income;
  final String audited;
  final String cumulative;
  final String consolidated;
  final String reDilEPS;
  final String reProLossBefTax;
  final String proLossAftTax;
  final String reBroadcastTimestamp;
  final String xbrlAttachment;
  final String? naAttachment;

  FinancialResult({
    required this.fromDate,
    required this.toDate,
    required this.expenditure,
    required this.income,
    required this.audited,
    required this.cumulative,
    required this.consolidated,
    required this.reDilEPS,
    required this.reProLossBefTax,
    required this.proLossAftTax,
    required this.reBroadcastTimestamp,
    required this.xbrlAttachment,
    required this.naAttachment,
  });

  factory FinancialResult.fromJson(Map<String, dynamic> json) {
    return FinancialResult(
      fromDate: json['from_date'],
      toDate: json['to_date'],
      expenditure: json['expenditure'],
      income: json['income'],
      audited: json['audited'],
      cumulative: json['cumulative'],
      consolidated: json['consolidated'],
      reDilEPS: json['reDilEPS'],
      reProLossBefTax: json['reProLossBefTax'],
      proLossAftTax: json['proLossAftTax'],
      reBroadcastTimestamp: json['re_broadcast_timestamp'],
      xbrlAttachment: json['xbrl_attachment'],
      naAttachment: json['na_attachment'],
    );
  }
}

class BoardMeeting {
  final String symbol;
  final String purpose;
  final String meetingDate;

  BoardMeeting({required this.symbol, required this.purpose, required this.meetingDate});

  factory BoardMeeting.fromJson(Map<String, dynamic> json) {
    return BoardMeeting(
      symbol: json['symbol'],
      purpose: json['purpose'],
      meetingDate: json['meetingdate'],
    );
  }
}
