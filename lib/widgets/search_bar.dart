import 'dart:math';

import 'package:animate_do/animate_do.dart';
import 'package:app_maps/blocs/blocs.dart';
import 'package:flutter/material.dart';

import 'package:app_maps/delagates/delagates.dart';
import 'package:app_maps/models/models.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchBar extends StatelessWidget {
  const SearchBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        return state.displayManualMarker
              ? const SizedBox()
              : FadeInDown(
                duration:  const Duration( milliseconds: 300 ),
                child: const _SearchBarBody()
              );
      },
    );
  }
}

class _SearchBarBody extends StatelessWidget {
  const _SearchBarBody({Key? key}) : super(key: key);

  void onSearchResults(BuildContext context, SearchResult result ) async {
  
    final  searchBloc = BlocProvider.of<SearchBloc>(context);
    final  mapBloc = BlocProvider.of<MapBloc>(context);
    final  locationBloc = BlocProvider.of<LocationBloc>(context);
    if ( result.manual ) {
      searchBloc.add( OnActiveManualMarkerEvent() );
      return;
    }
    if ( result.position != null ) {
      final start = locationBloc.state.lastKnownLocation!;
      final routeDestination = await searchBloc.getCoorsStartToEnd(start, result.position!);
      await mapBloc.drawRoutePolyline(routeDestination);
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.only( top: 10 ),
        padding:  const EdgeInsets.symmetric( horizontal: 30 ),
        width: double.infinity,
        child: GestureDetector(
          onTap: () async {
            final  result = await showSearch(
              context: context, 
              delegate: SearchDestinationDelegate()
            );
            if ( result == null ) return;
            onSearchResults( context, result );
          },
          child: Container(
            padding: const EdgeInsets.symmetric( horizontal: 20,  vertical: 13 ),
            child: const Text( 
              'Where do you want to go?',
              style: TextStyle( color: Colors.black87 ),
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular( 100 ),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 5,
                  offset: Offset( 0, 5)
                )
              ]
            ),
          ),
        ),
      ),
    );
  }
}