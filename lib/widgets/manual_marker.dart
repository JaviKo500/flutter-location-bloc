import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:animate_do/animate_do.dart';

import 'package:app_maps/blocs/blocs.dart';
import 'package:app_maps/helpers/helpers.dart';

class ManualMarker extends StatelessWidget {
  const ManualMarker({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        return state.displayManualMarker
              ? const _ManualMarkerBody()
              : const SizedBox();
      }
    );
  }
}

class _ManualMarkerBody extends StatelessWidget {
  const _ManualMarkerBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SizedBox(
        width: size.width,
        height: size.height,
        child: Stack(
          children: [
            const Positioned(
              top: 70,
              left: 20,
              child: _BtnBack(),
            ),
            Center(
              child: Transform.translate(
                offset: const Offset( 0, -22 ), 
                child: BounceInDown(
                  from: 100,
                  child: const Icon( Icons.location_on_rounded, size: 60)
                ),
              ),
            ),

            // Comfirm Button
            Positioned(
              bottom: 70,
              left: 40,
              child: _BtnConfirm(size: size),
            )
          ],
        ),
      );
  }
}

class _BtnConfirm extends StatelessWidget {
  const _BtnConfirm({
    Key? key,
    required this.size,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    final searchBloc = BlocProvider.of<SearchBloc>(context);
    final locationBloc = BlocProvider.of<LocationBloc>(context);
    final mapBloc = BlocProvider.of<MapBloc>(context);
    return FadeInUp(
      duration: const Duration( milliseconds:  300 ),
      child: MaterialButton(
        minWidth: size.width - 120,
        height: 50,
        child: const Text(
          'Confirm Destination?',
          style: TextStyle( color: Colors.white, fontWeight: FontWeight.w300, fontSize: 20),
        ),
        color: Colors.black,
        elevation: 0,
        shape: const StadiumBorder(),
        onPressed: () async {
          //  TODO: Loading
          final start = locationBloc.state.lastKnownLocation;
          if ( start == null ) return;

          final end = mapBloc.mapCenter;
          if ( end == null ) return;

          showLoadingMessage(context);

          final routeDestination = await searchBloc.getCoorsStartToEnd(start, end);
          await mapBloc.drawRoutePolyline(routeDestination);
          
          searchBloc.add( OnDeactiveManualMarkerEvent() );

          Navigator.pop(context);
        },
      ),
    );
  }
}

class _BtnBack extends StatelessWidget {
  const _BtnBack({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FadeInLeft(
      duration: const Duration( milliseconds:300 ),
      child: CircleAvatar(
        maxRadius: 30,
        backgroundColor: Colors.white,
        child: IconButton(
          icon: const Icon( Icons.arrow_back_ios_new, color: Colors.black ),
          onPressed: () {
            BlocProvider.of<SearchBloc>(context).add( OnDeactiveManualMarkerEvent() );
          },
        ),
      ),
    );
  }
}