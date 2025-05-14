import 'package:flutter/material.dart';
import 'camera_ui.dart';
import 'logout_helper.dart';
import 'subscription_tiers.dart';
import '../main.dart'; // Import ThemeNotifier

class SelectionScreen extends StatelessWidget {
  final String username;
  const SelectionScreen({Key? key, required this.username}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDark ? Colors.black : Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            // Theme toggle button (top right)
            Positioned(
              top: 16,
              right: 16,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                transitionBuilder: (child, anim) =>
                    RotationTransition(turns: anim, child: child),
                child: IconButton(
                  key: ValueKey(isDark),
                  icon: Icon(
                    isDark ? Icons.wb_sunny : Icons.nightlight_round,
                    color: isDark
                        ? Colors.yellow[600]
                        : const Color.fromARGB(255, 64, 46, 104),
                    size: 32,
                  ),
                  onPressed: () => themeNotifier.toggle(),
                  tooltip:
                      isDark ? 'Switch to Light Mode' : 'Switch to Dark Mode',
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 106),
                Padding(
                  padding: const EdgeInsets.only(left: 24),
                  child: Text(
                    "OmniView+",
                    style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                      color: isDark
                          ? Colors.white
                          : const Color.fromARGB(255, 64, 46, 104),
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                const SizedBox(height: 36),
                _SelectionBox(
                  label: 'Camera',
                  isDark: isDark,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const CameraUI()),
                    );
                  },
                ),
                _SelectionBox(
                  label: 'Premium',
                  trailing: Icon(Icons.star, color: Colors.amber, size: 28),
                  isDark: isDark,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const SubscriptionTiersScreen(),
                      ),
                    );
                  },
                ),
                _SelectionBox(
                  label: 'Help',
                  isDark: isDark,
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Help'),
                        content: const Text(
                          'OmniView+ is an app that will be the 2nd eye for people and world. With advance AI analysis we can offer you a lens that will help you identify whats in front of you and help with the visual impairness.\n\n- Click the moon icon to change themes\n- You can switch modes in camera',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('OK'),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                _SelectionBox(
                  label: 'Logout',
                  isDark: isDark,
                  onTap: () {
                    LogoutHelper.logout(context);
                  },
                ),
              ],
            ),
            // Decorative stars at the bottom
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Design(isDark: isDark),
            ),
          ],
        ),
      ),
    );
  }
}

class _SelectionBox extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final Widget? trailing;
  final bool isDark;
  const _SelectionBox({
    required this.label,
    required this.onTap,
    this.trailing,
    this.isDark = false,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Container(
          width: MediaQuery.of(context).size.width * 0.92,
          height: 64,
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF232323) : Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              if (!isDark)
                BoxShadow(
                  color: Colors.black.withAlpha((0.08 * 255).round()),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
            ],
            border: Border.all(
              color: isDark ? Colors.white : Colors.black,
              width: 1,
            ),
          ),
          child: Row(
            children: [
              const SizedBox(width: 28),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
              ),
              if (trailing != null) ...[trailing!, const SizedBox(width: 28)],
            ],
          ),
        ),
      ),
    );
  }
}

class Design extends StatelessWidget {
  final bool isDark;
  const Design({Key? key, this.isDark = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final starColors = [
      isDark ? Colors.yellow[700] : const Color(0xFFB39DDB),
      isDark ? Colors.yellow[600] : const Color(0xFF9575CD),
      isDark ? Colors.yellow[500] : const Color(0xFF7E57C2),
      isDark ? Colors.yellow[800] : const Color(0xFF512DA8),
      isDark ? Colors.yellow[600] : const Color(0xFF9575CD),
      isDark ? Colors.yellow[700] : const Color(0xFFB39DDB),
    ];
    return SizedBox(
      height: 120,
      child: Stack(
        children: [
          Positioned(
            left: 30,
            top: 40,
            child: Transform.rotate(
              angle: 0.2,
              child: Icon(Icons.star, size: 32, color: starColors[0]),
            ),
          ),
          Positioned(
            left: 80,
            top: 10,
            child: Transform.rotate(
              angle: -0.4,
              child: Icon(Icons.star, size: 24, color: starColors[1]),
            ),
          ),
          Positioned(
            right: 60,
            top: 30,
            child: Transform.rotate(
              angle: 0.7,
              child: Icon(Icons.star, size: 40, color: starColors[2]),
            ),
          ),
          Positioned(
            right: 20,
            top: 60,
            child: Transform.rotate(
              angle: -0.2,
              child: Icon(Icons.star, size: 18, color: starColors[3]),
            ),
          ),
          Positioned(
            left: 140,
            top: 60,
            child: Transform.rotate(
              angle: 0.5,
              child: Icon(Icons.star, size: 28, color: starColors[4]),
            ),
          ),
          Positioned(
            right: 120,
            top: 80,
            child: Transform.rotate(
              angle: -0.7,
              child: Icon(Icons.star, size: 22, color: starColors[5]),
            ),
          ),
        ],
      ),
    );
  }
}
