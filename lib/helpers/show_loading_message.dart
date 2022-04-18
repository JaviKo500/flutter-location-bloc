import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void showLoadingMessage( BuildContext context) {

  if ( Platform.isAndroid ) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text( 'Await please...'),
        content: Container(
          width: 100,
          height: 100,
          margin: const EdgeInsets.only( top: 10 ),
          child: Column(
            children: const [
              Text('Calculate route'),
              SizedBox( height:  5,),
              CircularProgressIndicator( strokeWidth: 3, color:  Colors.black,)
            ],
          ),
        ),
      ),
    );
    return;
  }

  showCupertinoDialog(
    context: context,
    builder: (context) => const CupertinoAlertDialog(
      title: Text('Await please.....'),
      content: CupertinoActivityIndicator(),
    ),
  );
}