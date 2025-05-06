import 'package:flutter/material.dart';
import '../main.dart'; // Import ThemeNotifier

class PremiumUI extends StatefulWidget {
  const PremiumUI({Key? key}) : super(key: key);

  @override
  State<PremiumUI> createState() => _PremiumUIState();
}

class _PremiumUIState extends State<PremiumUI> {
  bool isMonthly = true;
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    // Listen to theme changes
    themeNotifier.addListener(_themeListener);
  }

  @override
  void dispose() {
    themeNotifier.removeListener(_themeListener);
    super.dispose();
  }

  void _themeListener() {
    setState(() {});
  }

  final Color kDarkerPurple = const Color(0xFF3D246C); // Even darker purple

  List<Widget> get _billboards {
    final isDark = themeNotifier.value;
    final Color accent = isDark ? Colors.white : const Color(0xFF7E57C2);
    final Color textColor = isDark ? Colors.white : const Color(0xFF402E68);
    final Color darkPurple = kDarkerPurple;
    return [
      _PremiumBillboard(
        title: 'Free Trial',
        description: 'Get free access to premium features. You will be billed after 30 days.',
        buttonText: 'Start Trial',
        onButtonPressed: () {},
        child: const SizedBox.shrink(),
        pricingRow: null,
        accent: accent,
        textColor: textColor,
        isDark: isDark,
        darkPurple: darkPurple,
      ),
      _PremiumBillboard(
        title: 'OmniView++',
        description: 'Get access to premium benefits and early access.',
        buttonText: '',
        onButtonPressed: () {},
        pricingRow: Row(
          children: [
            Text(
              isMonthly ? '₱120 / month' : '₱1200 / lifetime',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const Spacer(),
            GestureDetector(
              onTap: () {},
              child: Text(
                'Purchase',
                style: TextStyle(
                  color: accent,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        isMonthly = true;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: isDark
                            ? (isMonthly ? darkPurple : Colors.transparent)
                            : (isMonthly ? accent : Colors.white),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: accent),
                      ),
                      child: Center(
                        child: Text(
                          'Monthly',
                          style: TextStyle(
                            fontSize: 14,
                            color: isMonthly ? Colors.white : accent,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        isMonthly = false;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: isDark
                            ? (!isMonthly ? darkPurple : Colors.transparent)
                            : (!isMonthly ? accent : Colors.white),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: accent),
                      ),
                      child: Center(
                        child: Text(
                          'Lifetime',
                          style: TextStyle(
                            fontSize: 14,
                            color: !isMonthly ? Colors.white : accent,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        accent: accent,
        textColor: textColor,
        isDark: isDark,
        darkPurple: darkPurple,
      ),
      _PremiumBillboard(
        title: 'OmniView+++',
        description: 'Support the devs and get the best tier and advanced AI.',
        buttonText: '',
        onButtonPressed: () {},
        pricingRow: Row(
          children: [
            Text(
              isMonthly ? '₱299 / month' : '₱1999 / lifetime',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const Spacer(),
            GestureDetector(
              onTap: () {},
              child: Text(
                'Purchase',
                style: TextStyle(
                  color: accent,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        isMonthly = true;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: isDark
                            ? (isMonthly ? darkPurple : Colors.transparent)
                            : (isMonthly ? accent : Colors.white),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: accent),
                      ),
                      child: Center(
                        child: Text(
                          'Monthly',
                          style: TextStyle(
                            fontSize: 14,
                            color: isMonthly ? Colors.white : accent,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        isMonthly = false;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: isDark
                            ? (!isMonthly ? darkPurple : Colors.transparent)
                            : (!isMonthly ? accent : Colors.white),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: accent),
                      ),
                      child: Center(
                        child: Text(
                          'Lifetime',
                          style: TextStyle(
                            fontSize: 14,
                            color: !isMonthly ? Colors.white : accent,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        accent: accent,
        textColor: textColor,
        isDark: isDark,
        darkPurple: darkPurple,
      ),
    ];
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  void _loopTo(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = themeNotifier.value;
    final Color accent = isDark ? Colors.white : const Color(0xFF7E57C2);
    final Color textColor = isDark ? Colors.white : const Color(0xFF402E68);
    final size = MediaQuery.of(context).size;
    final double boxSize = size.width * 0.7;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: isDark ? Colors.black : Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: textColor),
        title: Text('Premium', style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 400),
            transitionBuilder: (child, anim) => RotationTransition(turns: anim, child: child),
            child: IconButton(
              key: ValueKey(isDark),
              icon: Icon(
                isDark ? Icons.wb_sunny : Icons.nightlight_round,
                color: isDark ? Colors.amber[600] : accent,
                size: 28,
              ),
              onPressed: () {
                themeNotifier.toggle();
              },
              tooltip: isDark ? 'Switch to Light Mode' : 'Switch to Dark Mode',
            ),
          ),
        ],
      ),
      backgroundColor: isDark ? Colors.black : Colors.white,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: boxSize,
                        height: boxSize,
                        child: PageView.builder(
                          controller: _pageController,
                          itemCount: _billboards.length,
                          onPageChanged: _onPageChanged,
                          itemBuilder: (context, index) {
                            return _billboards[index];
                          },
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: Icon(Icons.arrow_back_ios, color: textColor),
                            onPressed: () {
                              int prev = (_currentPage - 1 + _billboards.length) % _billboards.length;
                              _loopTo(prev);
                            },
                          ),
                          ...List.generate(_billboards.length, (i) => Container(
                                margin: const EdgeInsets.symmetric(horizontal: 3),
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: _currentPage == i ? accent : Colors.grey[300],
                                ),
                              )),
                          IconButton(
                            icon: Icon(Icons.arrow_forward_ios, color: textColor),
                            onPressed: () {
                              int next = (_currentPage + 1) % _billboards.length;
                              _loopTo(next);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _PremiumBillboard extends StatelessWidget {
  final String title;
  final String description;
  final String buttonText;
  final VoidCallback onButtonPressed;
  final Widget child;
  final Widget? pricingRow;
  final Color accent;
  final Color textColor;
  final bool isDark;
  final Color darkPurple;

  const _PremiumBillboard({
    required this.title,
    required this.description,
    required this.buttonText,
    required this.onButtonPressed,
    required this.child,
    this.pricingRow,
    required this.accent,
    required this.textColor,
    required this.isDark,
    required this.darkPurple,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(28.0),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            decoration: BoxDecoration(
              color: isDark ? Colors.grey[900] : Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isDark ? Colors.white : Colors.black,
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: accent.withOpacity(0.08),
                  blurRadius: 8,
                  spreadRadius: 1,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    description,
                    style: TextStyle(fontSize: 14, color: textColor),
                  ),
                  if (title == 'Free Trial') ...[
                    const SizedBox(height: 74),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isDark ? darkPurple : accent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          elevation: 0,
                        ),
                        onPressed: onButtonPressed,
                        child: Text(
                          buttonText,
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                  if (title == 'OmniView++' && pricingRow != null) ...[
                    const SizedBox(height: 32),
                    pricingRow!,
                    const SizedBox(height: 12),
                    child,
                  ],
                  if (title == 'OmniView+++' && pricingRow != null) ...[
                    const SizedBox(height: 32),
                    pricingRow!,
                    const SizedBox(height: 12),
                    child,
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
