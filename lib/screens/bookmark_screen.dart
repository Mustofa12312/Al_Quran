import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/bookmark_service.dart';

class BookmarkScreen extends StatefulWidget {
  const BookmarkScreen({super.key});

  @override
  State<BookmarkScreen> createState() => _BookmarkScreenState();
}

class _BookmarkScreenState extends State<BookmarkScreen> {
  List<Map<String, dynamic>> items = [];

  @override
  void initState() {
    super.initState();
    loadBookmark();
  }

  void loadBookmark() async {
    items = await BookmarkService.getBookmarks();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121931),
      appBar: AppBar(
        backgroundColor: const Color(0xFF121931),
        title: Text("Bookmark", style: GoogleFonts.poppins(color: Colors.white)),
      ),
      body: items.isEmpty
          ? Center(
              child: Text("Belum ada bookmark",
                  style: GoogleFonts.poppins(color: Colors.white70)),
            )
          : ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final b = items[index];
                return ListTile(
                  title: Text(
                    "Surah ${b['surah']} : Ayat ${b['ayat']}",
                    style: GoogleFonts.poppins(color: Colors.white),
                  ),
                  subtitle: Text(
                    b['translation'],
                    style: GoogleFonts.poppins(color: Colors.white70),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.redAccent),
                    onPressed: () async {
                      await BookmarkService.removeBookmark(b['surah'], b['ayat']);
                      loadBookmark();
                    },
                  ),
                );
              },
            ),
    );
  }
}
