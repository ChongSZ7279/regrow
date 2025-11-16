// lib/widgets/task_card.dart
import 'package:flutter/material.dart';
import '../models.dart';
import 'package:latlong2/latlong.dart';

class TaskCard extends StatelessWidget {
  final VolunteerTask task;
  final VoidCallback? onAccept;
  final VoidCallback? onComplete;
  final String? foodName; // Pass from parent since task only has foodId

  const TaskCard({
    Key? key,
    required this.task,
    this.onAccept,
    this.onComplete,
    this.foodName,
  }) : super(key: key);

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Pending':
        return Colors.orange.shade700;
      case 'Assigned':
        return Colors.blue.shade700;
      case 'Completed':
        return Colors.green.shade700;
      default:
        return Colors.grey.shade700;
    }
  }

  Color _getStatusBgColor(String status) {
    switch (status) {
      case 'Pending':
        return Colors.orange.shade50;
      case 'Assigned':
        return Colors.blue.shade50;
      case 'Completed':
        return Colors.green.shade50;
      default:
        return Colors.grey.shade50;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'Pending':
        return Icons.schedule;
      case 'Assigned':
        return Icons.local_shipping;
      case 'Completed':
        return Icons.check_circle;
      default:
        return Icons.info;
    }
  }

  String _formatLocation(LatLng location) {
    return '${location.latitude.toStringAsFixed(4)}, ${location.longitude.toStringAsFixed(4)}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 6, horizontal: 4),
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
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: _getStatusBgColor(task.status),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    _getStatusIcon(task.status),
                    color: _getStatusColor(task.status),
                    size: 24,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Task #${task.id.substring(0, 8)}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade800,
                        ),
                      ),
                      SizedBox(height: 4),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: _getStatusBgColor(task.status),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: _getStatusColor(task.status).withOpacity(0.3),
                          ),
                        ),
                        child: Text(
                          task.status,
                          style: TextStyle(
                            color: _getStatusColor(task.status),
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Distance Badge
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.purple.shade50,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.purple.shade200),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.route, size: 14, color: Colors.purple.shade700),
                      SizedBox(width: 4),
                      Text(
                        '${task.distanceKm.toStringAsFixed(1)} km',
                        style: TextStyle(
                          color: Colors.purple.shade700,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            
            // Divider
            Container(height: 1, color: Colors.grey.shade100),
            SizedBox(height: 12),
            
            // Task Details
            if (foodName != null) ...[
              _buildDetailRow(
                icon: Icons.fastfood,
                label: 'Food Item',
                value: foodName!,
                color: Colors.green.shade700,
              ),
              SizedBox(height: 10),
            ],
            
            _buildDetailRow(
              icon: Icons.location_on,
              label: 'Pickup Location',
              value: _formatLocation(task.pickupLocation),
              color: Colors.blue.shade700,
            ),
            SizedBox(height: 10),
            _buildDetailRow(
              icon: Icons.place,
              label: 'Drop-off Location',
              value: _formatLocation(task.dropoffLocation),
              color: Colors.purple.shade700,
            ),
            
            if (task.assignedVolunteer != null) ...[
              SizedBox(height: 10),
              _buildDetailRow(
                icon: Icons.person,
                label: 'Assigned Volunteer',
                value: task.assignedVolunteer!,
                color: Colors.orange.shade700,
              ),
            ],
            
            SizedBox(height: 16),
            
            // Action Buttons
            if (onAccept != null || onComplete != null)
              Row(
                children: [
                  if (onAccept != null)
                    Expanded(
                      child: SizedBox(
                        height: 48,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green.shade700,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          onPressed: onAccept,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.check, size: 20),
                              SizedBox(width: 8),
                              Text(
                                'Accept Task',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  if (onComplete != null)
                    Expanded(
                      child: SizedBox(
                        height: 48,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue.shade700,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          onPressed: onComplete,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.check_circle, size: 20),
                              SizedBox(width: 8),
                              Text(
                                'Complete',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 16, color: color),
        ),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade800,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}