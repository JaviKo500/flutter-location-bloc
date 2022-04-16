import 'dart:async';
import 'package:permission_handler/permission_handler.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';


part 'gps_event.dart';
part 'gps_state.dart';

class GpsBloc extends Bloc<GpsEvent, GpsState> {

  StreamSubscription? gpsServiceSubscription;
  GpsBloc() : super( const GpsState(isGpsEnable: false, isGpsPermissionGranted: false)) {
    on<GpsAndPermissonEvent>((event, emit) => emit( state.copyWith(
      isGpsEnable: event.isGpsdEnabled,
      isGpsPermissionGranted: event.isGpsPermissonGranted
    ) ));
    _init();
  }

  Future<void> _init() async {

    final gpsInitStatus = await Future.wait([
      _checkGpsStatus(),
      _isPermissonGranted()
    ]);
    add(GpsAndPermissonEvent(
      isGpsdEnabled: gpsInitStatus[0], 
      isGpsPermissonGranted: gpsInitStatus[1]
    ));

  }

  Future<bool> _isPermissonGranted() async {
    final isGranted = await Permission.location.isGranted;
    return isGranted;
  }

  Future<bool> _checkGpsStatus() async {
    final isEnable = await Geolocator.isLocationServiceEnabled();
    gpsServiceSubscription = Geolocator.getServiceStatusStream().listen((event) {
      final isEnabled = ( event.index == 1 ) ? true : false;
      print('Service status $isEnabled');
      add(GpsAndPermissonEvent(
        isGpsdEnabled: isEnabled, 
        isGpsPermissonGranted: state.isGpsPermissionGranted
      ));
    });
    return isEnable;
  }

  Future<void> askGpsAccess () async {
    final status = await Permission.location.request();
    switch (status) {
      case PermissionStatus.granted:
          add(GpsAndPermissonEvent(isGpsdEnabled: state.isGpsEnable, isGpsPermissonGranted: true ));
        break;
      case PermissionStatus.denied:
      case PermissionStatus.restricted:
      case PermissionStatus.limited:
      case PermissionStatus.permanentlyDenied:
          add(GpsAndPermissonEvent(isGpsdEnabled: state.isGpsEnable, isGpsPermissonGranted: false ));
          openAppSettings();
    }
  }

  @override
  Future<void> close() {
    
    gpsServiceSubscription?.cancel();

    return super.close();
  }
}

