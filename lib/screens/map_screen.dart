import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:app_maps/blocs/blocs.dart';
import 'package:app_maps/views/views.dart';
import 'package:app_maps/widgets/widgets.dart';



class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late LocationBloc locationBloc;
  @override
  void initState() {    
    super.initState();
    locationBloc = BlocProvider.of<LocationBloc>(context);
    locationBloc.startFollowingUser();
  }
  @override
  void dispose() {
    locationBloc.stopFollowingUser();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<LocationBloc, LocationState>(
        builder:  (context, state) {
          if ( state.lastKnownLocation == null) {
            return const Center(
              child: Text( 'Await please' ),
            );
          }

          return SingleChildScrollView(
            child: Stack(
              children: [
                MapView( initialLocation:  state.lastKnownLocation!, )
                // TODO: Buttons ..
              ],
            ),
          );
        },
      ),
      floatingActionButtonLocation:  FloatingActionButtonLocation.endFloat,
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: const [
          BtnCurrentLocation()
        ],
      ),
   );
  }
}