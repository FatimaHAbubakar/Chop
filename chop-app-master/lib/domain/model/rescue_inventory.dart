import 'package:chop/domain/model/inventory.dart';
import 'package:chop/domain/model/rescue.dart';
import 'package:chop/domain/model/user.dart';
import 'package:equatable/equatable.dart';

class RescueInventory extends Equatable {
  final int id;
  final Rescue rescue;
  final Inventory inventory;
  final int quantity;

  const RescueInventory(this.id, this.rescue, this.inventory, this.quantity);

  @override
  List<Object?> get props => [id, rescue, inventory, quantity];

  factory RescueInventory.fromJson(
    Map<String, dynamic> json, {
    Map<String, dynamic>? rescueJson,
    Inventory? inventory,
    User? fii,
    User? vendor,
  }) {
    return RescueInventory(
      json['id'] as int,
      rescueJson == null
          ? Rescue.fromJson(
              json['Rescue'],
              json['total'] is double
                  ? json['total']
                  : (json['total'] as int).toDouble(),
              fii,
              vendor)
          : Rescue.fromJson(rescueJson, json['total'], fii, vendor),
      inventory ?? Inventory.fromJson(json['Inventory']),
      json['quantity'] as int,
    );
  }
}
