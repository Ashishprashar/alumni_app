import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/*
 headliine1 is too big not using for anything for now.
 headline2 is for all big headlines, example the in the privacy screen. those headlines 
 are headline2.
 headline4 is for things like the user's name
 headline6 is for the app bar title
 bodyText1 for the body of the things in the privacy page
 bodyText2 not using for now
 subtitle1 for things like the atrribrutes of profile eg: skills, interests 
 (sub headings like that).
 subtitle2 for the body of those attributes. so example the entire paragraph of bio.
 textTheme.button for texts in buttons
*/

class AppTheme {
  AppTheme._();

  static final ThemeData lightTheme = ThemeData(
    appBarTheme: AppBarTheme(
      // color: Colors.white,
      backgroundColor: Colors.white,
      shadowColor: Colors.transparent.withOpacity(.1),
      iconTheme: const IconThemeData(
        // color: Color.fromRGBO(255, 0, 92, 1),
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
                  color: const Color.fromRGBO(255, 0, 92, 1),
                  fontSize: 20,
                  fontWeight: FontWeight.w600))
          .headline6,
    ),
    hoverColor: Colors.black,
    primaryColor: Colors.pink,
    // bottomSheetTheme: const BottomSheetThemeData(backgroundColor: Colors.white),
    backgroundColor: Colors.white,
    // scaffoldBackgroundColor: const Color.fromARGB(255, 255, 255, 255),
    scaffoldBackgroundColor: Colors.white,
    splashColor: Colors.pink,
    toggleableActiveColor: Colors.grey,
    iconTheme: const IconThemeData(
      color: Colors.grey,
    ),
    errorColor: const Color.fromRGBO(255, 0, 92, 1),
    hintColor: Colors.grey,
    cardColor: Colors.grey[100],
    highlightColor: Colors.grey[700],
    indicatorColor: Colors.pink[100],
    selectedRowColor: Colors.grey[200],
    textTheme: TextTheme(
      headline1: GoogleFonts.openSans(color: Colors.black, fontSize: 30),
      headline2: GoogleFonts.openSans(
          color: Colors.black, fontSize: 21, fontWeight: FontWeight.w700),
      headline3: GoogleFonts.openSans(
          color: Colors.black, fontSize: 16, fontWeight: FontWeight.w600),
      headline4: GoogleFonts.openSans(
          color: Colors.black, fontSize: 16, fontWeight: FontWeight.w700),
      bodyText1: GoogleFonts.openSans(
          color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500),
      bodyText2: GoogleFonts.openSans(
          color: Colors.black, fontSize: 16, fontWeight: FontWeight.w700),
      subtitle1: GoogleFonts.openSans(
          color: const Color.fromRGBO(164, 164, 178, 1),
          fontSize: 14,
          fontWeight: FontWeight.w700),
      subtitle2: GoogleFonts.openSans(
          color: Colors.black, fontSize: 21, fontWeight: FontWeight.w300),
      labelMedium: GoogleFonts.openSans(
          color: Colors.grey, fontSize: 16, fontWeight: FontWeight.w900),
    ),
    // colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.white),
    colorScheme: ColorScheme.fromSwatch().copyWith(
      brightness: Brightness.light,
      // primary: Colors.pink,
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.black54,
      shadowColor: Colors.transparent.withOpacity(.1),
      iconTheme: const IconThemeData(
        // color: Color.fromRGBO(255, 0, 92, 1),
        color: Colors.white,
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
    backgroundColor: Colors.black54,
    hoverColor: Colors.white,
    primaryColor: Colors.pink,
    hintColor: Colors.grey,
    highlightColor: Colors.white,
    cardColor: Colors.grey[100],
    splashColor: Colors.pink,
    toggleableActiveColor: Colors.white70,
    scaffoldBackgroundColor: Colors.black54,
    iconTheme: const IconThemeData(
      color: Colors.white,
    ),
    canvasColor: Colors.black,
    selectedRowColor: Colors.grey[900],
    indicatorColor: Colors.pink[800],
    errorColor: Colors.white,
    textTheme: TextTheme(
      caption:
          const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
      headline1: GoogleFonts.openSans(color: Colors.white, fontSize: 30),
      headline2: GoogleFonts.openSans(
          color: Colors.white, fontSize: 21, fontWeight: FontWeight.w700),
      headline3: GoogleFonts.openSans(
          color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
      headline4: GoogleFonts.openSans(
          color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700),
      bodyText1: GoogleFonts.openSans(
          color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
      bodyText2: GoogleFonts.openSans(
          color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700),
      subtitle1: GoogleFonts.openSans(
          color: const Color.fromRGBO(164, 164, 178, 1),
          fontSize: 14,
          fontWeight: FontWeight.w700),
      subtitle2: GoogleFonts.openSans(
          color: Colors.white, fontSize: 21, fontWeight: FontWeight.w300),
      labelMedium: GoogleFonts.openSans(
          color: Colors.grey, fontSize: 16, fontWeight: FontWeight.w500),
    ),
    colorScheme: ColorScheme.fromSwatch().copyWith(
      brightness: Brightness.dark,
      // primary: Colors.pink,
      // secondary: Colors.black,
    ),
  );
}
