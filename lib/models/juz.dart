import 'dart:convert';

Juz juzFromJson(String str) => Juz.fromJson(json.decode(str));
String juzToJson(Juz data) => json.encode(data.toJson());

class Juz {
  final int juz;
  final String juzStartInfo;
  final String juzEndInfo;
  final int totalVerses;

  // Verses list
  final List<Verse> verses;

  Juz({
    required this.juz,
    required this.juzStartInfo,
    required this.juzEndInfo,
    required this.totalVerses,
    required this.verses,
  });

  factory Juz.fromJson(Map<String, dynamic> json) {
    return Juz(
      juz: json["juz"] ?? 0,
      juzStartInfo: json["juzStartInfo"] ?? "",
      juzEndInfo: json["juzEndInfo"] ?? "",
      totalVerses: json["totalVerses"] ?? 0,
      verses: json["verses"] == null
          ? []
          : List<Verse>.from(json["verses"].map((x) => Verse.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
    "juz": juz,
    "juzStartInfo": juzStartInfo,
    "juzEndInfo": juzEndInfo,
    "totalVerses": totalVerses,
    "verses": List<dynamic>.from(verses.map((x) => x.toJson())),
  };
}

class Verse {
  final int? number;
  final int? numberInQuran;
  final int? numberInSurah;
  final Map<String, dynamic> text;

  Verse({
    this.number,
    this.numberInQuran,
    this.numberInSurah,
    required this.text,
  });

  factory Verse.fromJson(Map<String, dynamic> json) {
    int? number;
    int? numberInQuran;
    int? numberInSurah;

    final n = json["number"];

    if (n is int) {
      number = n;
    } else if (n is Map<String, dynamic>) {
      numberInQuran = n["inQuran"];
      numberInSurah = n["inSurah"];
    }

    return Verse(
      number: number,
      numberInQuran: numberInQuran,
      numberInSurah: numberInSurah,
      text: Map<String, dynamic>.from(json["text"] ?? {}),
    );
  }

  Map<String, dynamic> toJson() => {
    "number": number ?? {"inQuran": numberInQuran, "inSurah": numberInSurah},
    "text": text,
  };

  String get arab => text["arab"] ?? "";
  String get translation => text["translation"] ?? "";
  String get transliteration => text["transliteration"] ?? "";
}
