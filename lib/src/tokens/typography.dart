import 'package:ctpat/src/tokens/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

TextStyle get body {
  return GoogleFonts.inter(
    fontWeight: FontWeight.w400,
    fontSize: 14,
    color: Color(0xFF646C7D),
    height: 1.3,
  );
}

TextStyle get bodyGray40 {
  return GoogleFonts.poppins(
    fontWeight: FontWeight.w400,
    fontSize: 14,
    color: Color(0xFFBBC0C9),
    height: 1.3,
  );
}

TextStyle get bodyBlack {
  return GoogleFonts.poppins(
    fontWeight: FontWeight.w400,
    fontSize: 14,
    color: textBlack,
    height: 1.3,
  );
}

TextStyle get subtitle {
  return GoogleFonts.poppins(
      fontWeight: FontWeight.w600, fontSize: 12, color: textGray100);
}

TextStyle get subHeading2White {
  return GoogleFonts.poppins(
    fontWeight: FontWeight.w600,
    fontSize: 14,
    color: Colors.white,
  );
}

TextStyle get subHeading2Black {
  return GoogleFonts.poppins(
    fontWeight: FontWeight.w600,
    fontSize: 14,
    color: Colors.black,
  );
}

TextStyle get heading2Black {
  return GoogleFonts.poppins(
    fontWeight: FontWeight.w600,
    fontSize: 16,
    color: Colors.black,
  );
}

TextStyle get heading2Primary {
  return GoogleFonts.poppins(
      fontWeight: FontWeight.w600, fontSize: 16, color: primaryClr);
}

TextStyle get bodyLink {
  return GoogleFonts.poppins(
    fontWeight: FontWeight.w600,
    fontSize: 14,
    color: primaryClr,
    height: 1.3,
  );
}
