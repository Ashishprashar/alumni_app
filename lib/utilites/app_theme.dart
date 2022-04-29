import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  AppTheme._();

  static final ThemeData lightTheme = ThemeData(
    appBarTheme: AppBarTheme(
      // color: Colors.white,
      backgroundColor: Colors.transparent,
      shadowColor: Colors.transparent.withOpacity(.1),

      iconTheme: const IconThemeData(
        color: Color.fromRGBO(255, 0, 92, 1),
      ),
      toolbarTextStyle: TextTheme(
              headline1: GoogleFonts.openSans(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w600))
          .bodyText2,
      titleTextStyle: TextTheme(
              headline1: GoogleFonts.openSans(
                  color: const Color.fromRGBO(255, 0, 92, 1),
                  fontSize: 20,
                  fontWeight: FontWeight.w600))
          .headline6,
    ),
    primaryColor: Colors.blue,
    brightness: Brightness.light,
    backgroundColor: Colors.white,
    scaffoldBackgroundColor: const Color.fromARGB(255, 223, 240, 248),
    splashColor: Colors.blue,
    // splashColor: const Color(0xFFA866EE),
    iconTheme: const IconThemeData(
      color: Colors.grey,
    ),

    hintColor: Colors.grey,
    cardColor: Colors.white,
    highlightColor: Colors.grey[700],
    textTheme: TextTheme(
      headline1: GoogleFonts.openSans(color: Colors.black, fontSize: 30),
      headline2: GoogleFonts.openSans(
          color: Colors.black, fontSize: 16, fontWeight: FontWeight.w700),
      headline3: GoogleFonts.openSans(
          color: const Color(0xff484860),
          fontSize: 18,
          fontWeight: FontWeight.w500),
      bodyText1: GoogleFonts.openSans(
          color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500),
      subtitle1: GoogleFonts.openSans(
          color: const Color.fromRGBO(164, 164, 178, 1),
          fontSize: 14,
          fontWeight: FontWeight.w500),
      labelMedium: GoogleFonts.openSans(
          color: Colors.black, fontSize: 12, fontWeight: FontWeight.w600),
      subtitle2: GoogleFonts.openSans(
          color: Colors.black, fontSize: 20, fontWeight: FontWeight.w300),
      bodyText2: GoogleFonts.openSans(color: Colors.black, fontSize: 20),
      // headline3: GoogleFonts.openSans(
      //     color: Colors.grey, fontSize: 16, fontWeight: FontWeight.bold),
    ),
    colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.white),
  );

  static final ThemeData darkTheme = ThemeData(
    appBarTheme: AppBarTheme(
      // color: Colors.grey[800],
      iconTheme: const IconThemeData(
        color: Color.fromRGBO(255, 0, 92, 1),
      ),
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
    highlightColor: Colors.white,
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
