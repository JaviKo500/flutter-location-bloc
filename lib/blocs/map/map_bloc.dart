import 'dart:async';
import 'dart:convert';

import 'package:app_maps/models/models.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';

import 'package:app_maps/blocs/blocs.dart';
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
    on<DisplayPolylinesEvent>((event, emit) => emit( state.copyWith(polylines: event.polylines)) );
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
    add( DisplayPolylinesEvent( currentPolylines ) );
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
