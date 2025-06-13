// ===================================================================
// * SERVICES SCREEN
// * Purpose: Additional agricultural services and tools
// * Features: Weather forecasts, crop advisory, financial services, training
// * State Management: StatefulWidget
// * Security Level: MEDIUM - General service information
// ===================================================================

import 'package:flutter/material.dart';
import '../../../core/theme/colors.dart';
import '../../login/models/user_profile.dart';

/// * SERVICES SCREEN
/// * Additional services to support farmers
class ServicesScreen extends StatefulWidget {
  final UserProfile userProfile;

  const ServicesScreen({super.key, required this.userProfile});

  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
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
              // * Header
              _buildHeader(isSmallScreen),

              // * Service categories
              _buildServiceCategories(isSmallScreen),
            ],
          ),
        ),
      ),
    );
  }

  /// * Build header section
  Widget _buildHeader(bool isSmallScreen) {
    return Container(
      padding: EdgeInsets.all(isSmallScreen ? 20 : 24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            CropFreshColors.orange10Primary,
            CropFreshColors.orange10Vibrant,
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Services',
                style: TextStyle(
                  fontSize: isSmallScreen ? 24 : 28,
                  fontWeight: FontWeight.w600,
                  color: CropFreshColors.onOrange10,
                ),
              ),
              Icon(
                Icons.more_horiz,
                color: CropFreshColors.onOrange10,
                size: 28,
              ),
            ],
          ),

          const SizedBox(height: 12),

          Text(
            'Comprehensive agricultural services to support your farming journey',
            style: TextStyle(
              fontSize: isSmallScreen ? 14 : 16,
              color: CropFreshColors.onOrange10.withValues(alpha: 0.9),
            ),
          ),
        ],
      ),
    );
  }

  /// * Build service categories
  Widget _buildServiceCategories(bool isSmallScreen) {
    return Padding(
      padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
      child: Column(
        children: [
          // * Weather & Advisory services
          _buildServiceSection(
            title: 'Weather & Advisory',
            services: [
              _ServiceData(
                icon: Icons.cloud,
                title: 'Weather Forecast',
                subtitle: '7-day detailed weather predictions',
                color: CropFreshColors.green30Primary,
                onTap: () => _openService('Weather Forecast'),
              ),
              _ServiceData(
                icon: Icons.eco,
                title: 'Crop Advisory',
                subtitle: 'Expert advice for your crops',
                color: CropFreshColors.green30Primary,
                onTap: () => _openService('Crop Advisory'),
              ),
              _ServiceData(
                icon: Icons.bug_report,
                title: 'Pest & Disease Alert',
                subtitle: 'Early warning and solutions',
                color: CropFreshColors.orange10Primary,
                onTap: () => _openService('Pest & Disease Alert'),
              ),
            ],
            isSmallScreen: isSmallScreen,
          ),

          const SizedBox(height: 24),

          // * Financial services
          _buildServiceSection(
            title: 'Financial Services',
            services: [
              _ServiceData(
                icon: Icons.account_balance,
                title: 'Agricultural Loans',
                subtitle: 'Quick loans for farming needs',
                color: CropFreshColors.green30Primary,
                onTap: () => _openService('Agricultural Loans'),
              ),
              _ServiceData(
                icon: Icons.security,
                title: 'Crop Insurance',
                subtitle: 'Protect your harvest',
                color: CropFreshColors.orange10Primary,
                onTap: () => _openService('Crop Insurance'),
              ),
              _ServiceData(
                icon: Icons.trending_up,
                title: 'Market Analysis',
                subtitle: 'Price trends and predictions',
                color: CropFreshColors.green30Primary,
                onTap: () => _openService('Market Analysis'),
              ),
            ],
            isSmallScreen: isSmallScreen,
          ),

          const SizedBox(height: 24),

          // * Education & Training
          _buildServiceSection(
            title: 'Education & Training',
            services: [
              _ServiceData(
                icon: Icons.school,
                title: 'Farming Courses',
                subtitle: 'Learn modern farming techniques',
                color: CropFreshColors.orange10Primary,
                onTap: () => _openService('Farming Courses'),
              ),
              _ServiceData(
                icon: Icons.video_library,
                title: 'Video Tutorials',
                subtitle: 'Step-by-step farming guides',
                color: CropFreshColors.green30Primary,
                onTap: () => _openService('Video Tutorials'),
              ),
              _ServiceData(
                icon: Icons.people,
                title: 'Expert Consultation',
                subtitle: 'Connect with agricultural experts',
                color: CropFreshColors.orange10Primary,
                onTap: () => _openService('Expert Consultation'),
              ),
            ],
            isSmallScreen: isSmallScreen,
          ),

          const SizedBox(height: 24),

          // * Technology & Tools
          _buildServiceSection(
            title: 'Technology & Tools',
            services: [
              _ServiceData(
                icon: Icons.calculate,
                title: 'Farm Calculator',
                subtitle: 'Calculate costs and profits',
                color: CropFreshColors.green30Primary,
                onTap: () => _openService('Farm Calculator'),
              ),
              _ServiceData(
                icon: Icons.satellite,
                title: 'Satellite Monitoring',
                subtitle: 'Monitor your fields from space',
                color: CropFreshColors.orange10Primary,
                onTap: () => _openService('Satellite Monitoring'),
              ),
              _ServiceData(
                icon: Icons.sensors,
                title: 'IoT Solutions',
                subtitle: 'Smart sensors for modern farming',
                color: CropFreshColors.green30Primary,
                onTap: () => _openService('IoT Solutions'),
              ),
            ],
            isSmallScreen: isSmallScreen,
          ),
        ],
      ),
    );
  }

  /// * Build service section
  Widget _buildServiceSection({
    required String title,
    required List<_ServiceData> services,
    required bool isSmallScreen,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // * Section title
        Padding(
          padding: const EdgeInsets.only(left: 8, bottom: 16),
          child: Text(
            title,
            style: TextStyle(
              fontSize: isSmallScreen ? 18 : 20,
              fontWeight: FontWeight.w600,
              color: CropFreshColors.onBackground60,
            ),
          ),
        ),

        // * Service grid
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1.1,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: services.length,
          itemBuilder: (context, index) {
            return _buildServiceCard(services[index], isSmallScreen);
          },
        ),
      ],
    );
  }

  /// * Build individual service card
  Widget _buildServiceCard(_ServiceData service, bool isSmallScreen) {
    return GestureDetector(
      onTap: service.onTap,
      child: Container(
        decoration: BoxDecoration(
          color: CropFreshColors.surface60Primary,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: CropFreshColors.onBackground60Tertiary.withValues(
                alpha: 0.1,
              ),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // * Service icon
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: service.color.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(service.icon, color: service.color, size: 24),
              ),

              const SizedBox(height: 12),

              // * Service title
              Text(
                service.title,
                style: TextStyle(
                  fontSize: isSmallScreen ? 14 : 16,
                  fontWeight: FontWeight.w600,
                  color: CropFreshColors.onBackground60,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: 8),

              // * Service subtitle
              Text(
                service.subtitle,
                style: TextStyle(
                  fontSize: isSmallScreen ? 12 : 14,
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

  // ============================================================================
  // * ACTION METHODS
  // ============================================================================

  /// * Open service
  void _openService(String serviceName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: CropFreshColors.background60Primary,
        title: Text(
          serviceName,
          style: TextStyle(color: CropFreshColors.onBackground60),
        ),
        content: Text(
          'This service is coming soon! We\'re working hard to bring you the best agricultural solutions.',
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
}

// ============================================================================
// * HELPER CLASSES
// ============================================================================

/// * Service data structure
class _ServiceData {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _ServiceData({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });
}
