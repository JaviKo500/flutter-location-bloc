part of 'map_bloc.dart';

class MapState extends Equatable {
  final bool isMapInitialized;
  final bool isFollowUser;

  const MapState({
    this.isMapInitialized = false, 
    this.isFollowUser = false
  });
  
  MapState copyWith({
    bool? isMapInitialized,
    bool? isFollowUser,
  }) => MapState(
    isMapInitialized: isMapInitialized ?? this.isMapInitialized, 
    isFollowUser    : isFollowUser ?? this.isFollowUser, 
  );
  @override
  List<Object> get props => [ isMapInitialized, isFollowUser];
}
