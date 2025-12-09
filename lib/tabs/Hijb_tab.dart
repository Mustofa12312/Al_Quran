import 'package:flutter/material.dart';

class HijbTab extends StatelessWidget {
  const HijbTab({super.key});

  // Data Hizb: nama, surah, ayat awal (contoh sederhana)
  final List<Map<String, String>> hijbList = const [
    {"hizb": "Hizb 1", "surah": "Al-Baqarah", "ayat": "Al-Baqarah: 1"},
    {"hizb": "Hizb 2", "surah": "Al-Baqarah", "ayat": "Al-Baqarah: 26"},
    {"hizb": "Hizb 3", "surah": "Al-Baqarah", "ayat": "Al-Baqarah: 44"},
    {"hizb": "Hizb 4", "surah": "Al-Baqarah", "ayat": "Al-Baqarah: 60"},
    {"hizb": "Hizb 5", "surah": "Al-Baqarah", "ayat": "Al-Baqarah: 75"},
    {"hizb": "Hizb 6", "surah": "Al-Baqarah", "ayat": "Al-Baqarah: 92"},
    {"hizb": "Hizb 7", "surah": "Al-Baqarah", "ayat": "Al-Baqarah: 106"},
    {"hizb": "Hizb 8", "surah": "Al-Baqarah", "ayat": "Al-Baqarah: 124"},
    // Tambahkan data sesuai kebutuhan (total 60 Hizb)
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: hijbList.length,
      itemBuilder: (context, index) {
        final hijb = hijbList[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            title: Text(
              hijb["hizb"]!,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text(hijb["surah"]!, style: const TextStyle(fontSize: 16)),
                Text(
                  hijb["ayat"]!,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Aksi ketika item ditekan
              // Misalnya, navigasi ke halaman detail
            },
          ),
        );
      },
    );
  }
}
