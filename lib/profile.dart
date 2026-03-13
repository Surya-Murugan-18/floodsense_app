import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Profile Screen',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.grey[100],
      ),
      home: const ProfileScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class ProfileData {
  final String name;
  final String status;
  final String email;
  final String phone;
  final String location;
  final String profileImage;

  ProfileData({
    required this.name,
    required this.status,
    required this.email,
    required this.phone,
    required this.location,
    required this.profileImage,
  });
}

class ActivityItem {
  final String title;
  final String status;
  final String time;
  final IconData icon;

  ActivityItem({
    required this.title,
    required this.status,
    required this.time,
    required this.icon,
  });
}

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Dynamic data - can be updated from API or user input
  late ProfileData userData;
  late List<ActivityItem> activityHistory;
  
  // Toggle states
  bool liveLocationTracking = false;
  bool floodAlerts = false;
  bool volunteerHelp = false;
  bool emergencyBroadcasts = false;
  bool darkMode = false;
  String currentLanguage = 'English';

  @override
  void initState() {
    super.initState();
    // Initialize with sample data - in a real app, this would come from an API
    _loadUserData();
    _loadActivityHistory();
  }

  void _loadUserData() {
    // Simulate API call or database fetch
    userData = ProfileData(
      name: 'John Doe',
      status: 'Resident',
      email: 'johndoe@example.com',
      phone: '+91 9876543210',
      location: 'XYZ Street, City, Country',
      profileImage: 'https://via.placeholder.com/150',
    );
  }

  void _loadActivityHistory() {
    // Simulate API call or database fetch
    activityHistory = [
      ActivityItem(
        title: 'Flood Alert Received',
        status: 'Active',
        time: '2 hours ago',
        icon: Icons.warning_rounded,
      ),
      ActivityItem(
        title: 'SOS Request',
        status: 'Resolved',
        time: 'Yesterday',
        icon: Icons.sos,
      ),
      ActivityItem(
        title: 'Location Updated',
        status: 'Completed',
        time: '2 days ago',
        icon: Icons.location_on,
      ),
    ];
  }

  // Methods to update user data
  void _updateUserProfile() {
    // This would typically show a form and update the userData object
    setState(() {
      // Example update
      userData = ProfileData(
        name: userData.name,
        status: userData.status,
        email: userData.email,
        phone: userData.phone,
        location: userData.location,
        profileImage: userData.profileImage,
      );
    });
  }

  // Method to handle logout
  void _handleLogout() {
    // In a real app, this would clear session data and navigate to login
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Perform logout actions
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions for responsive layout
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isSmallScreen = screenWidth < 360;
    
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isSmallScreen ? 12.0 : 16.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildProfileSection(screenWidth),
                      SizedBox(height: isSmallScreen ? 12 : 16),
                      _buildPersonalInfoSection(),
                      SizedBox(height: isSmallScreen ? 12 : 16),
                      _buildLocationSection(),
                      SizedBox(height: isSmallScreen ? 12 : 16),
                      _buildNotificationSection(),
                      SizedBox(height: isSmallScreen ? 12 : 16),
                      _buildActivityHistorySection(),
                      SizedBox(height: isSmallScreen ? 12 : 16),
                      _buildAppSettingsSection(),
                      SizedBox(height: isSmallScreen ? 12 : 16),
                      _buildHelpSupportSection(),
                      SizedBox(height: isSmallScreen ? 12 : 16),
                      _buildLogoutButton(),
                      SizedBox(height: isSmallScreen ? 20 : 24),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 1,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              // Handle back button press
              Navigator.of(context).pop();
            },
            child: const Icon(Icons.arrow_back_ios, size: 20),
          ),
          const Text(
            'Profile',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          GestureDetector(
            onTap: () {
              // Handle settings button press
            },
            child: const Icon(Icons.settings, color: Colors.blue, size: 24),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileSection(double screenWidth) {
    // Adjust avatar size based on screen width
    final avatarRadius = screenWidth < 360 ? 35.0 : 40.0;
    
    return Column(
      children: [
        const SizedBox(height: 16),
        Center(
          child: Stack(
            children: [
              CircleAvatar(
                radius: avatarRadius,
                backgroundImage: NetworkImage(userData.profileImage),
                backgroundColor: Colors.grey[200],
                onBackgroundImageError: (exception, stackTrace) {
                  // Handle image loading errors
                },
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.camera_alt,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Text(
          userData.name,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          userData.status,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.blue,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: _updateUserProfile,
          child: const Text(
            'Edit Profile',
            style: TextStyle(
              fontSize: 14,
              color: Colors.blue,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildPersonalInfoSection() {
    return _buildSectionCard(
      title: 'Personal Information',
      children: [
        _buildInfoRow(
          icon: Icons.email_outlined,
          title: 'Email',
          value: userData.email,
        ),
        const Divider(height: 1),
        _buildInfoRow(
          icon: Icons.phone_outlined,
          title: 'Phone',
          value: userData.phone,
        ),
      ],
    );
  }

  Widget _buildLocationSection() {
    return _buildSectionCard(
      title: 'Location Settings',
      children: [
        _buildInfoRow(
          icon: Icons.location_on_outlined,
          title: 'Current Location',
          value: userData.location,
        ),
        const Divider(height: 1),
        _buildToggleRow(
          icon: Icons.location_searching_outlined,
          title: 'Live Location Tracking',
          value: liveLocationTracking,
          onChanged: (value) {
            setState(() {
              liveLocationTracking = value;
              // In a real app, you would save this preference to a backend
            });
          },
        ),
      ],
    );
  }

  Widget _buildNotificationSection() {
    return _buildSectionCard(
      title: 'Notification Preferences',
      children: [
        _buildToggleRowWithSubtitle(
          title: 'Flood Alerts',
          subtitle: 'Get notified about flood warnings',
          value: floodAlerts,
          onChanged: (value) {
            setState(() {
              floodAlerts = value;
              // In a real app, you would save this preference to a backend
            });
          },
        ),
        const Divider(height: 1),
        _buildToggleRowWithSubtitle(
          title: 'Volunteer Help Requests',
          subtitle: 'Receive volunteer opportunities',
          value: volunteerHelp,
          onChanged: (value) {
            setState(() {
              volunteerHelp = value;
              // In a real app, you would save this preference to a backend
            });
          },
        ),
        const Divider(height: 1),
        _buildToggleRowWithSubtitle(
          title: 'Emergency Broadcasts',
          subtitle: 'Important emergency updates',
          value: emergencyBroadcasts,
          onChanged: (value) {
            setState(() {
              emergencyBroadcasts = value;
              // In a real app, you would save this preference to a backend
            });
          },
        ),
      ],
    );
  }

  Widget _buildActivityHistorySection() {
    return _buildSectionCard(
      title: 'Activity History',
      children: activityHistory.map((activity) {
        return Column(
          children: [
            _buildActivityRow(
              icon: activity.icon,
              title: activity.title,
              status: activity.status,
              time: activity.time,
            ),
            if (activityHistory.last != activity) const Divider(height: 1),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildAppSettingsSection() {
    return _buildSectionCard(
      title: 'App Settings',
      children: [
        _buildSettingRow(
          icon: Icons.language_outlined,
          title: 'Language',
          value: currentLanguage,
          onTap: () {
            // Show language selection dialog
            _showLanguageSelectionDialog();
          },
        ),
        const Divider(height: 1),
        _buildToggleRow(
          icon: Icons.dark_mode_outlined,
          title: 'Dark Mode',
          value: darkMode,
          onChanged: (value) {
            setState(() {
              darkMode = value;
              // In a real app, you would apply theme changes
            });
          },
        ),
        const Divider(height: 1),
        _buildNavigationRow(
          icon: Icons.lock_outline,
          title: 'Privacy Settings',
          onTap: () {
            // Navigate to privacy settings
          },
        ),
      ],
    );
  }

  void _showLanguageSelectionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Language'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('English'),
              trailing: currentLanguage == 'English' ? const Icon(Icons.check, color: Colors.blue) : null,
              onTap: () {
                setState(() {
                  currentLanguage = 'English';
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Spanish'),
              trailing: currentLanguage == 'Spanish' ? const Icon(Icons.check, color: Colors.blue) : null,
              onTap: () {
                setState(() {
                  currentLanguage = 'Spanish';
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('French'),
              trailing: currentLanguage == 'French' ? const Icon(Icons.check, color: Colors.blue) : null,
              onTap: () {
                setState(() {
                  currentLanguage = 'French';
                });
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHelpSupportSection() {
    return _buildSectionCard(
      title: 'Help & Support',
      children: [
        _buildNavigationRow(
          icon: Icons.contact_support_outlined,
          title: 'Contact Support',
          onTap: () {
            // Navigate to contact support
          },
        ),
        const Divider(height: 1),
        _buildNavigationRow(
          icon: Icons.help_outline,
          title: 'FAQs & User Guide',
          onTap: () {
            // Navigate to FAQs
          },
        ),
      ],
    );
  }

  Widget _buildLogoutButton() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: GestureDetector(
          onTap: _handleLogout,
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.logout, color: Colors.red, size: 18),
              SizedBox(width: 8),
              Text(
                'Logout',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionCard({required String title, required List<Widget> children}) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildToggleRow({
    required IconData icon,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: Colors.grey),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                ),
              ),
            ],
          ),
          Switch.adaptive(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.blue,
          ),
        ],
      ),
    );
  }

  Widget _buildToggleRowWithSubtitle({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          Switch.adaptive(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.blue,
          ),
        ],
      ),
    );
  }

  Widget _buildSettingRow({
    required IconData icon,
    required String title,
    required String value,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(icon, size: 20, color: Colors.grey),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                if (onTap != null) const SizedBox(width: 4),
                if (onTap != null)
                  const Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Colors.grey,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationRow({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(icon, size: 20, color: Colors.grey),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityRow({
    required IconData icon,
    required String title,
    required String status,
    required String time,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 16, color: Colors.blue),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  status,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          Text(
            time,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}