import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Custombutton extends StatelessWidget {
  final String text;
  final VoidCallback? onpressed;

  const Custombutton({super.key, required this.text, this.onpressed});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () => onpressed!(),
          child: Container(
            child:  Center(child: Text(text,style:  GoogleFonts.poppins(color: Colors.black,fontSize: 11,fontWeight: FontWeight.w400),)),
            width: 135,
            height: 28,
            decoration: ShapeDecoration(
              color: const Color(0xFFFCF6BD),
              shape: RoundedRectangleBorder(
                side: const BorderSide(width: 0.40),
                borderRadius: BorderRadius.circular(20),
              ),
              shadows: const [
                BoxShadow(
                  color: Color(0x3F000000),
                  blurRadius: 1,
                  offset: Offset(1, 1),
                  spreadRadius: 0,
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
