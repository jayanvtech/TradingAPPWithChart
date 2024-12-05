class FetchTicketModel {
  final int ticket_id;
  final int category_id;
  final int subcategory_id;
  final String title;
  final String description;
  final String client_id;
  final String client_email;

  final DateTime createdAt;
  final DateTime updatedAt;

  FetchTicketModel({
    required this.ticket_id,

    required this.category_id,
    required this.subcategory_id,
    required this.title,
    required this.description,
    required this.client_id,
    required this.client_email,

    required this.createdAt,
    required this.updatedAt,
  });

  // Factory constructor to create a Comment from JSON
  factory FetchTicketModel.fromJson(Map<String, dynamic> json) {
    return FetchTicketModel(
      ticket_id: json['ticket_id'],
      category_id: json['category_id'],
      subcategory_id: json['subcategory_id'],
      title: json['title'],
      description: json['description'],
      client_id: json['client_id'],
      client_email: json['client_email'],

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
      'title': title,
      'description': description,
      'client_id': client_id,
      'client_email': client_email,
      
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
