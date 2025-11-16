// lib/providers/regrow_provider.dart
import 'package:flutter/material.dart';
import '../models.dart';
import '../mock_api.dart';
import 'package:latlong2/latlong.dart';

class RegrowProvider extends ChangeNotifier {
  List<FoodItem> foodItems = [];
  List<ExpiryItem> expiryItems = [];
  List<VolunteerTask> tasks = [];

  bool loading = false;

  Future<void> loadAll() async {
    loading = true;
    notifyListeners();
    foodItems = await MockApi.getFoodListings();
    expiryItems = await MockApi.getExpiryItems();
    tasks = await MockApi.getVolunteerTasks();
    loading = false;
    notifyListeners();
  }

  Future<void> addFood({
    required String name,
    required DateTime expiryDate,
    required LatLng location,
    required int quantity,
    required DonorType donorType,
    required String pickupOption,
  }) async {
    loading = true;
    notifyListeners();
    final it = await MockApi.addFoodListing(
      name: name,
      expiryDate: expiryDate,
      location: location,
      quantity: quantity,
      donorType: donorType,
      pickupOption: pickupOption,
    );
    foodItems.add(it);
    tasks = await MockApi.getVolunteerTasks();
    loading = false;
    notifyListeners();
  }

  Future<void> addExpiryItem({required String name, required DateTime expiryDate}) async {
    final it = await MockApi.addExpiryItem(name: name, expiryDate: expiryDate);
    expiryItems.add(it);
    notifyListeners();
  }

  Future<DateTime> scanExpiry() async {
    return MockApi.mockScanExpiryOCR();
  }

  Future<void> assignVolunteer(String taskId, String volunteerName) async {
    final t = await MockApi.assignVolunteer(taskId, volunteerName);
    tasks = await MockApi.getVolunteerTasks();
    notifyListeners();
  }

  Future<void> completeTask(String taskId) async {
    await MockApi.completeTask(taskId);
    tasks = await MockApi.getVolunteerTasks();
    notifyListeners();
  }
}
