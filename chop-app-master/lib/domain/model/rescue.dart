import 'package:chop/domain/model/user.dart';
import 'package:equatable/equatable.dart';

class Rescue extends Equatable {
  final int id;
  final String code;
  final String status;
  final User fii;
  final User vendor;
  final double total;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const Rescue(this.id, this.code, this.status, this.fii, this.vendor,
      this.total, this.createdAt, this.updatedAt);

  @override
  List<Object?> get props =>
      [id, code, status, fii, vendor, createdAt, updatedAt];

  factory Rescue.fromJson(Map<String, dynamic> json, double total,
      [User? fii, User? vendor]) {
    return Rescue(
      json['id'] as int,
      json['code'] as String,
      json['status'] as String,
      json['FII'] == null ? fii! : User.fromJson(json['FII']),
      json['Vendor'] == null ? vendor! : User.fromJson(json['Vendor']),
      total,
      DateTime.parse(json['createdAt'] as String),
      DateTime.parse(json['updatedAt'] as String),
    );
  }
}
