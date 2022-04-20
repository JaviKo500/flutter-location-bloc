import 'dart:typed_data';

import 'package:app_maps/models/models.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'dart:ui' as ui;
import 'package:google_maps_flutter/google_maps_flutter.dart' show BitmapDescriptor;

Future<BitmapDescriptor> getAssetImageMarker() async {
    late BitmapDescriptor iconMarker;
    await getBytesFromAsset().then((value) {
      iconMarker = BitmapDescriptor.fromBytes( value! );
    });
    return iconMarker;
}

Future<Uint8List?> getBytesFromAsset() async {
  ByteData data = await rootBundle.load('assets/custom-pin.png');
  ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: 120);
  ui.FrameInfo fi = await codec.getNextFrame();
  return (await fi.image.toByteData(format: ui.ImageByteFormat.png))?.buffer.asUint8List();
}

Future<BitmapDescriptor> getNetworkImageMarker() async {
  final resp = await Dio().get(
    'https://cdn4.iconfinder.com/data/icons/small-n-flat/24/map-marker-512.png',
    options: Options( responseType: ResponseType.bytes )  
  );

  // resize image
  final imageCodec = await ui.instantiateImageCodec( resp.data, targetHeight: 150,  targetWidth: 150 );
  final frame = await imageCodec.getNextFrame();
  final data = await frame.image.toByteData( format: ui.ImageByteFormat.png );
  
  if ( data == null ){
    return getAssetImageMarker();
  }
  return BitmapDescriptor.fromBytes( data.buffer.asUint8List() );
}