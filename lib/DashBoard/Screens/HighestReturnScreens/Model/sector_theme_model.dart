class SectorThemeModel {
  final double dayRSI14CurrentCandle;
  final double daySMA200CurrentCandle;
  final double daySMA50CurrentCandle;
  final String dispSym;
  final double divYield;
  final double eps;
  final String exch;
  final double high1Yr;
  final double indPe;
  final String inst;
  final String isin;
  final int lotSize;
  final double low1Yr;
  final double ltp;
  final double mcap;
  final int multiplier;
  final double netProfitMargin;
  final double pPerchange;
  final double pb;
  final double pchange;
  final double pe;
  final double pricePerchng1mon;
  final double pricePerchng1year;
  final double pricePerchng3mon;
  final double pricePerchng3year;
  final double pricePerchng5year;
  final double roce;
  final double revenue;
  final double roe;
  final String seg;
  final String seosym;
  final int sid;
  final String sym;
  final double tickSize;
  final int volume;
  final double year1RevenueGrowth;
  final double yoyLastQtrlyProfitGrowth;
  final String sector;
  final DateTime createdAt;
  final DateTime updatedAt;

  SectorThemeModel({
    this.dayRSI14CurrentCandle = 0.0,
    this.daySMA200CurrentCandle = 0.0,
    this.daySMA50CurrentCandle = 0.0,
    this.dispSym = '',
    this.divYield = 0.0,
    this.eps = 0.0,
    this.exch = '',
    this.high1Yr = 0.0,
    this.indPe = 0.0,
    this.inst = '',
    this.isin = '',
    this.lotSize = 0,
    this.low1Yr = 0.0,
    this.ltp = 0.0,
    this.mcap = 0.0,
    this.multiplier = 0,
    this.netProfitMargin = 0.0,
    this.pPerchange = 0.0,
    this.pb = 0.0,
    this.pchange = 0.0,
    this.pe = 0.0,
    this.pricePerchng1mon = 0.0,
    this.pricePerchng1year = 0.0,
    this.pricePerchng3mon = 0.0,
    this.pricePerchng3year = 0.0,
    this.pricePerchng5year = 0.0,
    this.roce = 0.0,
    this.revenue = 0.0,
    this.roe = 0.0,
    this.seg = '',
    this.seosym = '',
    this.sid = 0,
    this.sym = '',
    this.tickSize = 0.0,
    this.volume = 0,
    this.year1RevenueGrowth = 0.0,
    this.yoyLastQtrlyProfitGrowth = 0.0,
    this.sector = '',
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  factory SectorThemeModel.fromJson(Map<String, dynamic> json) {
    return SectorThemeModel(
      dayRSI14CurrentCandle: (json['DayRSI14CurrentCandle'] as num?)?.toDouble() ?? 0.0,
      daySMA200CurrentCandle: (json['DaySMA200CurrentCandle'] as num?)?.toDouble() ?? 0.0,
      daySMA50CurrentCandle: (json['DaySMA50CurrentCandle'] as num?)?.toDouble() ?? 0.0,
      dispSym: json['DispSym'] as String? ?? '',
      divYield: (json['DivYeild'] as num?)?.toDouble() ?? 0.0,
      eps: (json['Eps'] as num?)?.toDouble() ?? 0.0,
      exch: json['Exch'] as String? ?? '',
      high1Yr: (json['High1Yr'] as num?)?.toDouble() ?? 0.0,
      indPe: (json['Ind_Pe'] as num?)?.toDouble() ?? 0.0,
      inst: json['Inst'] as String? ?? '',
      isin: json['Isin'] as String? ?? '',
      lotSize: json['LotSize'] as int? ?? 0,
      low1Yr: (json['Low1Yr'] as num?)?.toDouble() ?? 0.0,
      ltp: (json['Ltp'] as num?)?.toDouble() ?? 0.0,
      mcap: (json['Mcap'] as num?)?.toDouble() ?? 0.0,
      multiplier: json['Multiplier'] as int? ?? 0,
      netProfitMargin: (json['NetProfitMargin'] as num?)?.toDouble() ?? 0.0,
      pPerchange: (json['PPerchange'] as num?)?.toDouble() ?? 0.0,
      pb: (json['Pb'] as num?)?.toDouble() ?? 0.0,
      pchange: (json['Pchange'] as num?)?.toDouble() ?? 0.0,
      pe: (json['Pe'] as num?)?.toDouble() ?? 0.0,
      pricePerchng1mon: (json['PricePerchng1mon'] as num?)?.toDouble() ?? 0.0,
      pricePerchng1year: (json['PricePerchng1year'] as num?)?.toDouble() ?? 0.0,
      pricePerchng3mon: (json['PricePerchng3mon'] as num?)?.toDouble() ?? 0.0,
      pricePerchng3year: (json['PricePerchng3year'] as num?)?.toDouble() ?? 0.0,
      pricePerchng5year: (json['PricePerchng5year'] as num?)?.toDouble() ?? 0.0,
      roce: (json['ROCE'] as num?)?.toDouble() ?? 0.0,
      revenue: (json['Revenue'] as num?)?.toDouble() ?? 0.0,
      roe: (json['Roe'] as num?)?.toDouble() ?? 0.0,
      seg: json['Seg'] as String? ?? '',
      seosym: json['Seosym'] as String? ?? '',
      sid: json['Sid'] as int? ?? 0,
      sym: json['Sym'] as String? ?? '',
      tickSize: (json['TickSize'] as num?)?.toDouble() ?? 0.0,
      volume: json['Volume'] as int? ?? 0,
      year1RevenueGrowth: (json['Year1RevenueGrowth'] as num?)?.toDouble() ?? 0.0,
      yoyLastQtrlyProfitGrowth: (json['YoYLastQtrlyProfitGrowth'] as num?)?.toDouble() ?? 0.0,
      sector: json['sector'] as String? ?? '',
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : DateTime.now(),
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'DayRSI14CurrentCandle': dayRSI14CurrentCandle,
      'DaySMA200CurrentCandle': daySMA200CurrentCandle,
      'DaySMA50CurrentCandle': daySMA50CurrentCandle,
      'DispSym': dispSym,
      'DivYeild': divYield,
      'Eps': eps,
      'Exch': exch,
      'High1Yr': high1Yr,
      'Ind_Pe': indPe,
      'Inst': inst,
      'Isin': isin,
      'LotSize': lotSize,
      'Low1Yr': low1Yr,
      'Ltp': ltp,
      'Mcap': mcap,
      'Multiplier': multiplier,
      'NetProfitMargin': netProfitMargin,
      'PPerchange': pPerchange,
      'Pb': pb,
      'Pchange': pchange,
      'Pe': pe,
      'PricePerchng1mon': pricePerchng1mon,
      'PricePerchng1year': pricePerchng1year,
      'PricePerchng3mon': pricePerchng3mon,
      'PricePerchng3year': pricePerchng3year,
      'PricePerchng5year': pricePerchng5year,
      'ROCE': roce,
      'Revenue': revenue,
      'Roe': roe,
      'Seg': seg,
      'Seosym': seosym,
      'Sid': sid,
      'Sym': sym,
      'TickSize': tickSize,
      'Volume': volume,
      'Year1RevenueGrowth': year1RevenueGrowth,
      'YoYLastQtrlyProfitGrowth': yoyLastQtrlyProfitGrowth,
      'sector': sector,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}