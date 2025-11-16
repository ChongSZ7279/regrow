// lib/models.dart
import 'package:latlong2/latlong.dart';

enum DonorType { household, restaurant }

class FoodItem {
  final String id;
  final String name;
  final String photoUrl;
  final DateTime expiryDate;
  final String status; // "Fresh", "Use Soon", "Expired"
  final LatLng location;
  final int quantity;
  final DonorType donorType;
  final String pickupOption; // "NGO", "Fridge", "Volunteer"

  FoodItem({
    required this.id,
    required this.name,
    required this.photoUrl,
    required this.expiryDate,
    required this.status,
    required this.location,
    required this.quantity,
    required this.donorType,
    required this.pickupOption,
  });

  int daysLeft() => expiryDate.difference(DateTime.now()).inDays;
}

class ExpiryItem {
  final String id;
  final String name;
  final DateTime expiryDate;
  final String imageUrl;

  ExpiryItem({
    required this.id,
    required this.name,
    required this.expiryDate,
    required this.imageUrl,
  });

  int daysLeft() => expiryDate.difference(DateTime.now()).inDays;
}

class VolunteerTask {
  final String id;
  final String foodId;
  final LatLng pickupLocation;
  final LatLng dropoffLocation;
  final double distanceKm;
  String? assignedVolunteer;
  String status; // Pending, Assigned, Completed

  VolunteerTask({
    required this.id,
    required this.foodId,
    required this.pickupLocation,
    required this.dropoffLocation,
    required this.distanceKm,
    this.assignedVolunteer,
    this.status = 'Pending',
  });
}
