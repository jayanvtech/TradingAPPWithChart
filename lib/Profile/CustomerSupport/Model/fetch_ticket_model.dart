class FetchTicketModel {
  final int ticket_id;
  final int category_id;
  final int subcategory_id;
  final String category_name;
  final String subcategory_name;
  final String title;
  final String description;
  final String client_id;
  final String client_email;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  FetchTicketModel({
    required this.ticket_id,
    required this.category_id,
    required this.subcategory_id,
    required this.category_name,
    required this.subcategory_name,
    required this.title,
    required this.description,
    required this.client_id,
    required this.client_email,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  // Factory constructor to create a Comment from JSON
  factory FetchTicketModel.fromJson(Map<String, dynamic> json) {
    return FetchTicketModel(
      ticket_id: json['ticket_id'],
      category_id: json['category_id'],
      subcategory_id: json['subcategory_id'],
      category_name: json['category_name'],
      subcategory_name: json['subcategory_name'],
      title: json['title'],
      description: json['description'],
      client_id: json['client_id'],
      client_email: json['client_email'],
      status: json['status'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  // Method to convert the Comment object to JSON
  Map<String, dynamic> toJson() {
    return {
      'ticket_id': ticket_id,
      'category_id': category_id,
      'subcategory_id': subcategory_id,
      'category_name': category_name,
      'subcategory_name': subcategory_name,
  
      'title': title,
      'description': description,
      'client_id': client_id,
      'client_email': client_email,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

class FetchTicketModelResponse {
  final bool success;
  final String message;
  final List<FetchTicketModel> data;

  FetchTicketModelResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  // Factory constructor to create CommentResponse from JSON
  factory FetchTicketModelResponse.fromJson(Map<String, dynamic> json) {
    return FetchTicketModelResponse(
      success: json['success'],
      message: json['message'],
      data: List<FetchTicketModel>.from(json['data'].map((x) => FetchTicketModel.fromJson(x))),
    );
  }

  // Method to convert the CommentResponse object to JSON
  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': List<dynamic>.from(data.map((x) => x.toJson())),
    };
  }
}
