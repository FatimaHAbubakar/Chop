import 'package:equatable/equatable.dart';

class User extends Equatable {
  final int id;
  final String email;
  final String name;
  final String? location;
  final String? address;
  final String phone;
  final String role;

  const User(this.id, this.email, this.name, this.location, this.address,
      this.phone, this.role);

  @override
  List<Object?> get props => [id, email, name, location, address, phone, role];

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      json['id'] as int,
      json['email'] as String,
      json['name'] as String,
      json['location'] as String?,
      json['address'] as String?,
      json['phone'] as String,
      json['role'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['email'] = email;
    data['name'] = name;
    data['location'] = location;
    data['address'] = address;
    data['phone'] = phone;
    data['role'] = role;
    return data;
  }
}
