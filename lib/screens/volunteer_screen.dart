// lib/screens/volunteer_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/regrow_provider.dart';
import '../widgets/task_card.dart';

class VolunteerScreen extends StatefulWidget {
  const VolunteerScreen({Key? key}) : super(key: key);
  
  @override
  State<VolunteerScreen> createState() => _VolunteerScreenState();
}

class _VolunteerScreenState extends State<VolunteerScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<RegrowProvider>(context);
    
    final pendingTasks = prov.tasks.where((t) => t.status == 'Pending').toList();
    final assignedTasks = prov.tasks.where((t) => t.status == 'Assigned').toList();
    final completedTasks = prov.tasks.where((t) => t.status == 'Completed').toList();

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: prov.loading
          ? Center(child: CircularProgressIndicator(color: Colors.green.shade700))
          : CustomScrollView(
              slivers: [
                _buildAppBar(pendingTasks.length, assignedTasks.length, completedTasks.length),
                SliverToBoxAdapter(child: _buildStatsSection(pendingTasks.length, assignedTasks.length, completedTasks.length)),
                SliverToBoxAdapter(
                  child: Container(
                    color: Colors.white,
                    child: TabBar(
                      controller: _tabController,
                      labelColor: Colors.green.shade700,
                      unselectedLabelColor: Colors.grey.shade600,
                      indicatorColor: Colors.green.shade700,
                      indicatorWeight: 3,
                      tabs: [
                        Tab(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Available'),
                              if (pendingTasks.isNotEmpty) ...[
                                SizedBox(width: 4),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.orange.shade100,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    '${pendingTasks.length}',
                                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.orange.shade700),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                        Tab(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('My Tasks'),
                              if (assignedTasks.isNotEmpty) ...[
                                SizedBox(width: 4),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.blue.shade100,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    '${assignedTasks.length}',
                                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.blue.shade700),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                        Tab(text: 'Completed'),
                      ],
                    ),
                  ),
                ),
                SliverFillRemaining(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildTaskList(pendingTasks, 'available', prov),
                      _buildTaskList(assignedTasks, 'assigned', prov),
                      _buildTaskList(completedTasks, 'completed', prov),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildAppBar(int pending, int assigned, int completed) {
    return SliverAppBar(
      expandedHeight: 120,
      floating: false,
      pinned: true,
      backgroundColor: Colors.green.shade700,
      flexibleSpace: FlexibleSpaceBar(
        title: Text('Volunteer Tasks', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
        titlePadding: EdgeInsets.only(left: 20, bottom: 16),
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.green.shade700, Colors.green.shade500],
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                right: -30,
                top: -30,
                child: Icon(Icons.volunteer_activism, size: 140, color: Colors.white.withOpacity(0.1)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatsSection(int pending, int assigned, int completed) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard(
              icon: Icons.schedule,
              label: 'Available',
              value: pending.toString(),
              color: Colors.orange.shade700,
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              icon: Icons.assignment_turned_in,
              label: 'Active',
              value: assigned.toString(),
              color: Colors.blue.shade700,
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              icon: Icons.check_circle,
              label: 'Completed',
              value: completed.toString(),
              color: Colors.green.shade700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({required IconData icon, required String label, required String value, required Color color}) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          SizedBox(height: 8),
          Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color)),
          Text(label, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
        ],
      ),
    );
  }

  Widget _buildTaskList(List tasks, String type, RegrowProvider prov) {
    if (tasks.isEmpty) {
      return _buildEmptyState(type);
    }

    return RefreshIndicator(
      color: Colors.green.shade700,
      onRefresh: prov.loadAll,
      child: ListView.builder(
        padding: EdgeInsets.all(12),
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          final task = tasks[index];
          return TaskCard(
            task: task,
            onAccept: type == 'available'
                ? () async {
                    await prov.assignVolunteer(task.id, 'You (Volunteer)');
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Row(
                          children: [
                            Icon(Icons.check_circle, color: Colors.white),
                            SizedBox(width: 12),
                            Text('Task accepted successfully!'),
                          ],
                        ),
                        backgroundColor: Colors.green.shade700,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    );
                  }
                : null,
            onComplete: type == 'assigned'
                ? () async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        title: Text('Complete Task?'),
                        content: Text('Mark this task as completed?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: Text('Cancel', style: TextStyle(color: Colors.grey)),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green.shade700,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                            onPressed: () => Navigator.pop(context, true),
                            child: Text('Complete'),
                          ),
                        ],
                      ),
                    );
                    
                    if (confirm == true) {
                      await prov.completeTask(task.id);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Row(
                            children: [
                              Icon(Icons.celebration, color: Colors.white),
                              SizedBox(width: 12),
                              Text('Task completed! Great work! 🎉'),
                            ],
                          ),
                          backgroundColor: Colors.green.shade700,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                      );
                    }
                  }
                : null,
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(String type) {
    String title, subtitle;
    IconData icon;
    
    switch (type) {
      case 'available':
        icon = Icons.assignment_outlined;
        title = 'No available tasks';
        subtitle = 'Check back later for new rescue missions';
        break;
      case 'assigned':
        icon = Icons.task_outlined;
        title = 'No active tasks';
        subtitle = 'Accept tasks from the Available tab';
        break;
      default:
        icon = Icons.celebration_outlined;
        title = 'No completed tasks yet';
        subtitle = 'Complete your first rescue mission!';
    }

    return Center(
      child: Container(
        margin: EdgeInsets.all(32),
        padding: EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 64, color: Colors.grey.shade400),
            SizedBox(height: 16),
            Text(
              title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey.shade700),
            ),
            SizedBox(height: 8),
            Text(
              subtitle,
              style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}