import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:the_holy_quran/navigation/main_navigation.dart';
import 'package:the_holy_quran/utils/username_validator.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final FocusNode _nameFocus = FocusNode();

  bool isFocused = false;

  @override
  void initState() {
    super.initState();

    _nameFocus.addListener(() {
      if (!mounted) return;

      setState(() {
        isFocused = _nameFocus.hasFocus;
      });
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        FocusScope.of(context).requestFocus(_nameFocus);
      }
    });
  }

  @override
  void dispose() {
    _nameFocus.dispose();
    nameController.dispose();
    super.dispose();
  }

  void _startLearning() {
    if (_formKey.currentState!.validate()) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => MainNavigation(
            username: nameController.text.trim(),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.sizeOf(context).height;

    final double headerSpacing = screenHeight < 700 ? 35 : 65;
    final double inputToCardSpacing = screenHeight < 700 ? 30 : 55;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xff181A20),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            top: 40,
            left: 25,
            right: 25,
            bottom: 25,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // =========================
              // HEADER
              // =========================
              Row(
                children: [
                  Text(
                    'Assalamu’alaikum',
                    style: GoogleFonts.poppins(
                      color: const Color(0xffFFFFFF),
                      fontWeight: FontWeight.w700,
                      fontSize: 22,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Image.asset(
                    'assets/moon.png',
                    width: 26,
                  ),
                ],
              ),

              const SizedBox(height: 2),

              Text(
                'Selamat datang di The Holy Quran',
                style: GoogleFonts.poppins(
                  color: const Color(0xffFFFFFF).withOpacity(0.55),
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),

              SizedBox(height: headerSpacing),

              // =========================
              // DESCRIPTION
              // =========================
              Text(
                'Belajar Al-Qur’an jadi lebih mudah dan menyenangkan!',
                style: GoogleFonts.poppins(
                  color: const Color(0xffFFFFFF).withOpacity(0.55),
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 13),

              // =========================
              // USERNAME
              // =========================
              Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: TextFormField(
                  autofocus: true,
                  validator: UsernameValidator.validate,
                  controller: nameController,
                  textCapitalization: TextCapitalization.words,
                  focusNode: _nameFocus,
                  onTap: () {
                    setState(() {
                      isFocused = true;
                    });
                  },
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    color: const Color(0xffFFFFFF),
                  ),
                  decoration: InputDecoration(
                    hintText: isFocused ? "" : "Masukan Username",
                    prefixText: isFocused ? "Nama : " : null,

                    // TETAP WARNA ASLI
                    fillColor: const Color(0xff262A34).withOpacity(0.85),
                    filled: true,

                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 18,
                      horizontal: 14,
                    ),

                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),

                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),

                    hintStyle: GoogleFonts.poppins(
                      color: const Color(0xffFFFFFF),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              SizedBox(height: inputToCardSpacing),

              // =========================
              // QURAN ILLUSTRATION
              // =========================
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final double cardHeight = constraints.maxHeight < 450
                          ? constraints.maxHeight
                          : 450;

                      return Align(
                        alignment: Alignment.topCenter,
                        child: Stack(
                          clipBehavior: Clip.none,
                          alignment: Alignment.topCenter,
                          children: [
                            Container(
                              width: double.infinity,
                              height: cardHeight,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),

                                // TETAP WARNA ASLI
                                color:
                                    const Color(0xff262A34).withOpacity(0.95),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(30),
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 17),
                                  child: Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Image.asset(
                                      'assets/splash.png',
                                      width: double.infinity,
                                      fit: BoxFit.contain,
                                      alignment: Alignment.bottomCenter,
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            // =========================
                            // START BUTTON
                            // =========================
                            Positioned(
                              top: -23,
                              left: 0,
                              right: 0,
                              child: Center(
                                child: GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: _startLearning,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 40,
                                      vertical: 16,
                                    ),
                                    decoration: BoxDecoration(
                                      // TETAP WARNA ASLI
                                      color: const Color(0xffA8AAB6),
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    child: Text(
                                      'Mulai Belajar',
                                      style: GoogleFonts.poppins(
                                        color: const Color(0xffFFFFFF),
                                        fontWeight: FontWeight.w600,
                                        fontSize: 17,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
