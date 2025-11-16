// lib/widgets/food_card.dart
import 'package:flutter/material.dart';
import '../models.dart';
import 'package:intl/intl.dart';

class FoodCard extends StatelessWidget {
  final FoodItem item;
  final VoidCallback? onTap;
  const FoodCard({Key? key, required this.item, this.onTap}) : super(key: key);

  Color statusColor(String s) {
    if (s == 'Expired') return Colors.red.shade700;
    if (s == 'Use Soon') return Colors.orange.shade700;
    return Colors.green.shade700;
  }

  Color statusBgColor(String s) {
    if (s == 'Expired') return Colors.red.shade50;
    if (s == 'Use Soon') return Colors.orange.shade50;
    return Colors.green.shade50;
  }

  IconData _getDonorIcon(DonorType type) {
    switch (type) {
      case DonorType.household:
        return Icons.home;
      case DonorType.restaurant:
        return Icons.restaurant;
      default:
        return Icons.fastfood;
    }
  }

  IconData _getPickupIcon(String option) {
    if (option == 'NGO') return Icons.business;
    if (option == 'Fridge') return Icons.kitchen;
    return Icons.volunteer_activism;
  }

  @override
  Widget build(BuildContext context) {
    final df = DateFormat('MMM dd, yyyy');
    final daysUntilExpiry = item.expiryDate.difference(DateTime.now()).inDays;
    
    return Container(
      margin: EdgeInsets.symmetric(vertical: 6, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    // Food Icon
                    Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.fastfood,
                        color: Colors.green.shade700,
                        size: 28,
                      ),
                    ),
                    SizedBox(width: 16),
                    // Food Details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.name,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey.shade800,
                            ),
                          ),
                          SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(
                                _getDonorIcon(item.donorType),
                                size: 14,
                                color: Colors.grey.shade600,
                              ),
                              SizedBox(width: 4),
                              Text(
                                item.donorType.toString().split('.').last.toUpperCase(),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Status Badge
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: statusBgColor(item.status),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: statusColor(item.status).withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        item.status,
                        style: TextStyle(
                          color: statusColor(item.status),
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                // Divider
                Container(
                  height: 1,
                  color: Colors.grey.shade100,
                ),
                SizedBox(height: 12),
                // Info Row
                Row(
                  children: [
                    // Quantity
                    Expanded(
                      child: _buildInfoChip(
                        icon: Icons.inventory_2_outlined,
                        label: 'Quantity',
                        value: '${item.quantity}',
                        color: Colors.blue.shade700,
                      ),
                    ),
                    SizedBox(width: 8),
                    // Expiry
                    Expanded(
                      flex: 2,
                      child: _buildInfoChip(
                        icon: Icons.event,
                        label: 'Expires',
                        value: daysUntilExpiry > 0 
                            ? 'in $daysUntilExpiry days' 
                            : daysUntilExpiry == 0 
                                ? 'Today' 
                                : 'Expired',
                        color: statusColor(item.status),
                      ),
                    ),
                    SizedBox(width: 8),
                    // Pickup
                    Expanded(
                      child: _buildInfoChip(
                        icon: _getPickupIcon(item.pickupOption),
                        label: 'Pickup',
                        value: item.pickupOption,
                        color: Colors.purple.shade700,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                // Action Button
                SizedBox(
                  width: double.infinity,
                  height: 44,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade700,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    onPressed: onTap,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.location_on, size: 18),
                        SizedBox(width: 8),
                        Text(
                          'View Location',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: color),
          SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: color,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }
}