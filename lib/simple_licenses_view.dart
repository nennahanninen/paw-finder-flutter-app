import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SimpleLicensesView extends StatelessWidget {
  const SimpleLicensesView({super.key});

  @override
  Widget build(BuildContext context) => Theme(
        data: ThemeData(
          primaryColor: const Color(0xffFF966A),
          appBarTheme: const AppBarTheme(
            color: Color(0xffFF966A),
            iconTheme: IconThemeData(color: Colors.white),
          ),
          colorScheme: ColorScheme.fromSwatch()
              .copyWith(secondary: const Color(0xffFF966A)),
          fontFamily: GoogleFonts.quicksand().fontFamily,
        ),
        child: LicensePage(
            applicationName: 'Paw Finder',
            applicationIcon: Image.asset('assets/logo/dog_paw_logo.png',
                height: 48, width: 48),
            applicationVersion: '1.0.0',
            applicationLegalese: '© 2023 Paw Finder'),
      );
}
