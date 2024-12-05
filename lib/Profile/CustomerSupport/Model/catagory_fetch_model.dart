class TicketAPIModel {
  String? status;
  TicketData? data;

  TicketAPIModel({this.status, this.data});

  TicketAPIModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? TicketData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class TicketData {
  AccountDetails? accountDetails;
  AccountDetails? brokerageOtherCharges;
  AccountDetails? fundsAccountBalance;
  AccountDetails? iPOOFS;
  AccountDetails? marginPledgeMarginTradingFacility;
  AccountDetails? mutualFunds;
  AccountDetails? orderRelated;
  AccountDetails? portfolioCorporateActions;
  AccountDetails? researchRecommendations;
  AccountDetails? statements;

  TicketData({
    this.accountDetails,
    this.brokerageOtherCharges,
    this.fundsAccountBalance,
    this.iPOOFS,
    this.marginPledgeMarginTradingFacility,
    this.mutualFunds,
    this.orderRelated,
    this.portfolioCorporateActions,
    this.researchRecommendations,
    this.statements,
  });

  TicketData.fromJson(Map<String, dynamic> json) {
    accountDetails = json['Account Details'] != null
        ? AccountDetails.fromJson(json['Account Details'])
        : null;
    brokerageOtherCharges = json['Brokerage & Other Charges'] != null
        ? AccountDetails.fromJson(json['Brokerage & Other Charges'])
        : null;
    fundsAccountBalance = json['Funds & Account Balance'] != null
        ? AccountDetails.fromJson(json['Funds & Account Balance'])
        : null;
    iPOOFS = json['IPO, OFS'] != null
        ? AccountDetails.fromJson(json['IPO, OFS'])
        : null;
    marginPledgeMarginTradingFacility =
        json['Margin Pledge & Margin Trading Facility'] != null
            ? AccountDetails.fromJson(
                json['Margin Pledge & Margin Trading Facility'])
            : null;
    mutualFunds = json['Mutual Funds'] != null
        ? AccountDetails.fromJson(json['Mutual Funds'])
        : null;
    orderRelated = json['Order Related'] != null
        ? AccountDetails.fromJson(json['Order Related'])
        : null;
    portfolioCorporateActions = json['Portfolio & Corporate Actions'] != null
        ? AccountDetails.fromJson(json['Portfolio & Corporate Actions'])
        : null;
    researchRecommendations = json['Research Recommendations'] != null
        ? AccountDetails.fromJson(json['Research Recommendations'])
        : null;
    statements = json['Statements'] != null
        ? AccountDetails.fromJson(json['Statements'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (accountDetails != null) {
      data['Account Details'] = accountDetails!.toJson();
    }
    if (brokerageOtherCharges != null) {
      data['Brokerage & Other Charges'] = brokerageOtherCharges!.toJson();
    }
    if (fundsAccountBalance != null) {
      data['Funds & Account Balance'] = fundsAccountBalance!.toJson();
    }
    if (iPOOFS != null) {
      data['IPO, OFS'] = iPOOFS!.toJson();
    }
    if (marginPledgeMarginTradingFacility != null) {
      data['Margin Pledge & Margin Trading Facility'] =
          marginPledgeMarginTradingFacility!.toJson();
    }
    if (mutualFunds != null) {
      data['Mutual Funds'] = mutualFunds!.toJson();
    }
    if (orderRelated != null) {
      data['Order Related'] = orderRelated!.toJson();
    }
    if (portfolioCorporateActions != null) {
      data['Portfolio & Corporate Actions'] =
          portfolioCorporateActions!.toJson();
    }
    if (researchRecommendations != null) {
      data['Research Recommendations'] = researchRecommendations!.toJson();
    }
    if (statements != null) {
      data['Statements'] = statements!.toJson();
    }
    return data;
  }
}

class AccountDetails {
  int? categoryId;
  List<Subcategories>? subcategories;

  AccountDetails({this.categoryId, this.subcategories});

  AccountDetails.fromJson(Map<String, dynamic> json) {
    categoryId = json['categoryId'];
    if (json['subcategories'] != null) {
      subcategories = <Subcategories>[];
      json['subcategories'].forEach((v) {
        subcategories!.add(Subcategories.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['categoryId'] = categoryId;
    if (subcategories != null) {
      data['subcategories'] = subcategories!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Subcategories {
  int? subcategoryId;
  String? subcategoryName;

  Subcategories({this.subcategoryId, this.subcategoryName});

  Subcategories.fromJson(Map<String, dynamic> json) {
    subcategoryId = json['subcategoryId'];
    subcategoryName = json['subcategoryName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['subcategoryId'] = subcategoryId;
    data['subcategoryName'] = subcategoryName;
    return data;
  }
}
