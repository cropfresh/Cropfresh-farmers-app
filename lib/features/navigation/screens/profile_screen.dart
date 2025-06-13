// ===================================================================
// * PROFILE SCREEN
// * Purpose: Manage account-related information and settings
// * Features: User profile, settings, help & support, app information
// * State Management: StatefulWidget
// * Security Level: HIGH - Personal information and settings
// ===================================================================

import 'package:flutter/material.dart';
import '../../../core/theme/colors.dart';
import '../../login/models/user_profile.dart';

/// * PROFILE SCREEN
/// * Access to user profile details, settings, help & support
class ProfileScreen extends StatefulWidget {
  final UserProfile userProfile;

  const ProfileScreen({super.key, required this.userProfile});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // ============================================================================
  // * BUILD METHODS
  // ============================================================================

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.height < 700;

    return Scaffold(
      backgroundColor: CropFreshColors.background60Primary,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // * Header with profile info
              _buildProfileHeader(isSmallScreen),

              // * Menu sections
              _buildMenuSections(isSmallScreen),
            ],
          ),
        ),
      ),
    );
  }

  /// * Build profile header section
  Widget _buildProfileHeader(bool isSmallScreen) {
    return Container(
      padding: EdgeInsets.all(isSmallScreen ? 20 : 24),
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
      child: Column(
        children: [
          // * Profile avatar and edit button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Profile',
                style: TextStyle(
                  fontSize: isSmallScreen ? 24 : 28,
                  fontWeight: FontWeight.w600,
                  color: CropFreshColors.onGreen30,
                ),
              ),
              IconButton(
                icon: Icon(Icons.edit, color: CropFreshColors.onGreen30),
                onPressed: _editProfile,
              ),
            ],
          ),

          const SizedBox(height: 24),

          // * Profile picture
          CircleAvatar(
            radius: isSmallScreen ? 40 : 50,
            backgroundColor: CropFreshColors.onGreen30.withValues(alpha: 0.2),
            child: Icon(
              Icons.person,
              size: isSmallScreen ? 40 : 50,
              color: CropFreshColors.onGreen30,
            ),
          ),

          const SizedBox(height: 16),

          // * User name
          Text(
            widget.userProfile.displayName,
            style: TextStyle(
              fontSize: isSmallScreen ? 20 : 24,
              fontWeight: FontWeight.w600,
              color: CropFreshColors.onGreen30,
            ),
          ),

          const SizedBox(height: 8),

          // * Phone number
          Text(
            widget.userProfile.phoneNumber,
            style: TextStyle(
              fontSize: isSmallScreen ? 14 : 16,
              color: CropFreshColors.onGreen30.withValues(alpha: 0.8),
            ),
          ),

          const SizedBox(height: 8),

          // * Farm location
          if (widget.userProfile.formattedAddress.isNotEmpty &&
              widget.userProfile.formattedAddress != 'Address not available')
            Text(
              '📍 ${widget.userProfile.formattedAddress}',
              style: TextStyle(
                fontSize: isSmallScreen ? 14 : 16,
                color: CropFreshColors.onGreen30.withValues(alpha: 0.8),
              ),
            ),
        ],
      ),
    );
  }

  /// * Build menu sections
  Widget _buildMenuSections(bool isSmallScreen) {
    return Padding(
      padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
      child: Column(
        children: [
          // * Account section
          _buildMenuSection(
            title: 'Account',
            items: [
              _MenuItemData(
                icon: Icons.person_outline,
                title: 'Personal Information',
                subtitle: 'Update your profile details',
                onTap: _editProfile,
              ),
              _MenuItemData(
                icon: Icons.agriculture_outlined,
                title: 'Farm Details',
                subtitle: 'Manage your farm information',
                onTap: _editFarmDetails,
              ),
              _MenuItemData(
                icon: Icons.security,
                title: 'Privacy & Security',
                subtitle: 'Manage your account security',
                onTap: _openPrivacySettings,
              ),
            ],
            isSmallScreen: isSmallScreen,
          ),

          const SizedBox(height: 24),

          // * App settings section
          _buildMenuSection(
            title: 'App Settings',
            items: [
              _MenuItemData(
                icon: Icons.language,
                title: 'Language',
                subtitle: 'English',
                onTap: _changeLanguage,
                showArrow: true,
              ),
              _MenuItemData(
                icon: Icons.notifications_outlined,
                title: 'Notifications',
                subtitle: 'Manage notification preferences',
                onTap: _openNotificationSettings,
              ),
              _MenuItemData(
                icon: Icons.dark_mode_outlined,
                title: 'Theme',
                subtitle: 'Light mode',
                onTap: _changeTheme,
                showArrow: true,
              ),
            ],
            isSmallScreen: isSmallScreen,
          ),

          const SizedBox(height: 24),

          // * Help & Support section
          _buildMenuSection(
            title: 'Help & Support',
            items: [
              _MenuItemData(
                icon: Icons.help_outline,
                title: 'Help Center',
                subtitle: 'Get help with using the app',
                onTap: _openHelpCenter,
              ),
              _MenuItemData(
                icon: Icons.contact_support_outlined,
                title: 'Contact Support',
                subtitle: 'Reach out to our support team',
                onTap: _contactSupport,
              ),
              _MenuItemData(
                icon: Icons.feedback_outlined,
                title: 'Send Feedback',
                subtitle: 'Help us improve CropFresh',
                onTap: _sendFeedback,
              ),
            ],
            isSmallScreen: isSmallScreen,
          ),

          const SizedBox(height: 24),

          // * About section
          _buildMenuSection(
            title: 'About',
            items: [
              _MenuItemData(
                icon: Icons.info_outline,
                title: 'App Version',
                subtitle: '1.0.0',
                onTap: _showAppInfo,
              ),
              _MenuItemData(
                icon: Icons.description_outlined,
                title: 'Terms of Service',
                subtitle: 'Read our terms and conditions',
                onTap: _showTermsOfService,
              ),
              _MenuItemData(
                icon: Icons.privacy_tip_outlined,
                title: 'Privacy Policy',
                subtitle: 'How we protect your data',
                onTap: _showPrivacyPolicy,
              ),
            ],
            isSmallScreen: isSmallScreen,
          ),

          const SizedBox(height: 32),

          // * Logout button
          _buildLogoutButton(isSmallScreen),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  /// * Build menu section
  Widget _buildMenuSection({
    required String title,
    required List<_MenuItemData> items,
    required bool isSmallScreen,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // * Section title
        Padding(
          padding: const EdgeInsets.only(left: 8, bottom: 12),
          child: Text(
            title,
            style: TextStyle(
              fontSize: isSmallScreen ? 16 : 18,
              fontWeight: FontWeight.w600,
              color: CropFreshColors.onBackground60,
            ),
          ),
        ),

        // * Section items
        Container(
          decoration: BoxDecoration(
            color: CropFreshColors.surface60Primary,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: items
                .map((item) => _buildMenuItem(item, isSmallScreen))
                .toList(),
          ),
        ),
      ],
    );
  }

  /// * Build individual menu item
  Widget _buildMenuItem(_MenuItemData item, bool isSmallScreen) {
    return ListTile(
      leading: Icon(item.icon, color: CropFreshColors.green30Primary, size: 24),
      title: Text(
        item.title,
        style: TextStyle(
          fontSize: isSmallScreen ? 14 : 16,
          fontWeight: FontWeight.w500,
          color: CropFreshColors.onBackground60,
        ),
      ),
      subtitle: item.subtitle != null
          ? Text(
              item.subtitle!,
              style: TextStyle(
                fontSize: isSmallScreen ? 12 : 14,
                color: CropFreshColors.onBackground60Secondary,
              ),
            )
          : null,
      trailing: item.showArrow
          ? Icon(
              Icons.arrow_forward_ios,
              color: CropFreshColors.onBackground60Tertiary,
              size: 16,
            )
          : null,
      onTap: item.onTap,
    );
  }

  /// * Build logout button
  Widget _buildLogoutButton(bool isSmallScreen) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: ElevatedButton(
        onPressed: _showLogoutDialog,
        style: ElevatedButton.styleFrom(
          backgroundColor: CropFreshColors.errorPrimary,
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(vertical: isSmallScreen ? 12 : 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.logout, size: isSmallScreen ? 18 : 20),
            const SizedBox(width: 8),
            Text(
              'Logout',
              style: TextStyle(
                fontSize: isSmallScreen ? 14 : 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================================
  // * ACTION METHODS
  // ============================================================================

  /// * Edit profile information
  void _editProfile() {
    _showComingSoonDialog('Edit Profile');
  }

  /// * Edit farm details
  void _editFarmDetails() {
    _showComingSoonDialog('Farm Details');
  }

  /// * Open privacy settings
  void _openPrivacySettings() {
    _showComingSoonDialog('Privacy & Security');
  }

  /// * Change language
  void _changeLanguage() {
    _showComingSoonDialog('Language Settings');
  }

  /// * Open notification settings
  void _openNotificationSettings() {
    _showComingSoonDialog('Notification Settings');
  }

  /// * Change theme
  void _changeTheme() {
    _showComingSoonDialog('Theme Settings');
  }

  /// * Open help center
  void _openHelpCenter() {
    _showComingSoonDialog('Help Center');
  }

  /// * Contact support
  void _contactSupport() {
    _showComingSoonDialog('Contact Support');
  }

  /// * Send feedback
  void _sendFeedback() {
    _showComingSoonDialog('Send Feedback');
  }

  /// * Show app information
  void _showAppInfo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: CropFreshColors.background60Primary,
        title: Text(
          'About CropFresh',
          style: TextStyle(color: CropFreshColors.onBackground60),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Version: 1.0.0',
              style: TextStyle(color: CropFreshColors.onBackground60Secondary),
            ),
            const SizedBox(height: 8),
            Text(
              'Empowering farmers with smart agriculture solutions.',
              style: TextStyle(color: CropFreshColors.onBackground60Secondary),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Close',
              style: TextStyle(color: CropFreshColors.green30Primary),
            ),
          ),
        ],
      ),
    );
  }

  /// * Show terms of service
  void _showTermsOfService() {
    _showComingSoonDialog('Terms of Service');
  }

  /// * Show privacy policy
  void _showPrivacyPolicy() {
    _showComingSoonDialog('Privacy Policy');
  }

  /// * Show logout confirmation dialog
  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: CropFreshColors.background60Primary,
        title: Text(
          'Logout',
          style: TextStyle(color: CropFreshColors.onBackground60),
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
              style: TextStyle(color: CropFreshColors.onBackground60Tertiary),
            ),
          ),
          TextButton(
            onPressed: _performLogout,
            child: Text(
              'Logout',
              style: TextStyle(
                color: CropFreshColors.errorPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// * Show coming soon dialog
  void _showComingSoonDialog(String feature) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: CropFreshColors.background60Primary,
        title: Text(
          feature,
          style: TextStyle(color: CropFreshColors.onBackground60),
        ),
        content: Text(
          'This feature is coming soon!',
          style: TextStyle(color: CropFreshColors.onBackground60Secondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'OK',
              style: TextStyle(color: CropFreshColors.green30Primary),
            ),
          ),
        ],
      ),
    );
  }

  /// * Perform logout
  void _performLogout() {
    Navigator.of(context).pop(); // Close dialog
    // * Logout logic would go here
    // * Navigate back to login screen
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Logout functionality coming soon...'),
        backgroundColor: CropFreshColors.orange10Primary,
      ),
    );
  }
}

// ============================================================================
// * HELPER CLASSES
// ============================================================================

/// * Menu item data structure
class _MenuItemData {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;
  final bool showArrow;

  const _MenuItemData({
    required this.icon,
    required this.title,
    this.subtitle,
    required this.onTap,
    this.showArrow = false,
  });
}
