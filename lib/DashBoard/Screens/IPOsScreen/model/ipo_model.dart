class IpoDetailsResponse {
 final String status;
 final String message;
 final List<IpoDetails> data;


 IpoDetailsResponse({
   required this.status,
   required this.message,
   required this.data,
 });


 factory IpoDetailsResponse.fromJson(Map<String, dynamic> json) {
   return IpoDetailsResponse(
     status: json['status'].toString(),
     message: json['message'].toString(),
     data: List<IpoDetails>.from(json['data'].map((item) => IpoDetails.fromJson(item))),
   );
 }
}


class IpoDetails {
 final String symbol;
 final String ipoType;
 final String name;
 final String minBidQuantity;
 final String lotSize;
 final String minPrice;
 final String cutoffPrice;
 final String isin;
 final String issueSize;
 final String biddingStartDate;
 final String biddingEndDate;
 final String polDiscountPrice;
 final String indDiscountPrice;
 final String shaDiscountPrice;
 final String empDiscountPrice;
 final String bse;
 final String nse;
 final List<String> categories;


 IpoDetails({
   required this.symbol,
   required this.ipoType,
   required this.name,
   required this.minBidQuantity,
   required this.lotSize,
   required this.minPrice,
   required this.cutoffPrice,
   required this.isin,
   required this.issueSize,
   required this.biddingStartDate,
   required this.biddingEndDate,
   required this.polDiscountPrice,
   required this.indDiscountPrice,
   required this.shaDiscountPrice,
   required this.empDiscountPrice,
   required this.bse,
   required this.nse,
   required this.categories,
 });


 factory IpoDetails.fromJson(Map<String, dynamic> json) {
   return IpoDetails(
     symbol: json['symbol'].toString(),
     ipoType: json['ipo_type'].toString(),
     name: json['name'].toString(),
     minBidQuantity: json['minbidquantity'].toString(),
     lotSize: json['lotsize'].toString(),
     minPrice: json['minprice'].toString(),
     cutoffPrice: json['cutoffprice'].toString(),
     isin: json['isin'].toString(),
     issueSize: json['issuesize'].toString(),
     biddingStartDate: json['biddingstartdate'].toString(),
     biddingEndDate: json['biddingenddate'].toString(),
     polDiscountPrice: json['pol_discountprice'].toString(),
     indDiscountPrice: json['ind_discountprice'].toString(),
     shaDiscountPrice: json['sha_discountprice'].toString(),
     empDiscountPrice: json['emp_discountprice'].toString(),
     bse: json['bse'].toString(),
     nse: json['nse'].toString(),
     categories: List<String>.from(json['categories'].map((item) => item.toString())),
   );
 }
}



