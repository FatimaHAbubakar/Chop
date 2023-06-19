import 'package:equatable/equatable.dart';

class Review extends Equatable {
  final int id;
  final int star;
  final String? description;
  final int vendorId;
  final int fiiId;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const Review(this.id, this.star, this.description, this.vendorId, this.fiiId,
      this.createdAt, this.updatedAt);

  @override
  List<Object?> get props =>
      [id, star, description, vendorId, fiiId, createdAt, updatedAt];

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      json['id'] as int,
      json['star'] as int,
      json['description'] as String?,
      json['vendor_id'] as int,
      json['fii_id'] as int,
      DateTime.parse(json['createdAt'] as String),
      DateTime.parse(json['updatedAt'] as String),
    );
  }
}
