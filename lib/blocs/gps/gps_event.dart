part of 'gps_bloc.dart';

abstract class GpsEvent extends Equatable {
  const GpsEvent();

  @override
  List<Object> get props => [];
}

class GpsAndPermissonEvent extends GpsEvent{
  final bool isGpsdEnabled;
  final bool isGpsPermissonGranted;
  
  const GpsAndPermissonEvent({
    required this.isGpsdEnabled, 
    required this.isGpsPermissonGranted
  });
}
