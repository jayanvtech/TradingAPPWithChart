class Comment {
  final int messageId;
  final int ticketId;
  final String comment;
  final String commentBy;
  final String createdBy;
  final String updatedBy;
  final DateTime createdAt;
  final DateTime updatedAt;

  Comment({
    required this.messageId,
    required this.ticketId,
    required this.comment,
    required this.commentBy,
    required this.createdBy,
    required this.updatedBy,
    required this.createdAt,
    required this.updatedAt,
  });

  // Factory constructor to create a Comment from JSON
  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      messageId: json['message_id'],
      ticketId: json['ticket_id'],
      comment: json['comment'],
      commentBy: json['comment_by'],
      createdBy: json['created_by'],
      updatedBy: json['updated_by'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  // Method to convert the Comment object to JSON
  Map<String, dynamic> toJson() {
    return {
      'message_id': messageId,
      'ticket_id': ticketId,
      'comment': comment,
      'comment_by': commentBy,
      'created_by': createdBy,
      'updated_by': updatedBy,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

class CommentResponse {
  final bool success;
  final String message;
  final List<Comment> data;

  CommentResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  // Factory constructor to create CommentResponse from JSON
  factory CommentResponse.fromJson(Map<String, dynamic> json) {
    return CommentResponse(
      success: json['success'],
      message: json['message'],
      data: List<Comment>.from(json['data'].map((x) => Comment.fromJson(x))),
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
