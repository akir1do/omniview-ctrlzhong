import 'package:flutter/material.dart';
import 'login_ui.dart';
import 'register_page.dart';

// ====== Design section ======
// Colors
const Color kDeepPurple = Color(0xFF6C4AB6); // Main accent color
const Color kDarkerPurple = Color(0xFF3D246C); // Even darker purple
const Color kWhitishPurple = Color(0xFFF8F6FF); // Gradient start
const Color kWhite = Color(0xFFFFFFFF); // Gradient end
const Color kStar1 = Color(0xFFE0D7FF);
const Color kStar2 = Color(0xFFD1C4E9);
const Color kStar3 = Color(0xFFEDE7F6);
const Color kStar4 = Color(0xFFE0D7FF);
const Color kAccent = Color(0xFFB388FF); // Accent for 'create one'

// Texts
const String kAppTitle = 'OmniView+'; // <-- Change app title here
const String kLoginButtonText = 'Login'; // <-- Change login button text here
const String kNoAccountText = 'Do not have an account? '; // <-- Change this text
const String kCreateOneText = 'create one'; // <-- Change this text

// Star positions (change these to move stars)
const double kStar1Top = 60;
const double kStar1Left = 30;
const double kStar2Top = 100;
const double kStar2Right = 40;
const double kStar3Bottom = 80;
const double kStar3Left = 50;
const double kStar4Bottom = 120;
const double kStar4Right = 60;
// ====== End Editable Variables Section ======

// Theme Notifier for app-wide theme switching
class ThemeNotifier extends ValueNotifier<bool> {
  ThemeNotifier() : super(false); // false = light, true = dark
  void toggle() => value = !value;
}

final themeNotifier = ThemeNotifier();

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: themeNotifier,
      builder: (context, isDark, _) {
        return MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            brightness: Brightness.light,
            primarySwatch: Colors.blue,
            scaffoldBackgroundColor: kWhite,
          ),
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            primarySwatch: Colors.deepPurple,
            scaffoldBackgroundColor: Colors.black,
          ),
          themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
          home: const LoginPage(),
        );
      },
    );
  }
}

// LoginPage 
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDark ? Colors.black : kWhite,
      body: Stack(
        children: [
          // Solid white background instead of gradient
          Container(
            color: isDark ? Colors.black : kWhite,
          ),
          // Theme toggle button (top right)
          Positioned(
            top: 40,
            right: 24,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              transitionBuilder: (child, anim) => RotationTransition(turns: anim, child: child),
              child: IconButton(
                key: ValueKey(isDark),
                icon: Icon(isDark ? Icons.wb_sunny : Icons.nightlight_round,
                  color: isDark ? Colors.yellow[600] : kDeepPurple,
                  size: 32,
                ),
                onPressed: () => themeNotifier.toggle(),
                tooltip: isDark ? 'Switch to Light Mode' : 'Switch to Dark Mode',
              ),
            ),
          ),
          // Star decorations (minimalist, positioned)
          StarDecorations(isDark: isDark),
          // Main content (centered)
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // OmniView+ logo/title
                // Position: Centered, Text: OmniView+, Color: Deep purple, Size: 48, FontWeight: bold
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Omni',
                        style: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : kDeepPurple,
                          letterSpacing: 2,
                        ),
                      ),
                      TextSpan(
                        text: 'View+',
                        style: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: isDark ? kDeepPurple : kDarkerPurple,
                          letterSpacing: 2,
                        ),
                      ),
                    ],
                  ),
                ),
                // To adjust the vertical position of the login and create one section (without affecting the OmniView+ title),
                // add padding or change alignment below:
                // Example: Padding(padding: EdgeInsets.only(top: 40), child: ...)
                // Adjust the gap between the OmniView+ title and the login/create one section below:
                const SizedBox(height: 350), // Change this value to adjust the gap
                // Login button and 'create one' row
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // To adjust the length of the Login button, change the width value below.
                    SizedBox(
                      width: 300, // Set to a shorter length for the button
                      height: 48,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const LoginUI(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kDeepPurple,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero, // Rectangle
                          ),
                          elevation: 4,
                        ),
                        child: Text(
                          kLoginButtonText,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8), // Minimal gap
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          kNoAccountText,
                          style: TextStyle(
                            color: kDeepPurple,
                            fontSize: 16,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const RegisterPage(),
                              ),
                            );
                          },
                          child: Text(
                            kCreateOneText,
                            style: TextStyle(
                              color: const Color.fromARGB(255, 126, 81, 204),
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class StarDecorations extends StatelessWidget {
  final bool isDark;
  const StarDecorations({Key? key, required this.isDark}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final starColor1 = isDark ? Colors.yellow[700] : const Color.fromARGB(255, 115, 100, 172);
    final starColor3 = isDark ? Colors.yellow[500] : const Color.fromARGB(255, 155, 114, 216);
    final starColor4 = isDark ? Colors.yellow[800] : const Color.fromARGB(255, 157, 140, 216);
    return Stack(
      children: [
        // Top left star
        Positioned(
          top: kStar1Top,
          left: kStar1Left,
          child: Transform.rotate(
            angle: 0.2,
            child: Icon(Icons.star, color: starColor1, size: 44),
          ),
        ),
        // Top right star
        // Extra star (top center)
        Positioned(
          top: 20,
          left: 180,
          child: Transform.rotate(
            angle: 1.2,
            child: Icon(Icons.star, color: starColor3, size: 18),
          ),
        ),
        // Bottom left star
        Positioned(
          bottom: kStar3Bottom,
          left: kStar3Left,
          child: Transform.rotate(
            angle: 0.5,
            child: Icon(Icons.star, color: starColor3, size: 32),
          ),
        ),
        // Bottom right star
        Positioned(
          bottom: kStar4Bottom,
          right: kStar4Right,
          child: Transform.rotate(
            angle: -0.6,
            child: Icon(Icons.star, color: starColor4, size: 28),
          ),
        ),
      ],
    );
  }
}
