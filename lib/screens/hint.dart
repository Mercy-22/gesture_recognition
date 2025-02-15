import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore: must_be_immutable
class Hint extends StatelessWidget {
  VoidCallback function;
  bool hint;
  Hint({super.key, required this.hint, required this.function});

  @override
  Widget build(BuildContext context) {
    if (hint) {
      return Card(
        color: Colors.black,
        child: Column(
          children: [
            Expanded(
                child: Image.asset(
              "assets/hint.jpg",
              fit: BoxFit.cover,
            )),
            Text(
              "Keep your hand inside the focus area for better recognition.",
              style: TextStyle(
                fontFamily: GoogleFonts.aDLaMDisplay().fontFamily,
                color: Colors.white,
                fontSize: 20,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: MediaQuery.sizeOf(context).height * 0.06),
            Row(
              children: [
                Expanded(
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            elevation: 0, backgroundColor: Colors.grey[100]),
                        onPressed: function,
                        child: Text(
                          "I Understand",
                          style: TextStyle(color: Colors.black),
                        ))),
              ],
            ),
            SizedBox(height: MediaQuery.sizeOf(context).height * 0.02)
          ],
        ),
      );
    } else {
      return Container();
    }
  }
}
