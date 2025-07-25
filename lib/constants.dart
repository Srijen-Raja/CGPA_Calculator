import 'package:flutter/material.dart';

class Constants {
  String theme;
  Color backcolor;
  Color textcolor;
  Color sepcolor;
  Color highcolor;
  Color cardcolor;
  Color bordcolor;
  Color unscolor;
  Color butcolor;
  Color iconcolor;

  Constants({
    required this.theme,
    required this.backcolor,
    required this.textcolor,
    required this.sepcolor,
    required this.highcolor,
    required this.cardcolor,
    required this.bordcolor,
    required this.unscolor,
    required this.butcolor,
    required this.iconcolor,
  });
}

List<Constants> themes = [
  Constants(
    theme: "White",
    backcolor: Color(0xFFFCF5FD),
    butcolor: Color(0xFFF3EEFC),
    bordcolor: Color(0xFF000000),
    cardcolor: Color(0xFFFCF2FD),
    textcolor: Colors.black87,
    sepcolor: Colors.black38,
    highcolor: Colors.deepPurple,
    unscolor: Color(0xA6463E4D),
    iconcolor: Color(0xEA222122),
  ),
  Constants(
    theme: "Blue",
    backcolor: Color(0xFF01011C),
    butcolor: Color(0xFF0A0A44),
    bordcolor: Color(0xFFFFFFFF),
    //cardcolor: Color(0xFF1D2121),
    cardcolor: Color(0xFF010125),
    //textcolor: Color(0xD2C4571C),
    textcolor: Color(0xFF4090B2),
    sepcolor: Color(0xFF0F2628),
    highcolor: Color(0xFFBF3E0B),
    unscolor: Colors.white38,
    iconcolor: Color(0xFF645E69),
  ),
  Constants(
    theme: "Black",
    backcolor: Color(0xFF0D0D0D),
    butcolor: Color(0xFF19191C),
    bordcolor: Color(0xE5FFFFFF),
    //cardcolor: Color(0xFF1D2121),
    cardcolor: Color(0xFF141414),
    //textcolor: Color(0xD2C4571C),
    textcolor: Color(0xFFC0C2C5),
    sepcolor: Color(0xFF312F31),
    highcolor: Colors.deepPurple,
    unscolor: Colors.white38,
    iconcolor: Colors.white38,
  ),
  Constants(
    theme: "Lilac",
    backcolor: Color(0xFFE5C2EF),
    butcolor: Color(0xFFE1B1EF),
    bordcolor: Color(0xFF0C0C0C),
    cardcolor: Color(0xFFE1BEEC),
    textcolor: Color(0xFF1F1717),
    sepcolor: Color(0xFF757575),
    highcolor: Color(0xFF0D57E1),
    unscolor: Color(0xFF766B80),
    iconcolor: Color(0xE21E1D21),
  ),
  Constants(
    theme: "Brown",
    backcolor: Color(0xFF77583D),
    butcolor: Color(0xFF85674A),
    bordcolor: Color(0xFF0C0C0C),
    cardcolor: Color(0xFF7E5E42),
    textcolor: Color(0xFF110E0E),
    sepcolor: Color(0xFF0A0A0A),
    highcolor: Color(0xFF311700),
    unscolor: Color(0xFF423223),
    iconcolor: Color(0xFF000000),
  ),
  /*Constants(
    theme: "Brown",
    backcolor: Color(0xFF77583D),
    butcolor: Color(0xFF86694C),
    bordcolor: Color(0xFF0C0C0C),
    cardcolor: Color(0xFF7E5E42),
    textcolor: Color(0xFF1F1717),
    sepcolor: Color(0xFF1C1C1C),
    highcolor: Color(0xFF311700),
    unscolor: Color(0xFF423223),
    iconcolor: Color(0xE21E1D21),
  ),*/
];
