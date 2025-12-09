import 'dart:convert';
import 'package:al_quran_fix/globals.dart';
import 'package:al_quran_fix/models/ayat.dart';
import 'package:al_quran_fix/models/surah.dart';
import 'package:al_quran_fix/screens/search_screen.dart';
import 'package:al_quran_fix/services/bookmark_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class DetailScreen extends StatefulWidget {
  final int noSurah;
  const DetailScreen({super.key, required this.noSurah});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final ScrollController _scrollController = ScrollController();
  bool autoScroll = false;
  double scrollSpeed = 25;

  // ================================================================
  //                         AUTO SCROLL (FIX)
  // ================================================================
  void startAutoScroll() async {
    autoScroll = true;
    setState(() {});

    while (autoScroll) {
      await Future.delayed(const Duration(milliseconds: 120));

      // Fix utama → jangan scroll sebelum controller terpasang
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

  void showScrollMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF10172D),
      builder: (_) {
        return StatefulBuilder(
          builder: (context, refresh) {
            return Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Auto Scroll",
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Primary,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 12,
                      ),
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

                  const SizedBox(height: 25),

                  Text(
                    "Kecepatan Scroll",
                    style: GoogleFonts.poppins(color: Colors.white70),
                  ),
                  Slider(
                    min: 5,
                    max: 70,
                    divisions: 12,
                    activeColor: Primary,
                    value: scrollSpeed,
                    onChanged: (v) => refresh(() => scrollSpeed = v),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // ================================================================
  //                        LOAD SURAH DATA
  // ================================================================
  Future<Surah> loadSurah() async {
    String data = await rootBundle.loadString(
      "assets/datas/surah/${widget.noSurah}.json",
    );
    return Surah.fromJson(json.decode(data));
  }

  // ================================================================
  //                             UI
  // ================================================================
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Surah>(
      future: loadSurah(),
      builder: (context, snap) {
        if (!snap.hasData) {
          return Scaffold(backgroundColor: Background);
        }

        final surah = snap.data!;

        return Scaffold(
          backgroundColor: Background,
          appBar: buildAppBar(surah),

          body: ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            itemCount: surah.ayat!.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) return buildHeader(surah);
              return buildAyat(surah.ayat![index - 1]);
            },
          ),
        );
      },
    );
  }

  // ================================================================
  //                             APP BAR
  // ================================================================
  AppBar buildAppBar(Surah surah) {
    return AppBar(
      backgroundColor: Background,
      elevation: 0,
      titleSpacing: 0,
      title: Row(
        children: [
          // IconButton(
          //   onPressed: () => Navigator.pop(context),
          //   icon: SvgPicture.asset("assets/svgs/kembali.svg"),
          // ),
          SizedBox(width: 25),
          Text(
            surah.namaLatin,
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          const Spacer(),

          // SEARCH
          IconButton(
            onPressed: () async {
              String data = await rootBundle.loadString(
                "assets/datas/listsurah.json",
              );
              List<Surah> all = surahFromJson(data);

              final picked = await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => SearchScreen(allSurah: all)),
              );

              if (picked != null) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DetailScreen(noSurah: picked),
                  ),
                );
              }
            },
            icon: SvgPicture.asset("assets/svgs/cari.svg"),
          ),

          IconButton(
            onPressed: showScrollMenu,
            icon: Icon(
              autoScroll ? Icons.pause_circle : Icons.play_circle_fill,
              color: Colors.white,
              size: 28,
            ),
          ),
        ],
      ),
    );
  }

  // ================================================================
  //                         HEADER SURAH
  // ================================================================
  Widget buildHeader(Surah s) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 25),
      child: Column(
        children: [
          Text(
            s.namaLatin,
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            s.arti,
            style: GoogleFonts.poppins(color: Colors.white70, fontSize: 18),
          ),

          const SizedBox(height: 10),

          Text(
            "${s.tempatTurun.name} • ${s.jumlahAyat} Ayat",
            style: GoogleFonts.poppins(color: textt),
          ),

          const SizedBox(height: 25),

          if (s.nomor != 1 && s.nomor != 9)
            SvgPicture.asset("assets/svgs/bismillah.svg", height: 55),
        ],
      ),
    );
  }

  // ================================================================
  //                    AYAT + BOOKMARK (Fix Arabic Font)
  // ================================================================
  Widget buildAyat(Ayat ayat) {
    return FutureBuilder<bool>(
      future: BookmarkService.isBookmarked(widget.noSurah, ayat.nomor),
      builder: (context, snap) {
        bool active = snap.data ?? false;

        return Padding(
          padding: const EdgeInsets.only(top: 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // TOP BAR
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: Gray,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    // AYAT NUMBER
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: Primary,
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: Center(
                        child: Text(
                          "${ayat.nomor}",
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),

                    const Spacer(),
                    const Icon(Icons.share, color: Colors.white),
                    const SizedBox(width: 16),
                    const Icon(
                      Icons.play_circle_outline,
                      color: Colors.white,
                      size: 26,
                    ),
                    const SizedBox(width: 16),

                    GestureDetector(
                      onTap: () async {
                        if (active) {
                          await BookmarkService.removeBookmark(
                            widget.noSurah,
                            ayat.nomor,
                          );
                        } else {
                          await BookmarkService.addBookmark(
                            widget.noSurah,
                            ayat.nomor,
                            ayat.ar,
                          );
                        }
                        setState(() {});
                      },
                      child: Icon(
                        active ? Icons.bookmark : Icons.bookmark_border,
                        color: active ? Primary : Colors.white,
                        size: 28,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // ARABIC TEXT (Scheherazade Font)
              SelectableText(
                ayat.ar,
                textAlign: TextAlign.right,
                style: const TextStyle(
                  fontFamily: "Scheherazade",
                  fontSize: 28,
                  height: 1.5,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 12),

              // TRANSLATION
              if (showTranslation)
                SelectableText(
                  ayat.idn,
                  textAlign: TextAlign.justify,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    height: 1.6,
                    color: textt,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
