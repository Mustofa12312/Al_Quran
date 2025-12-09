import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vibration/vibration.dart';

class TasbihTab extends StatefulWidget {
  const TasbihTab({super.key});

  @override
  State<TasbihTab> createState() => _TasbihTabState();
}

class _TasbihTabState extends State<TasbihTab> with TickerProviderStateMixin {
  int counter = 0;
  int target = 33;
  bool vibration = true;

  late AnimationController beadController;

  @override
  void initState() {
    super.initState();

    // animasi biji tasbih berputar
    beadController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      lowerBound: -0.15,
      upperBound: 0.15,
    );

    // aktifkan tombol volume
    HardwareKeyboard.instance.addHandler(_onKeyEvent);
  }

  @override
  void dispose() {
    HardwareKeyboard.instance.removeHandler(_onKeyEvent);
    beadController.dispose();
    super.dispose();
  }

  // tombol volume
  bool _onKeyEvent(KeyEvent event) {
    if (event is KeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.audioVolumeUp) {
        increment();
        return true;
      }
      if (event.logicalKey == LogicalKeyboardKey.audioVolumeDown) {
        decrement();
        return true;
      }
    }
    return false;
  }

  // vibrasi
  Future<void> vibrateSoft() async {
    if (await Vibration.hasVibrator() ?? false) {
      Vibration.vibrate(duration: 70, amplitude: 180);
    }
  }

  Future<void> vibrateStrong3x() async {
    if (await Vibration.hasVibrator() ?? false) {
      Vibration.vibrate(
        pattern: [0, 200, 120, 200, 120, 200],
        intensities: [255, 255, 255],
      );
    }
  }

  // tambah hitungan
  void increment() {
    beadController.forward(from: 0);

    setState(() => counter++);

    if (counter >= target) {
      vibrateStrong3x();
      counter = 0;
    } else if (vibration) {
      vibrateSoft();
    }
  }

  // kurangi hitungan
  void decrement() {
    if (counter > 0) {
      beadController.forward(from: 0);
      setState(() => counter--);
      if (vibration) vibrateSoft();
    }
  }

  // reset
  void reset() {
    vibrateStrong3x();
    setState(() => counter = 0);
  }

  // UI TASBIH
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1324),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 40),

              Text(
                "Digital Tasbih",
                style: GoogleFonts.poppins(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 40),

              // counter display
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.all(35),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF8A2EFF), Color(0xFF6100FF)],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.purple.withOpacity(0.4),
                      blurRadius: 25,
                    ),
                  ],
                ),
                child: Text(
                  "$counter",
                  style: GoogleFonts.poppins(
                    fontSize: 60,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // ANIMASI BIJI TASBIH
              AnimatedBuilder(
                animation: beadController,
                builder: (context, child) {
                  return Transform.rotate(
                    angle: beadController.value,
                    child: child,
                  );
                },
                child: GestureDetector(
                  onTap: increment,
                  child: Container(
                    width: 160,
                    height: 160,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [Color(0xFF9C27FF), Color(0xFF6200EA)],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.purple.withOpacity(0.5),
                          blurRadius: 30,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: const Icon(Icons.add, size: 80, color: Colors.white),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    // pilih target
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Target:",
                          style: TextStyle(color: Colors.white, fontSize: 17),
                        ),

                        const SizedBox(width: 15),

                        DropdownButton<int>(
                          dropdownColor: Color(0xFF1A2036),
                          value: target,
                          style: const TextStyle(color: Colors.white),
                          items: [11, 33, 100, 300].map((e) {
                            return DropdownMenuItem(
                              value: e,
                              child: Text(
                                "$e",
                                style: TextStyle(color: Colors.white),
                              ),
                            );
                          }).toList(),
                          onChanged: (v) {
                            if (v != null) setState(() => target = v);
                          },
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // reset + vibration toggle
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton.icon(
                          onPressed: reset,
                          icon: const Icon(Icons.refresh),
                          label: const Text("Reset"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 25,
                              vertical: 14,
                            ),
                          ),
                        ),

                        Row(
                          children: [
                            const Text(
                              "Vibration",
                              style: TextStyle(color: Colors.white),
                            ),
                            Switch(
                              value: vibration,
                              activeColor: Colors.greenAccent,
                              onChanged: (v) => setState(() => vibration = v),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              Text(
                "Gunakan tombol volume untuk /menam                       bah / mengurangi.",
                style: TextStyle(color: Colors.white54, fontSize: 12),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
