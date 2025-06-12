// ===================================================================
// * DASHBOARD SCREEN MODULE
// * Purpose: Main app screen after successful authentication
// * Features: User profile display, farm overview, quick actions
// * Security Level: MEDIUM - Displays user data
// ===================================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/theme/colors.dart';
import '../login/models/user_profile.dart';

/// * DASHBOARD SCREEN WIDGET
/// * Main screen after successful login
/// * Displays user profile and farm information
class DashboardScreen extends StatefulWidget {
  final UserProfile userProfile;

  const DashboardScreen({super.key, required this.userProfile});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    _setStatusBar();
  }

  void _setStatusBar() {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: CropFreshColors.green30Primary,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.height < 700;

    return Scaffold(
      backgroundColor: CropFreshColors.surface60Primary,
      body: CustomScrollView(
        slivers: [
          // * App bar with user greeting
          _buildSliverAppBar(isSmallScreen),

          // * Dashboard content
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(isSmallScreen ? 16.0 : 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // * User profile card
                  _buildProfileCard(isSmallScreen),

                  SizedBox(height: isSmallScreen ? 16 : 24),

                  // * Farm details card
                  _buildFarmDetailsCard(isSmallScreen),

                  SizedBox(height: isSmallScreen ? 16 : 24),

                  // * Quick actions
                  _buildQuickActions(isSmallScreen),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar(bool isSmallScreen) {
    return SliverAppBar(
      expandedHeight: isSmallScreen ? 150 : 200,
      floating: false,
      pinned: true,
      backgroundColor: CropFreshColors.green30Primary,
      automaticallyImplyLeading: false,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                CropFreshColors.green30Primary,
                CropFreshColors.green30Primary.withValues(alpha: 0.8),
              ],
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.all(isSmallScreen ? 16.0 : 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Welcome back! 👋',
                    style: TextStyle(
                      fontSize: isSmallScreen ? 16 : 18,
                      color: CropFreshColors.onGreen30.withValues(alpha: 0.9),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    widget.userProfile.displayName,
                    style: TextStyle(
                      fontSize: isSmallScreen ? 24 : 28,
                      color: CropFreshColors.onGreen30,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.5,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Farmer ID: ${widget.userProfile.farmerId}',
                    style: TextStyle(
                      fontSize: isSmallScreen ? 12 : 14,
                      color: CropFreshColors.onGreen30.withValues(alpha: 0.8),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.logout, color: CropFreshColors.onGreen30),
          onPressed: _handleLogout,
        ),
      ],
    );
  }

  Widget _buildProfileCard(bool isSmallScreen) {
    return Card(
      color: CropFreshColors.surface,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(isSmallScreen ? 16.0 : 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.person_outline,
                  color: CropFreshColors.green30Primary,
                  size: 20,
                ),
                SizedBox(width: 8),
                Text(
                  'Profile Information',
                  style: TextStyle(
                    fontSize: isSmallScreen ? 16 : 18,
                    fontWeight: FontWeight.w600,
                    color: CropFreshColors.onBackground60,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            _buildInfoRow(
              'Phone Number',
              widget.userProfile.formattedPhoneNumber,
              Icons.phone_outlined,
              isSmallScreen,
            ),
            SizedBox(height: 12),
            _buildInfoRow(
              'Experience Level',
              widget.userProfile.experienceLevelDisplay,
              Icons.trending_up,
              isSmallScreen,
            ),
            if (widget.userProfile.lastLoginTime != null) ...[
              SizedBox(height: 12),
              _buildInfoRow(
                'Last Login',
                _formatDateTime(widget.userProfile.lastLoginTime!),
                Icons.access_time,
                isSmallScreen,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildFarmDetailsCard(bool isSmallScreen) {
    return Card(
      color: CropFreshColors.surface,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(isSmallScreen ? 16.0 : 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.agriculture_outlined,
                  color: CropFreshColors.green30Primary,
                  size: 20,
                ),
                SizedBox(width: 8),
                Text(
                  'Farm Details',
                  style: TextStyle(
                    fontSize: isSmallScreen ? 16 : 18,
                    fontWeight: FontWeight.w600,
                    color: CropFreshColors.onBackground60,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Text(
              'Farm information will be displayed here after completing registration.',
              style: TextStyle(
                fontSize: 14,
                color: CropFreshColors.onBackground60Secondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions(bool isSmallScreen) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: TextStyle(
            fontSize: isSmallScreen ? 18 : 20,
            fontWeight: FontWeight.w600,
            color: CropFreshColors.onBackground60,
          ),
        ),
        SizedBox(height: 16),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.2,
          children: [
            _buildActionCard(
              'Weather',
              Icons.wb_sunny_outlined,
              'Check weather forecast',
              isSmallScreen,
              () => _showComingSoon('Weather'),
            ),
            _buildActionCard(
              'Market Prices',
              Icons.trending_up,
              'View crop prices',
              isSmallScreen,
              () => _showComingSoon('Market Prices'),
            ),
            _buildActionCard(
              'Crop Advisory',
              Icons.eco_outlined,
              'Get expert advice',
              isSmallScreen,
              () => _showComingSoon('Crop Advisory'),
            ),
            _buildActionCard(
              'Support',
              Icons.support_agent_outlined,
              'Contact support',
              isSmallScreen,
              () => _showComingSoon('Support'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInfoRow(
    String label,
    String value,
    IconData icon,
    bool isSmallScreen,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: CropFreshColors.onBackground60Secondary),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: isSmallScreen ? 12 : 14,
                  color: CropFreshColors.onBackground60Secondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  fontSize: isSmallScreen ? 14 : 16,
                  color: CropFreshColors.onBackground60,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionCard(
    String title,
    IconData icon,
    String description,
    bool isSmallScreen,
    VoidCallback onTap,
  ) {
    return Card(
      color: CropFreshColors.surface,
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(isSmallScreen ? 12.0 : 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: isSmallScreen ? 28 : 32,
                color: CropFreshColors.green30Primary,
              ),
              SizedBox(height: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: isSmallScreen ? 14 : 16,
                  fontWeight: FontWeight.w600,
                  color: CropFreshColors.onBackground60,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 4),
              Text(
                description,
                style: TextStyle(
                  fontSize: isSmallScreen ? 10 : 12,
                  color: CropFreshColors.onBackground60Secondary,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes} min ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours} hr ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    }
  }

  void _showComingSoon(String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '$feature coming soon!',
          style: TextStyle(
            color: CropFreshColors.onGreen30,
            fontWeight: FontWeight.w400,
          ),
        ),
        backgroundColor: CropFreshColors.green30Primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _handleLogout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: CropFreshColors.surface,
        title: Text(
          'Logout',
          style: TextStyle(
            color: CropFreshColors.onBackground60,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          'Are you sure you want to logout?',
          style: TextStyle(color: CropFreshColors.onBackground60Secondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: CropFreshColors.onBackground60Secondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(
                context,
              ).pushNamedAndRemoveUntil('/', (route) => false);
            },
            child: Text(
              'Logout',
              style: TextStyle(
                color: CropFreshColors.green30Primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }
}
