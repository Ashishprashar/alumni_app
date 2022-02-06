import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  AppTheme._();

  static final ThemeData lightTheme = ThemeData(
    appBarTheme: AppBarTheme(
      color: Colors.white,
      iconTheme: const IconThemeData(
        color: Colors.black,
      ),
      toolbarTextStyle: TextTheme(
              headline1: GoogleFonts.openSans(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w600))
          .bodyText2,
      titleTextStyle: TextTheme(
              headline1: GoogleFonts.openSans(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w600))
          .headline6,
    ),
    primaryColor: Colors.black,
    brightness: Brightness.light,
    scaffoldBackgroundColor: Colors.white,
    splashColor: Colors.blue,
    iconTheme: const IconThemeData(
      color: Colors.black,
    ),
    hintColor: Colors.grey,
    cardColor: Colors.white,
    textTheme: TextTheme(
      headline1: GoogleFonts.openSans(color: Colors.black, fontSize: 30),
      headline2: GoogleFonts.openSans(
          color: Colors.black, fontSize: 20, fontWeight: FontWeight.w600),
      bodyText1: GoogleFonts.openSans(color: Colors.grey[600], fontSize: 20),
      subtitle1: GoogleFonts.openSans(
          color: Colors.black, fontSize: 20, fontWeight: FontWeight.w600),
      subtitle2: GoogleFonts.openSans(
          color: Colors.black, fontSize: 20, fontWeight: FontWeight.w300),
      bodyText2: GoogleFonts.openSans(color: Colors.black, fontSize: 20),
      headline3: GoogleFonts.openSans(
          color: Colors.grey, fontSize: 16, fontWeight: FontWeight.bold),
    ),
    colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.white),
  );

  static final ThemeData darkTheme = ThemeData(
    appBarTheme: AppBarTheme(
      color: Colors.grey[800],
      toolbarTextStyle: TextTheme(
              headline1: GoogleFonts.openSans(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w600))
          .bodyText2,
      titleTextStyle: TextTheme(
              headline1: GoogleFonts.openSans(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w600))
          .headline6,
    ),
    hintColor: Colors.grey,
    cardColor: Colors.black,
    splashColor: Colors.grey,
    //primaryColor: Colors.blue[900],
    primaryColor: Colors.grey[800],
    brightness: Brightness.dark,
    scaffoldBackgroundColor: Colors.black,
    iconTheme: const IconThemeData(
      color: Colors.white,
    ),
    textTheme: TextTheme(
      headline1: GoogleFonts.openSans(color: Colors.white, fontSize: 30),
      headline2: GoogleFonts.openSans(color: Colors.white, fontSize: 20),
      bodyText1: GoogleFonts.openSans(color: Colors.white, fontSize: 16),
      subtitle1: GoogleFonts.openSans(
          color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600),
      subtitle2: GoogleFonts.openSans(
          color: Colors.black, fontSize: 20, fontWeight: FontWeight.w600),
      bodyText2: GoogleFonts.openSans(color: Colors.white, fontSize: 20),
      headline3: GoogleFonts.openSans(
          color: Colors.grey, fontSize: 20, fontWeight: FontWeight.bold),
    ),
    colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.black),
  );
}
