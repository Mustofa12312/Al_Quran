import 'package:flutter/material.dart';

class PageTab extends StatelessWidget {
  const PageTab({super.key});

  @override
  Widget build(BuildContext context) {
    // Contoh: Tampilkan daftar halaman 1-604
    return ListView.builder(
      itemCount: 604,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.deepPurple,
              child: Text(
                '${index + 1}',
                style: const TextStyle(color: Colors.white),
              ),
            ),
            title: Text('Halaman ${index + 1}'),
            subtitle: const Text('Klik untuk membuka halaman ini'),
            onTap: () {
              // Aksi jika ingin navigasi ke halaman tertentu
            },
          ),
        );
      },
    );
  }
}
