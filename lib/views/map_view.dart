import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:app_maps/blocs/blocs.dart';

class MapView extends StatelessWidget {
  final LatLng initialLocation;
  final Set<Polyline> polylines;
  const MapView({
    Key? key, 
    required this.initialLocation, 
    required this.polylines,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
  final mapBloc = BlocProvider.of<MapBloc>(context);
    final CameraPosition initialCameraPostion = CameraPosition(
        target: initialLocation,
        zoom: 15
    );
    final size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width,
      height: size.height,
      child: Listener(
        onPointerMove: ( event ) => mapBloc.add( OnStopFollowingUserMapEvent() ),
        child: GoogleMap(
          initialCameraPosition:  initialCameraPostion,
          compassEnabled: true,
          myLocationEnabled: true,
          zoomControlsEnabled: false,
          myLocationButtonEnabled: false,
          polylines:  polylines,
          onMapCreated: (controller) => mapBloc.add(OnMapInitializedEvent(controller)),
          onCameraMove: ( position ) => mapBloc.mapCenter = position.target,
          // TODO: Markers
          // TODO: Polylines
          // TODO: when move map
        ),
      ),
    );
  }
}