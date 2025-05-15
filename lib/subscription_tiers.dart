import 'package:flutter/material.dart';
import '../main.dart';

class SubscriptionTiersScreen extends StatefulWidget {
  const SubscriptionTiersScreen({Key? key}) : super(key: key);

  @override
  State<SubscriptionTiersScreen> createState() => _SubscriptionTiersScreenState();
}

class _SubscriptionTiersScreenState extends State<SubscriptionTiersScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
  }

  final List<Map<String, dynamic>> tiers = [
    {
      'icon': Icons.star,
      'title': 'Free Trial',
      'desc': 'Get free access to premium features. You will be billed after 30 days.',
      'monthly': 'Free',
      'annual': 'Free',
      'button': 'Start Trial',
    },
    {
      'icon': Icons.workspace_premium,
      'title': 'OmniView++',
      'desc': 'Get access to premium benefits and early access.',
      'monthly': '₱120 / month',
      'annual': '₱1200 / year',
      'button': 'Purchase',
    },
    {
      'icon': Icons.workspace_premium,
      'title': 'OmniView+++',
      'desc': 'Support the devs and get the best tier and advanced AI.',
      'monthly': '₱299 / month',
      'annual': '₱1999 / year',
      'button': 'Purchase',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: themeNotifier,
      builder: (context, isDark, _) {
        final borderColor = isDark ? Colors.white : const Color(0xFF402E68); // dark purple
        final bgColor = isDark ? Colors.black : Colors.white;
        final iconButtonColor = isDark ? Colors.yellow[700]! : const Color(0xFF402E68);
        final textColor = isDark ? Colors.white : Colors.black;
        final buttonFg = Colors.white;
        return Scaffold(
          backgroundColor: bgColor,
          body: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back),
                        color: iconButtonColor,
                        onPressed: () => Navigator.of(context).pop(),
                        tooltip: 'Back',
                      ),
                      IconButton(
                        icon: Icon(
                          isDark ? Icons.wb_sunny : Icons.nightlight_round,
                          color: iconButtonColor,
                          size: 32,
                        ),
                        onPressed: () => themeNotifier.toggle(),
                        tooltip: isDark ? 'Switch to Light Mode' : 'Switch to Dark Mode',
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: PageView.builder(
                    key: ValueKey(iconButtonColor), // Forces rebuild on theme change
                    controller: _pageController,
                    itemCount: tiers.length,
                    onPageChanged: (i) => setState(() => _currentPage = i),
                    itemBuilder: (context, i) {
                      final tier = tiers[i];
                      return Center(
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.92,
                          padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 32.0),
                          decoration: BoxDecoration(
                            color: bgColor,
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(color: borderColor, width: 2),
                            boxShadow: [
                              BoxShadow(
                                color: borderColor.withAlpha(20), // Fixed: Replaced deprecated withOpacity
                                blurRadius: 8,
                                spreadRadius: 1,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Flexible(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(tier['icon'], color: iconButtonColor, size: 48),
                                const SizedBox(height: 24),
                                Text(
                                  tier['title'],
                                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: textColor),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  tier['desc'],
                                  style: TextStyle(fontSize: 16, color: textColor.withAlpha((0.8 * 255).round())), // fixed
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 32),
                                Text(
                                  tier['monthly'],
                                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: iconButtonColor),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 40),
                                SizedBox(
                                  width: double.infinity,
                                  child: TextButton(
                                    style: TextButton.styleFrom(
                                      backgroundColor: iconButtonColor,
                                      foregroundColor: buttonFg,
                                      padding: const EdgeInsets.symmetric(vertical: 18),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                                    ),
                                    onPressed: () async {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text('Premium button clicked!')),
                                      );
                                    },
                                    child: Text(tier['button']),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_left, size: 32),
                      color: iconButtonColor,
                      onPressed: _currentPage > 0
                          ? () {
                              _pageController.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
                            }
                          : null,
                    ),
                    ...List.generate(
                      tiers.length,
                      (i) => Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 12),
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _currentPage == i ? iconButtonColor : Colors.grey[400],
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.arrow_right, size: 32),
                      color: iconButtonColor,
                      onPressed: _currentPage < tiers.length - 1
                          ? () {
                              _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
                            }
                          : null,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
