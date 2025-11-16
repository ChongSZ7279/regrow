// lib/screens/profile_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/regrow_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<RegrowProvider>(context);
    
    // Calculate statistics
    final totalDonated = prov.foodItems.length;
    final completedTasks = prov.tasks.where((t) => t.status == 'Completed').length;
    final kgSaved = totalDonated * 2;
    final co2Reduced = (kgSaved * 2.5).toInt(); // Approximate CO2 saved

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: CustomScrollView(
        slivers: [
          _buildAppBar(),
          SliverToBoxAdapter(
            child: Column(
              children: [
                _buildProfileHeader(),
                SizedBox(height: 16),
                _buildImpactStats(totalDonated, completedTasks, kgSaved, co2Reduced),
                SizedBox(height: 16),
                _buildAchievementsSection(completedTasks),
                SizedBox(height: 16),
                _buildSettingsSection(),
                SizedBox(height: 32),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 120,
      floating: false,
      pinned: true,
      backgroundColor: Colors.green.shade700,
      flexibleSpace: FlexibleSpaceBar(
        title: Text('Profile', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
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
                child: Icon(Icons.person, size: 140, color: Colors.white.withOpacity(0.1)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.green.shade100,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.green.shade700, width: 3),
            ),
            child: Icon(
              Icons.person,
              size: 50,
              color: Colors.green.shade700,
            ),
          ),
          SizedBox(height: 16),
          Text(
            'Eco Warrior',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade800,
            ),
          ),
          SizedBox(height: 4),
          Text(
            'chong.zhen@graduate.utm.my',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
          SizedBox(height: 16),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.green.shade700),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.eco, size: 16, color: Colors.green.shade700),
                SizedBox(width: 6),
                Text(
                  'Active Contributor',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Colors.green.shade700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImpactStats(int donated, int tasks, int kgSaved, int co2) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Your Impact',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade800,
            ),
          ),
          SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildImpactCard(
                  icon: Icons.restaurant,
                  label: 'Food Donated',
                  value: donated.toString(),
                  color: Colors.green.shade700,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _buildImpactCard(
                  icon: Icons.check_circle,
                  label: 'Tasks Done',
                  value: tasks.toString(),
                  color: Colors.blue.shade700,
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildImpactCard(
                  icon: Icons.scale,
                  label: 'Food Saved',
                  value: '$kgSaved kg',
                  color: Colors.orange.shade700,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _buildImpactCard(
                  icon: Icons.cloud,
                  label: 'CO₂ Reduced',
                  value: '$co2 kg',
                  color: Colors.purple.shade700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildImpactCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.all(16),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementsSection(int completedTasks) {
    final achievements = [
      {
        'title': 'First Donation',
        'icon': Icons.stars,
        'unlocked': completedTasks >= 1,
        'color': Colors.yellow.shade700,
      },
      {
        'title': 'Helper',
        'icon': Icons.volunteer_activism,
        'unlocked': completedTasks >= 5,
        'color': Colors.blue.shade700,
      },
      {
        'title': 'Eco Champion',
        'icon': Icons.eco,
        'unlocked': completedTasks >= 10,
        'color': Colors.green.shade700,
      },
      {
        'title': 'Legend',
        'icon': Icons.emoji_events,
        'unlocked': completedTasks >= 20,
        'color': Colors.orange.shade700,
      },
    ];

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Achievements',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade800,
            ),
          ),
          SizedBox(height: 12),
          Container(
            padding: EdgeInsets.all(16),
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: achievements.map((achievement) {
                final unlocked = achievement['unlocked'] as bool;
                final color = achievement['color'] as Color;
                return Column(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: unlocked ? color.withOpacity(0.1) : Colors.grey.shade100,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: unlocked ? color : Colors.grey.shade300,
                          width: 2,
                        ),
                      ),
                      child: Icon(
                        achievement['icon'] as IconData,
                        color: unlocked ? color : Colors.grey.shade400,
                        size: 28,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      achievement['title'] as String,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: unlocked ? FontWeight.bold : FontWeight.normal,
                        color: unlocked ? Colors.grey.shade800 : Colors.grey.shade400,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsSection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Settings',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade800,
            ),
          ),
          SizedBox(height: 12),
          Container(
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
            child: Column(
              children: [
                _buildSettingsTile(
                  icon: Icons.edit,
                  title: 'Edit Profile',
                  color: Colors.blue.shade700,
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Edit profile coming soon!'),
                        backgroundColor: Colors.blue.shade700,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        margin: EdgeInsets.all(16),
                      ),
                    );
                  },
                ),
                Divider(height: 1, indent: 60),
                _buildSettingsTile(
                  icon: Icons.notifications,
                  title: 'Notifications',
                  color: Colors.orange.shade700,
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Notification settings coming soon!'),
                        backgroundColor: Colors.orange.shade700,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        margin: EdgeInsets.all(16),
                      ),
                    );
                  },
                ),
                Divider(height: 1, indent: 60),
                _buildSettingsTile(
                  icon: Icons.help_outline,
                  title: 'Help & Support',
                  color: Colors.purple.shade700,
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Help & Support coming soon!'),
                        backgroundColor: Colors.purple.shade700,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        margin: EdgeInsets.all(16),
                      ),
                    );
                  },
                ),
                Divider(height: 1, indent: 60),
                _buildSettingsTile(
                  icon: Icons.info_outline,
                  title: 'About ReGrow',
                  color: Colors.green.shade700,
                  onTap: () {
                    showAboutDialog(
                      context: context,
                      applicationName: 'ReGrow',
                      applicationVersion: '1.0.0',
                      applicationIcon: Icon(Icons.eco, size: 48, color: Colors.green.shade700),
                      children: [
                        Text('Creating solutions for sustainability and climate action'),
                        SizedBox(height: 8),
                        Text('Developed for AETHRA GLOBAL IDEATHON 2025'),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: color, size: 24),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.grey.shade800,
        ),
      ),
      trailing: Icon(Icons.chevron_right, color: Colors.grey.shade400),
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    );
  }
}