import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';

import 'package:app_maps/blocs/blocs.dart';
import 'package:app_maps/helpers/helpers.dart';
import 'package:app_maps/models/models.dart';
import 'package:app_maps/themes/themes.dart';

part 'map_event.dart';
part 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  final LocationBloc locationBloc;
  StreamSubscription<LocationState>? locationStateSubcription;
  GoogleMapController? _mapController;
  LatLng? mapCenter;
  MapBloc( {
    required this.locationBloc
  } ) : super(const MapState()) {
    on<OnMapInitializedEvent>( _onInitMap );
    on<OnStartFollowingUserMapEvent>( _onStartFollowingUser );
    on<OnStopFollowingUserMapEvent>((event, emit) => emit( state.copyWith( isFollowingUser: false )) );
    on<UpdateUserPolylineEvent>( _onPolylineNewpoint );
    on<OnToggleUserRoute>((event, emit) => emit( state.copyWith( showMyRoute: !state.showMyRoute )) );
    on<DisplayPolylinesEvent>((event, emit) => emit( state.copyWith(polylines: event.polylines, markers: event.markers)) );
    locationStateSubcription = locationBloc.stream.listen(( locationState ) {
      if ( locationState.lastKnownLocation != null ) {
        add( UpdateUserPolylineEvent( locationState.myLocationHistory ) );
      }
      if ( !state.isFollowingUser ) return;
      if ( locationState.lastKnownLocation == null ) return;
      moveCamera( locationState.lastKnownLocation! );
    });
  }


  void _onInitMap( OnMapInitializedEvent event, Emitter<MapState> emit) {
    _mapController = event.controller;
    _mapController!.setMapStyle( jsonEncode( uberMapTheme ) );
    emit( state.copyWith( isMapInitialized:  true) );
  }

  void _onStartFollowingUser( OnStartFollowingUserMapEvent event, Emitter<MapState> emit) {
    emit( state.copyWith( isFollowingUser: true ) );
    if ( locationBloc.state.lastKnownLocation == null ) return;
    moveCamera( locationBloc.state.lastKnownLocation! );
  }
  void _onPolylineNewpoint( UpdateUserPolylineEvent event, Emitter<MapState> emit) {
    final myRoute = Polyline(
      polylineId: const PolylineId('myRoute'),
      color: Colors.black,
      width: 5,
      startCap: Cap.roundCap,
      endCap: Cap.roundCap,
      points: event.userLocations
    );
    final currentPolylines = Map<String, Polyline>.from( state.polylines );
    currentPolylines['myRoute'] = myRoute;
    emit( state.copyWith( polylines: currentPolylines ) );
  }

  Future drawRoutePolyline( RouteDestination routeDestination) async {
    final myRoute = Polyline(
      polylineId: const PolylineId('route'),
      color: Colors.black,
      width: 5,
      points: routeDestination.points,
      startCap: Cap.roundCap,
      endCap: Cap.roundCap
    );

    final currentPolylines = Map<String, Polyline>.from( state.polylines );
    currentPolylines['route'] = myRoute;

    double kms = routeDestination.distance / 1000;
    kms = (kms * 100).floorToDouble();
    kms /= 100;

    int tripDuration = (routeDestination.duration / 60).floorToDouble().toInt();
    
    // Custom marker
    final startIconMarker = await getStartCustomMarker( tripDuration, 'My location' );
    final endIconMarker = await getEndCustomMarker( kms , routeDestination.endPlace.text);

    final startMarker = Marker(
      markerId: const MarkerId('start'),
      position: routeDestination.points.first,
      icon:  startIconMarker,
      anchor: const Offset( 0.1, 1),
      // infoWindow: InfoWindow(
      //   title: 'Start',
      //   snippet: 'Kms: $kms kms, duration: $tripDuration'
      // )
    );
    final endMarker = Marker(
      markerId: const MarkerId('end'),
      position: routeDestination.points.last,
      icon: endIconMarker,
      // infoWindow: InfoWindow(
      //   title: routeDestination.endPlace.text,
      //   snippet: routeDestination.endPlace.placeName
      // )
    );
    
    final currentsMarkers = Map<String, Marker>.from( state.markers );
    currentsMarkers['start'] = startMarker;
    currentsMarkers['end'] = endMarker;
    add( DisplayPolylinesEvent( currentPolylines, currentsMarkers ) );
    await Future.delayed(const Duration( milliseconds: 300 ));
    // _mapController?.showMarkerInfoWindow( const MarkerId( 'start' ) );
  }

  void moveCamera( LatLng newLocation ) {
    final cameraUpdate = CameraUpdate.newLatLng( newLocation );
    _mapController?.animateCamera(cameraUpdate);
  }
  @override
  Future<void> close() {
    locationStateSubcription?.cancel();
    return super.close();
  }
}
