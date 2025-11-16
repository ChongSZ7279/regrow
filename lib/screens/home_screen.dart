// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/regrow_provider.dart';
import '../widgets/food_card.dart';
import 'package:latlong2/latlong.dart';
import '../models.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  final _nameCtrl = TextEditingController();
  final _qtyCtrl = TextEditingController(text: '1');
  DateTime? _expiry;
  DonorType _donorType = DonorType.household;
  String _pickupOption = 'Volunteer';
  bool _showAddForm = false;
  late AnimationController _animController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      duration: Duration(milliseconds: 400),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeInOut,
    );
    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutCubic,
    ));
  }

  @override
  void dispose() {
    _animController.dispose();
    _nameCtrl.dispose();
    _qtyCtrl.dispose();
    super.dispose();
  }

  void _toggleForm() {
    setState(() {
      _showAddForm = !_showAddForm;
      if (_showAddForm) {
        _animController.forward();
      } else {
        _animController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<RegrowProvider>(context);
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: prov.loading
          ? Center(child: CircularProgressIndicator(color: Colors.green.shade700))
          : Stack(
              children: [
                RefreshIndicator(
                  color: Colors.green.shade700,
                  onRefresh: prov.loadAll,
                  child: CustomScrollView(
                    slivers: [
                      _buildAppBar(prov),
                      SliverToBoxAdapter(child: _buildStatsCards(prov)),
                      SliverToBoxAdapter(child: SizedBox(height: 8)),
                      _buildSurplusSection(prov),
                      SliverToBoxAdapter(child: SizedBox(height: 100)),
                    ],
                  ),
                ),
                // Add form overlay
                if (_showAddForm)
                  GestureDetector(
                    onTap: _toggleForm,
                    child: Container(
                      color: Colors.black.withOpacity(0.5),
                    ),
                  ),
                if (_showAddForm)
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: GestureDetector(
                        onTap: () {}, // Prevent closing when tapping form
                        child: _buildAddForm(prov),
                      ),
                    ),
                  ),
              ],
            ),
      floatingActionButton: _buildFAB(),
    );
  }

  Widget _buildAppBar(RegrowProvider prov) {
    return SliverAppBar(
      expandedHeight: 120,
      floating: false,
      pinned: true,
      backgroundColor: Colors.green.shade700,
      flexibleSpace: FlexibleSpaceBar(
        title: Text('ReGrow', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
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
                right: -20,
                top: -20,
                child: Icon(Icons.eco, size: 120, color: Colors.white.withOpacity(0.1)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatsCards(RegrowProvider prov) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard(
              icon: Icons.restaurant,
              label: 'Available',
              value: '${prov.foodItems.length}',
              color: Colors.green.shade700,
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              icon: Icons.volunteer_activism,
              label: 'Tasks',
              value: '${prov.tasks.where((t) => t.status == 'Pending').length}',
              color: Colors.orange.shade700,
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              icon: Icons.eco,
              label: 'Saved',
              value: '${prov.foodItems.length * 2}kg',
              color: Colors.blue.shade700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({required IconData icon, required String label, required String value, required Color color}) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
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
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          SizedBox(height: 8),
          Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
          SizedBox(height: 4),
          Text(label, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
        ],
      ),
    );
  }

  Widget _buildSurplusSection(RegrowProvider prov) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          if (index == 0) {
            return Padding(
              padding: EdgeInsets.fromLTRB(20, 16, 20, 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Available Surplus',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.grey.shade800),
                  ),
                  if (prov.foodItems.isNotEmpty)
                    Text(
                      '${prov.foodItems.length} items',
                      style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                    ),
                ],
              ),
            );
          }

          if (prov.foodItems.isEmpty && index == 1) {
            return _buildEmptyState();
          }

          final foodIndex = index - 1;
          if (foodIndex < prov.foodItems.length) {
            return FoodCard(item: prov.foodItems[foodIndex]);
          }

          return SizedBox.shrink();
        },
        childCount: prov.foodItems.isEmpty ? 2 : prov.foodItems.length + 1,
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      margin: EdgeInsets.all(20),
      padding: EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Icon(Icons.inventory_2_outlined, size: 64, color: Colors.grey.shade400),
          SizedBox(height: 16),
          Text(
            'No surplus food yet',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey.shade700),
          ),
          SizedBox(height: 8),
          Text(
            'Tap the + button to list surplus food',
            style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildFAB() {
    return FloatingActionButton.extended(
      onPressed: _toggleForm,
      backgroundColor: Colors.green.shade700,
      icon: Icon(_showAddForm ? Icons.close : Icons.add),
      label: Text(_showAddForm ? 'Cancel' : 'List Surplus'),
    );
  }

  Widget _buildAddForm(RegrowProvider prov) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 20,
            offset: Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'List Surplus Food',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade800,
                    ),
                  ),
                  IconButton(
                    onPressed: _toggleForm,
                    icon: Icon(Icons.close, color: Colors.grey.shade600),
                  ),
                ],
              ),
              SizedBox(height: 20),
              
              _buildTextField(_nameCtrl, 'Food name', Icons.fastfood),
              SizedBox(height: 16),
              
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: _buildTextField(_qtyCtrl, 'Quantity', Icons.production_quantity_limits, isNumber: true),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    flex: 3,
                    child: _buildExpiryButton(),
                  ),
                ],
              ),
              SizedBox(height: 16),
              
              _buildDonorTypeSelector(),
              SizedBox(height: 16),
              
              _buildPickupSelector(),
              SizedBox(height: 24),
              
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade700,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 0,
                  ),
                  onPressed: () => _submitSurplus(prov),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.check_circle, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'List Surplus Food',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController ctrl, String label, IconData icon, {bool isNumber = false}) {
    return TextField(
      controller: ctrl,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      style: TextStyle(fontSize: 16, color: Colors.grey.shade800),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.grey.shade600),
        prefixIcon: Icon(icon, color: Colors.green.shade700),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.green.shade700, width: 2),
        ),
        filled: true,
        fillColor: Colors.grey.shade50,
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
    );
  }

  Widget _buildExpiryButton() {
    return InkWell(
      onTap: () async {
        final d = await showDatePicker(
          context: context,
          initialDate: DateTime.now().add(Duration(days: 1)),
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(Duration(days: 365)),
          builder: (context, child) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: ColorScheme.light(primary: Colors.green.shade700),
              ),
              child: child!,
            );
          },
        );
        if (d != null) setState(() => _expiry = d);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: _expiry == null ? Colors.grey.shade50 : Colors.green.shade50,
          border: Border.all(
            color: _expiry == null ? Colors.grey.shade300 : Colors.green.shade700,
            width: _expiry == null ? 1 : 2,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(
              Icons.calendar_today,
              size: 20,
              color: _expiry == null ? Colors.grey.shade600 : Colors.green.shade700,
            ),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                _expiry == null ? 'Expiry date' : DateFormat.MMMd().format(_expiry!),
                style: TextStyle(
                  color: _expiry == null ? Colors.grey.shade600 : Colors.green.shade700,
                  fontWeight: _expiry == null ? FontWeight.normal : FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDonorTypeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'I am a:',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade800,
          ),
        ),
        SizedBox(height: 12),
        Row(
          children: DonorType.values.map((type) {
            final isSelected = _donorType == type;
            return Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _donorType = type),
                child: Container(
                  margin: EdgeInsets.only(right: type == DonorType.values.last ? 0 : 8),
                  padding: EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.green.shade700 : Colors.white,
                    border: Border.all(
                      color: isSelected ? Colors.green.shade700 : Colors.grey.shade300,
                      width: isSelected ? 2 : 1,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: isSelected ? [
                      BoxShadow(
                        color: Colors.green.shade700.withOpacity(0.2),
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ] : [],
                  ),
                  child: Text(
                    type.toString().split('.').last.toUpperCase(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.grey.shade700,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildPickupSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Pickup by:',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade800,
          ),
        ),
        SizedBox(height: 12),
        Row(
          children: ['Volunteer', 'NGO', 'Fridge'].map((option) {
            final isSelected = _pickupOption == option;
            final isLast = option == 'Fridge';
            return Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _pickupOption = option),
                child: Container(
                  margin: EdgeInsets.only(right: isLast ? 0 : 8),
                  padding: EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.green.shade700 : Colors.white,
                    border: Border.all(
                      color: isSelected ? Colors.green.shade700 : Colors.grey.shade300,
                      width: isSelected ? 2 : 1,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: isSelected ? [
                      BoxShadow(
                        color: Colors.green.shade700.withOpacity(0.2),
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ] : [],
                  ),
                  child: Text(
                    option,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.grey.shade700,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Future<void> _submitSurplus(RegrowProvider prov) async {
    if (_nameCtrl.text.isEmpty || _expiry == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.error_outline, color: Colors.white),
              SizedBox(width: 12),
              Expanded(child: Text('Please fill in food name and expiry date')),
            ],
          ),
          backgroundColor: Colors.red.shade700,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          margin: EdgeInsets.all(16),
        ),
      );
      return;
    }

    await prov.addFood(
      name: _nameCtrl.text,
      expiryDate: _expiry!,
      location: LatLng(3.1390, 101.6869),
      quantity: int.tryParse(_qtyCtrl.text) ?? 1,
      donorType: _donorType,
      pickupOption: _pickupOption,
    );

    _nameCtrl.clear();
    _qtyCtrl.text = '1';
    setState(() {
      _expiry = null;
      _donorType = DonorType.household;
      _pickupOption = 'Volunteer';
    });
    _toggleForm();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 12),
            Expanded(child: Text('Surplus food listed successfully!')),
          ],
        ),
        backgroundColor: Colors.green.shade700,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: EdgeInsets.all(16),
      ),
    );
  }
}