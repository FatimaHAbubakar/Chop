import 'package:equatable/equatable.dart';

class Inventory extends Equatable {
  final int id;
  final String name;
  final String category;
  final int stock;
  final double price;
  final double? discount;
  final int vendorId;
  final bool deleted;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const Inventory(
      this.id,
      this.name,
      this.category,
      this.stock,
      this.price,
      this.discount,
      this.vendorId,
      this.deleted,
      this.createdAt,
      this.updatedAt);

  @override
  List<Object?> get props =>
      [id, name, category, stock, vendorId, deleted, createdAt, updatedAt];

  factory Inventory.fromJson(Map<String, dynamic> json) {
    return Inventory(
      json['id'] as int,
      json['name'] as String,
      json['category'] as String,
      json['stock'] as int,
      json['price'] is int ? (json['price'] as int).toDouble() : json['double'],
      json['discount'],
      json['vendor_id'] as int,
      json['deleted'],
      DateTime.parse(json['createdAt'] as String),
      DateTime.parse(json['updatedAt'] as String),
    );
  }
}
