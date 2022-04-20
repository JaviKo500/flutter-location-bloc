import 'package:flutter/material.dart';

class EndMarkerPainter extends CustomPainter {
  final double kilometers;
  final String destination;

  EndMarkerPainter({
    required this.kilometers, 
    required this.destination
  });

  @override
  void paint(Canvas canvas, Size size) {
    final blackPaint = Paint()
                        ..color = Colors.black;
    final whitePaint = Paint()
                        ..color = Colors.white;
    const double circleBlackRadius = 20;
    const double circleWhiteRadius = 7;
    // circle black
    canvas.drawCircle( 
      Offset( size.width * 0.5, size.height - circleBlackRadius  ), 
      circleBlackRadius, 
      blackPaint
    );
    // circle white
    canvas.drawCircle( 
      Offset( size.width *0.5, size.height - circleBlackRadius  ), 
      circleWhiteRadius, 
      whitePaint
    );

    // draw box white
    final path = Path();
    path.moveTo( 10, 20 );
    path.lineTo( size.width - 10, 20 );
    path.lineTo( size.width - 10, 100 );
    path.lineTo( 10, 100 );

    // shadow
    canvas.drawShadow(path, Colors.black, 10, false);

    canvas.drawPath(path, whitePaint);

    // box black
    const blackBox = Rect.fromLTWH(10, 20, 70, 80);

    canvas.drawRect(blackBox, blackPaint);

    // text
    // minutes
    final textKilometers = kilometers > 1 ? kilometers.toInt() : kilometers;
    final textSpan = TextSpan(
      style: const TextStyle( color: Colors.white, fontSize: 30, fontWeight: FontWeight.w400),
      text: '$textKilometers'
    );

    final minutesPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center
    )..layout(
      minWidth: 70,
      maxWidth: 70
    );

    minutesPainter.paint(canvas, const Offset(10, 35));

    // World MIN
    const minutesText = TextSpan(
      style: TextStyle( color: Colors.white, fontSize: 20, fontWeight: FontWeight.w400),
      text: 'Kms'
    );

    final minutesMinPainter = TextPainter(
      text: minutesText,
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center
    )..layout(
      minWidth: 70,
      maxWidth: 70
    );
    // info
    minutesMinPainter.paint(canvas, const Offset(10, 65));

    // description
    // World location text
    final locationText = TextSpan(
      style: const TextStyle( color: Colors.black, fontSize: 20, fontWeight: FontWeight.w400),
      text: destination
    );
    final locationMinPainter = TextPainter(
      maxLines: 2,
      ellipsis: '...',
      text: locationText,
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.left
    )..layout(
      minWidth: size.width -95,
      maxWidth: size.width -95
    );
    
    final double offsetY = ( destination.length > 25 ) ? 35: 48;
    locationMinPainter.paint( canvas, Offset( 90, offsetY ) );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;

  @override
  bool shouldRebuildSemantics(covariant CustomPainter oldDelegate) => false;
  
}