import 'package:equatable/equatable.dart';

class Notification extends Equatable {
  final int id;
  final String message;
  final int inventoryId;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Notification(
      this.id, this.message, this.inventoryId, this.createdAt, this.updatedAt);

  @override
  List<Object?> get props => [id, message, inventoryId, createdAt, updatedAt];

  factory Notification.fromJson(Map<String, dynamic> json) {
    return Notification(
      json['id'] as int,
      json['message'] as String,
      json['inventory_id'] as int,
      DateTime.parse(json['createdAt'] as String),
      DateTime.parse(json['updatedAt'] as String),
    );
  }
}
