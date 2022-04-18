part of 'search_bloc.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object> get props => [];
}

class OnActiveManualMarkerEvent extends SearchEvent {}
class OnDeactiveManualMarkerEvent extends SearchEvent {}
