class AccountProfile {
 String status;
 String message;
 Data data;


 AccountProfile({required this.status, required this.message, required this.data});


 factory AccountProfile.fromJson(Map<String, dynamic> json) {
   return AccountProfile(
     status: json['status'],
     message: json['message'],
     data: Data.fromJson(json['data']),
   );
 }
}


class Data {
 PersonalDetails personalDetails;
 DpDetails dpDetails;
 NomineeDetails nomineeDetails;
 CloseAccount closeAccount;
 String modificationEmailStatus;
 String modificationMobileStatus;
 String modificationSegmentStatus;
 String modificationBankStatus;
 String modificationNomineeStatus;
 String modificationIncomeStatus;


 Data({
   required this.personalDetails,
   required this.dpDetails,
   required this.nomineeDetails,
   required this.closeAccount,
   required this.modificationEmailStatus,
   required this.modificationMobileStatus,
   required this.modificationSegmentStatus,
   required this.modificationBankStatus,
   required this.modificationNomineeStatus,
   required this.modificationIncomeStatus,
 });


 factory Data.fromJson(Map<String, dynamic> json) {
   return Data(
     personalDetails: PersonalDetails.fromJson(json['personal_details']),
     dpDetails: DpDetails.fromJson(json['dp_details']),
     nomineeDetails: NomineeDetails.fromJson(json['nominee_details']),
     closeAccount: CloseAccount.fromJson(json['close_account']),
     modificationEmailStatus: json['modification_email_status'],
     modificationMobileStatus: json['modification_mobile_status'],
     modificationSegmentStatus: json['modification_segment_status'],
     modificationBankStatus: json['modification_bank_status'],
     modificationNomineeStatus: json['modification_nominee_status'],
     modificationIncomeStatus: json['modification_income_status'],
   );
 }
}


class PersonalDetails {
 String assClientId;
 String clientDpCode;
 String clientDpName;
 String fatherHusbandName;
 String panNo;
 String birthDate;
 String mobileNo;
 String clientIdMail;
 String categoryDesc;
 String sex;
 String clResiAdd1;
 String clResiAdd2;
 String clResiAdd3;
 String annualIncome;
 String guardianName;


 PersonalDetails({
   required this.assClientId,
   required this.clientDpCode,
   required this.clientDpName,
   required this.fatherHusbandName,
   required this.panNo,
   required this.birthDate,
   required this.mobileNo,
   required this.clientIdMail,
   required this.categoryDesc,
   required this.sex,
   required this.clResiAdd1,
   required this.clResiAdd2,
   required this.clResiAdd3,
   required this.annualIncome,
   required this.guardianName,
 });


 factory PersonalDetails.fromJson(Map<String, dynamic> json) {
   return PersonalDetails(
     assClientId: json['ass_client_id'],
     clientDpCode: json['client_dp_code'],
     clientDpName: json['client_dp_name'],
     fatherHusbandName: json['father_husband_name'],
     panNo: json['pan_no'],
     birthDate: json['birth_date'],
     mobileNo: json['mobile_no'],
     clientIdMail: json['client_id_mail'],
     categoryDesc: json['category_desc'],
     sex: json['sex'],
     clResiAdd1: json['cl_resi_add1'],
     clResiAdd2: json['cl_resi_add2'],
     clResiAdd3: json['cl_resi_add3'],
     annualIncome: json['annual_income'],
     guardianName: json['guardian_name'],
   );
 }
}


class DpDetails {
 String depository;
 String clientDpCode;
 String clientDpName;
 Map<String, String> companyCode;
 String activateSegment;
 int age;


 DpDetails({
   required this.depository,
   required this.clientDpCode,
   required this.clientDpName,
   required this.companyCode,
   required this.activateSegment,
   required this.age,
 });


 factory DpDetails.fromJson(Map<String, dynamic> json) {
   return DpDetails(
     depository: json['depository'],
     clientDpCode: json['client_dp_code'],
     clientDpName: json['client_dp_name'],
     companyCode: Map<String, String>.from(json['company_code']),
     activateSegment: json['activate_segment'],
     age: json['age'],
   );
 }
}


class NomineeDetails {
 String nomineeoptout;
 String nomineeName;


 NomineeDetails({required this.nomineeoptout, required this.nomineeName});


 factory NomineeDetails.fromJson(Map<String, dynamic> json) {
   return NomineeDetails(
     nomineeoptout: json['nomineeoptout'],
     nomineeName: json['nominee_name'],
   );
 }
}


class CloseAccount {
 String assClientId;
 String clientDpCode;
 String clientDpName;
 String panNo;


 CloseAccount({
   required this.assClientId,
   required this.clientDpCode,
   required this.clientDpName,
   required this.panNo,
 });


 factory CloseAccount.fromJson(Map<String, dynamic> json) {
   return CloseAccount(
     assClientId: json['ass_client_id'],
     clientDpCode: json['client_dp_code'],
     clientDpName: json['client_dp_name'],
     panNo: json['pan_no'],
   );
 }
}



