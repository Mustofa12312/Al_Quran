import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/juz.dart';
import '../screens/detail_juz_screen.dart';

/// ==========================
///    LIST 30 JUZ
/// ==========================
class JuzListTab extends StatelessWidget {
  const JuzListTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 30,
      itemBuilder: (context, index) {
        return ParaTab(juzNumber: index + 1);
      },
    );
  }
}

/// ==========================
///    ITEM SETIAP JUZ
/// ==========================
class ParaTab extends StatelessWidget {
  final int juzNumber;

  const ParaTab({super.key, required this.juzNumber});

  Future<Juz> _loadJuz(int juz) async {
    final String response = await rootBundle.loadString(
      "assets/datas/juz/$juz.json",
    );

    return Juz.fromJson(json.decode(response)["data"]);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Juz>(
      future: _loadJuz(juzNumber),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.all(20),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          return Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              "Error memuat Juz $juzNumber",
              style: const TextStyle(color: Colors.redAccent),
            ),
          );
        }

        if (!snapshot.hasData) {
          return const SizedBox();
        }

        final juzData = snapshot.data!;

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => DetailJuzScreen(juz: juzData)),
            );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            margin: const EdgeInsets.only(bottom: 4),
            child: Row(
              children: [
                /// Nomor Juz
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.deepPurple,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      juzData.juz.toString(),
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 16),

                /// Info Juz
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Juz ${juzData.juz}",
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 4),

                      Text(
                        "${juzData.juzStartInfo} → ${juzData.juzEndInfo}",
                        style: GoogleFonts.poppins(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),

                      const SizedBox(height: 2),

                      Text(
                        "${juzData.totalVerses} ayat",
                        style: GoogleFonts.poppins(
                          color: Colors.white38,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
