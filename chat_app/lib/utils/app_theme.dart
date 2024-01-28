import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData lightThemeData(BuildContext context) {
  return ThemeData(
    primaryColor: kPrimaryColor,
    //buttonColor: kPrimaryColor,
    colorScheme: const ColorScheme.light(
      primary: kPrimaryColor,
      secondary: kPrimaryColor,
    ),
    indicatorColor: Colors.white,
    splashColor: Colors.white24,
    splashFactory: InkRipple.splashFactory,
    //accentColor: kPrimaryColor,
    //fontFamily: "WorkSans",
    shadowColor: Theme.of(context).disabledColor,
    dividerColor: const Color(0xff707070),
    canvasColor: Colors.white,
    backgroundColor: const Color(0xFFFFFFFF),
    scaffoldBackgroundColor: const Color(0xFFF5F5F5),
    errorColor: kErrorColor,
    textTheme: getTextTheme(),
    primaryTextTheme: getTextTheme(),
    //accentTextTheme: getTextTheme(),
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );
}

ThemeData darkThemeData(BuildContext context) {
  return ThemeData(
    scaffoldBackgroundColor: Colors.grey.shade900,
    primaryColor: kPrimaryColor,
    colorScheme: const ColorScheme.dark(),
    indicatorColor: Colors.white,
    splashColor: Colors.white24,
    splashFactory: InkRipple.splashFactory,
    //accentColor: kPrimaryColor,
    // fontFamily: "WorkSans",
    shadowColor: Theme.of(context).disabledColor,
    dividerColor: const Color(0xff707070),
    canvasColor: Colors.white,
    backgroundColor: Colors.black,
    errorColor: kErrorColor,
    textTheme: getTextTheme(),
    primaryTextTheme: getTextTheme(),
    //accentTextTheme: getTextTheme(),
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );
}

TextTheme getTextTheme() {
  return TextTheme(
    bodyText1: GoogleFonts.workSans(),
    bodyText2: GoogleFonts.workSans(),
    headline1: GoogleFonts.workSans(),
    headline2: GoogleFonts.workSans(),
    headline3: GoogleFonts.workSans(),
    headline4: GoogleFonts.workSans(),
    headline5: GoogleFonts.workSans(),
    headline6: GoogleFonts.workSans(),
    subtitle1: GoogleFonts.workSans(),
    subtitle2: GoogleFonts.workSans(),
    button: GoogleFonts.workSans(),
    caption: GoogleFonts.workSans(),
    overline: GoogleFonts.workSans(),
  );
}

const Color kPrimaryColor = Color(0xffF76C6C);
const Color kSecondaryColor = Color(0xFFFE9901);
const Color kContentColorLightTheme = Color(0xFF1D1D35);
const Color kContentColorDarkTheme = Color(0xFFF5FCF9);
const Color kWarningColor = Color(0xFFF3BB1C);
const Color kErrorColor = Color(0xFFF03738);

const double kDefaultPadding = 20.0;

AppBarTheme appBarTheme = const AppBarTheme(centerTitle: false, elevation: 0);
