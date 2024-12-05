class CreateTicketModel {
  final String categoryId;
  final String subcategory_id;
  final String title;
  final String description;
  final String clientId;
  final String clientEmail;

  CreateTicketModel({
    required this.categoryId,
    required this.subcategory_id,
    required this.title,
    required this.description,
    required this.clientId,
    required this.clientEmail,
  });

  // Factory constructor to create a Ticket from JSON
  factory CreateTicketModel.fromJson(Map<String, dynamic> json) {
    return CreateTicketModel(
      categoryId: json['category_id'] as String,
      subcategory_id: json['subcategory_id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      clientId: json['client_id'] as String,
      clientEmail: json['client_email'] as String,
    );
  }

  // Method to convert Ticket to JSON
  Map<String, dynamic> toJson() {
    return {
      'category_id': categoryId,
      'subcategory_id': subcategory_id,
      'title': title,
      'description': description,
      'client_id': clientId,
      'client_email': clientEmail,
    };
  }
}
