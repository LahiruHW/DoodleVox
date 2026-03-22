import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';

class DVLogo extends StatelessWidget {
  const DVLogo({
    super.key,
    this.size = 150,
  });

  final double size;

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: .contain,
      child: Image.asset(
        'assets/images/icon/dv_icon_1_${Theme.of(context).colorScheme.surface.computeLuminance() > 0.5 ? 'light' : 'dark'}_transparent.png',
        width: size,
        height: size,
      ),
      // child: Text.rich(
      //   TextSpan(
      //     children: [
      //       TextSpan(
      //         text: 'Doodle',
      //         style: GoogleFonts.sassyFrass(
      //           fontSize: 24,
      //           fontWeight: FontWeight.bold,
      //           color: Theme.of(context).colorScheme.onSurface,
      //         ),
      //       ),
      //       TextSpan(
      //         text: 'Vox',
      //         style: TextStyle(
      //           fontSize: 24,
      //           fontWeight: FontWeight.bold,
      //           color: Theme.of(context).colorScheme.primary,
      //         ),
      //       ),
      //     ],
      //   ),
      // ),
    );
  }
}
