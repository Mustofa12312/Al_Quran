import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/juz.dart';
import '../globals.dart';

class DetailJuzScreen extends StatefulWidget {
  final Juz juz;

  const DetailJuzScreen({super.key, required this.juz});

  @override
  State<DetailJuzScreen> createState() => _DetailJuzScreenState();
}

class _DetailJuzScreenState extends State<DetailJuzScreen> {
  final ScrollController _scrollController = ScrollController();

  bool autoScroll = false;
  double scrollSpeed = 25;

  // ============================================================
  //                      AUTO SCROLL (FIX)
  // ============================================================
  void startAutoScroll() async {
    autoScroll = true;
    setState(() {});

    while (autoScroll) {
      await Future.delayed(const Duration(milliseconds: 110));

      if (!_scrollController.hasClients) continue;

      final max = _scrollController.position.maxScrollExtent;
      final now = _scrollController.offset;

      if (now >= max) {
        stopAutoScroll();
        break;
      }

      _scrollController.animateTo(
        now + scrollSpeed,
        duration: const Duration(milliseconds: 120),
        curve: Curves.linear,
      );
    }
  }

  void stopAutoScroll() {
    autoScroll = false;
    setState(() {});
  }

  // ============================================================
  //                AUTO SCROLL MENU (BOTTOM SHEET)
  // ============================================================
  void openSpeedMenu(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: const Color(0xFF121931),
      context: context,
      builder: (_) {
        return StatefulBuilder(
          builder: (_, setSheet) {
            return Padding(
              padding: const EdgeInsets.all(25),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Auto Scroll",
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 20),

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF9055FF),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      autoScroll ? stopAutoScroll() : startAutoScroll();
                    },
                    child: Text(
                      autoScroll ? "Stop" : "Start",
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),

                  const SizedBox(height: 20),
                  Text(
                    "Kecepatan Scroll",
                    style: GoogleFonts.poppins(color: Colors.white),
                  ),

                  Slider(
                    min: 5,
                    max: 80,
                    divisions: 15,
                    activeColor: const Color(0xFF9055FF),
                    value: scrollSpeed,
                    onChanged: (v) {
                      setSheet(() => scrollSpeed = v);
                      setState(() => scrollSpeed = v);
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // ============================================================
  //                            UI
  // ============================================================
  @override
  Widget build(BuildContext context) {
    final verses = widget.juz.verses;

    return Scaffold(
      backgroundColor: const Color(0xFF121931),

      appBar: AppBar(
        backgroundColor: const Color(0xFF121931),
        elevation: 0,
        title: Row(
          children: [
            Text(
              "Juz ${widget.juz.juz}",
              style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const Spacer(),
            IconButton(
              onPressed: () => openSpeedMenu(context),
              icon: Icon(
                autoScroll ? Icons.pause_circle : Icons.play_circle_fill,
                color: Colors.white,
                size: 30,
              ),
            ),
          ],
        ),
      ),

      body: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        itemCount: verses.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) return _header(widget.juz);
          return _ayatItem(verses[index - 1]);
        },
      ),
    );
  }

  // ============================================================
  //                       HEADER JUZ
  // ============================================================
  Widget _header(Juz juz) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 30),
      child: Column(
        children: [
          Text(
            "Juz ${juz.juz}",
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            "${juz.totalVerses} Ayat",
            style: GoogleFonts.poppins(color: Colors.white70, fontSize: 16),
          ),
        ],
      ),
    );
  }

  // ============================================================
  //                  ITEM AYAT (FONT ARAB FIX)
  // ============================================================
  Widget _ayatItem(Verse ayah) {
    return Padding(
      padding: const EdgeInsets.only(top: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // HEADER AYAT
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFF1E2849),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Container(
                  width: 27,
                  height: 27,
                  decoration: BoxDecoration(
                    color: const Color(0xFF9055FF),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Center(
                    child: Text(
                      "${ayah.numberInSurah ?? ayah.number}",
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const Spacer(),
                const Icon(Icons.share, color: Colors.white),
                const SizedBox(width: 16),
                const Icon(Icons.play_circle_outline, color: Colors.white),
                const SizedBox(width: 16),
                const Icon(Icons.bookmark_add_outlined, color: Colors.white),
              ],
            ),
          ),

          const SizedBox(height: 30),

          // ARABIC TEXT — FIX (Scheherazade)
          SelectableText(
            ayah.arab,
            textAlign: TextAlign.right,
            style: const TextStyle(
              fontFamily: "Scheherazade",
              fontSize: 30,
              height: 1.5,
              color: Colors.white,
            ),
          ),

          const SizedBox(height: 10),

          // TERJEMAHAN (optional)
          if (showTranslation && ayah.translation.isNotEmpty)
            SelectableText(
              ayah.translation,
              style: GoogleFonts.poppins(
                color: Colors.white70,
                fontSize: 14,
                height: 1.6,
              ),
            ),
        ],
      ),
    );
  }
}
