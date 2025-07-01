import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:datahoops/routes.dart';

class ManageTeam extends StatelessWidget {
  const ManageTeam({super.key});

  @override
  Widget build(BuildContext context) {
    const Color accentColor = Color(0xFFEF6C00);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: accentColor.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.group, size: 80, color: accentColor),
            ),
            const SizedBox(height: 24),
            Text(
              'Gerencie seu time e jogadores',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.w600, color: Colors.white),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: accentColor,
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                textStyle: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              onPressed: () => Navigator.pushNamed(context, Routes.addTeam),
              child: const Text('Criar Time'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: accentColor,
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                textStyle: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              onPressed: () => Navigator.pushNamed(context, Routes.addPlayer),
              child: const Text('Criar Jogador'),
            ),
            const SizedBox(height: 16),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                side: const BorderSide(color: accentColor),
                textStyle: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              onPressed: () => Navigator.pushNamed(context, Routes.teamList),
              child: const Text('Ver Times', style: TextStyle(color: accentColor)),
            ),
          ],
        ),
      ),
    );
  }
}