import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:the_holy_quran/models/surah.dart';
import 'package:the_holy_quran/tabs/juzamma_tab.dart';
import 'package:the_holy_quran/tabs/surah_tab.dart';
import 'package:the_holy_quran/widgets/detail_screen.dart';

class HomeScreen extends StatefulWidget {
  final String username;

  const HomeScreen({
    super.key,
    required this.username,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<Map<String, dynamic>?> getLastRead() async {
    final prefs = await SharedPreferences.getInstance();

    final lastSurahNo = prefs.getInt('last_surah');

    if (lastSurahNo == null) return null;

    final lastAyat = prefs.getInt('last_ayat_$lastSurahNo');

    if (lastAyat == null) return null;

    final dataStr = await DefaultAssetBundle.of(context)
        .loadString('assets/datas/list-surah.json');

    final List<Surah> surahList = surahFromJson(dataStr);

    final Surah currentSurah = surahList.firstWhere(
      (surah) => surah.nomor == lastSurahNo,
    );

    return {
      'surah': currentSurah,
      'ayat': lastAyat,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // TETAP WARNA ASLI
      backgroundColor: const Color(0xff181A20),

      appBar: _appBar(),

      body: DefaultTabController(
        length: 2,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: NestedScrollView(
            headerSliverBuilder: (
              BuildContext context,
              bool innerBoxIsScrolled,
            ) =>
                [
              SliverToBoxAdapter(
                child: _greeting(widget.username),
              ),
              SliverAppBar(
                pinned: true,
                elevation: 0,

                // TETAP WARNA ASLI
                backgroundColor: const Color(0xff181A20),

                automaticallyImplyLeading: false,

                shape: Border(
                  bottom: BorderSide(
                    width: 3,

                    // TETAP WARNA ASLI
                    color: const Color(0xffFFFFFF).withOpacity(0.20),
                  ),
                ),

                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(0),
                  child: _tab(),
                ),
              ),
            ],
            body: TabBarView(
              children: [
                const SurahTab(),
                JuzammaTab(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  TabBar _tab() {
    return TabBar(
      indicatorSize: TabBarIndicatorSize.tab,

      // TETAP WARNA ASLI
      unselectedLabelColor: const Color(0xffFFFFFF).withOpacity(0.50),

      labelColor: const Color(0xffFFFFFF),

      indicatorColor: const Color(0xffFFFFFF),

      indicatorWeight: 4,

      dividerColor: const Color(0xffFAF7F0),

      tabs: [
        _tabItem(label: 'Surah'),
        _tabItem(label: 'Juzamma'),
      ],
    );
  }

  Tab _tabItem({
    required String label,
  }) {
    return Tab(
      child: Text(
        label,
        style: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Column _greeting(String username) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // =========================
        // GREETING
        // =========================
        Text(
          'Assalamualaikum',
          style: GoogleFonts.poppins(
            color: Colors.white.withOpacity(0.41),
            fontWeight: FontWeight.w500,
            fontSize: 18,
          ),
        ),

        const SizedBox(height: 1),

        Text(
          username,
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 24,
          ),
        ),

        const SizedBox(height: 20),

        // =========================
        // LAST READ
        // =========================
        Stack(
          children: [
            Container(
              height: 135,
              width: double.infinity,
              decoration: BoxDecoration(
                // TETAP WARNA ASLI
                color: const Color(0xff262A34),

                borderRadius: BorderRadius.circular(12),
              ),
            ),

            // =========================
            // GAMBAR
            // =========================
            Positioned(
              bottom: 0,
              right: 0,
              child: Image.asset(
                'assets/quran.png',
                width: 145,
                fit: BoxFit.contain,
              ),
            ),

            // =========================
            // LAST READ CONTENT
            // =========================
            FutureBuilder<Map<String, dynamic>?>(
              future: getLastRead(),
              builder: (context, snapshot) {
                final data = snapshot.data;

                final Surah? surah = data?['surah'];
                final int? ayat = data?['ayat'];

                return Positioned.fill(
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: data == null
                          ? null
                          : () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => DetailScreen(
                                    noSurat: surah!.nomor,
                                    lastAyat: ayat!,
                                  ),
                                ),
                              );
                            },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 16,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.menu_book_rounded,

                                  // TETAP WARNA ASLI
                                  color: Color(0xffFFFFFF),

                                  size: 18,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Lanjutkan Bacaan',
                                  style: GoogleFonts.poppins(
                                    color: Colors.white.withOpacity(0.55),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              surah != null ? surah.namaLatin : 'Belum Ada',
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              ayat != null ? 'Ayat No: $ayat' : 'Ayat No: -',
                              style: GoogleFonts.poppins(
                                color: Colors.white.withOpacity(0.45),
                                fontWeight: FontWeight.w500,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ],
    );
  }

  AppBar _appBar() {
    return AppBar(
      // TETAP WARNA ASLI
      backgroundColor: const Color(0xff181A20),

      automaticallyImplyLeading: false,
      elevation: 0,

      title: Row(
        children: [
          InkWell(
            onTap: () {},
            child: Icon(
              Icons.sort_rounded,
              color: Colors.white.withOpacity(0.5),
              size: 27,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            'Quran App',
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          IconButton(
            onPressed: () {},
            icon: Image.asset(
              'assets/search.png',
              width: 24,
            ),
          ),
        ],
      ),
    );
  }
}
