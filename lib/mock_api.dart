// lib/mock_api.dart
import 'package:latlong2/latlong.dart';
import 'models.dart';
import 'package:uuid/uuid.dart';

final _uuid = Uuid();

class MockApi {
  // In-memory lists simulating a backend
  static final List<FoodItem> _foodItems = [
    FoodItem(
      id: _uuid.v4(),
      name: 'Box of Sandwiches',
      photoUrl: '',
      expiryDate: DateTime.now().add(Duration(days: 1)),
      status: 'Use Soon',
      location: LatLng(3.1390, 101.6869), // KL center
      quantity: 10,
      donorType: DonorType.restaurant,
      pickupOption: 'NGO',
    ),
    FoodItem(
      id: _uuid.v4(),
      name: 'Bakery Day-Old Bread',
      photoUrl: '',
      expiryDate: DateTime.now().add(Duration(hours: 8)),
      status: 'Use Soon',
      location: LatLng(3.1420, 101.6900),
      quantity: 30,
      donorType: DonorType.restaurant,
      pickupOption: 'Volunteer',
    ),
  ];

  static final List<ExpiryItem> _expiryItems = [];

  static final List<VolunteerTask> _tasks = [];

  // Food listing
  static Future<List<FoodItem>> getFoodListings() async {
    await Future.delayed(Duration(milliseconds: 300));
    return _foodItems;
  }

  static Future<FoodItem> addFoodListing({
    required String name,
    required DateTime expiryDate,
    required LatLng location,
    required int quantity,
    required DonorType donorType,
    required String pickupOption,
    String photoUrl = '',
  }) async {
    final item = FoodItem(
      id: _uuid.v4(),
      name: name,
      photoUrl: photoUrl,
      expiryDate: expiryDate,
      status: computeStatus(expiryDate),
      location: location,
      quantity: quantity,
      donorType: donorType,
      pickupOption: pickupOption,
    );
    _foodItems.add(item);
    return item;
  }

  static String computeStatus(DateTime expiry) {
    final days = expiry.difference(DateTime.now()).inDays;
    if (days < 0) return 'Expired';
    if (days <= 1) return 'Use Soon';
    return 'Fresh';
  }

  // Expiry tracker
  static Future<List<ExpiryItem>> getExpiryItems() async {
    await Future.delayed(Duration(milliseconds: 200));
    return _expiryItems;
  }

  static Future<ExpiryItem> addExpiryItem({
    required String name,
    required DateTime expiryDate,
    String imageUrl = '',
  }) async {
    final it = ExpiryItem(
      id: _uuid.v4(),
      name: name,
      expiryDate: expiryDate,
      imageUrl: imageUrl,
    );
    _expiryItems.add(it);
    return it;
  }

  // Mock OCR scanner - returns a date string as DateTime
  static Future<DateTime> mockScanExpiryOCR() async {
    await Future.delayed(Duration(milliseconds: 500));
    // returns a date 3 days from now
    return DateTime.now().add(Duration(days: 3));
  }

  // Volunteer tasks
  static Future<List<VolunteerTask>> getVolunteerTasks() async {
    await Future.delayed(Duration(milliseconds: 200));
    // generate tasks from food items
    if (_tasks.isEmpty) {
      for (var f in _foodItems) {
        _tasks.add(VolunteerTask(
          id: _uuid.v4(),
          foodId: f.id,
          pickupLocation: f.location,
          dropoffLocation: LatLng(3.1370, 101.6860),
          distanceKm: 1.2,
        ));
      }
    }
    return _tasks;
  }

  static Future<VolunteerTask> assignVolunteer(String taskId, String volunteerName) async {
    final task = _tasks.firstWhere((t) => t.id == taskId);
    task.assignedVolunteer = volunteerName;
    task.status = 'Assigned';
    await Future.delayed(Duration(milliseconds: 200));
    return task;
  }

  static Future<void> completeTask(String taskId) async {
    final task = _tasks.firstWhere((t) => t.id == taskId);
    task.status = 'Completed';
    await Future.delayed(Duration(milliseconds: 200));
  }
}
