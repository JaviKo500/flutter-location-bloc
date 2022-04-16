import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:app_maps/blocs/blocs.dart';


class GpsAccessScreen extends StatelessWidget {

  const GpsAccessScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Center(
          child: BlocBuilder<GpsBloc, GpsState>(
              builder: (context, state) {
                return !state.isGpsEnable  
                        ? const _EnableGpsMessage()
                        : const _AccesButton() ;
              },
            ),
        ),
        // child: _AccesButton();
        // child: _EnableGpsMessage()
     ),
   );
  }
}

class _AccesButton extends StatelessWidget {
  const _AccesButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Is necesary access to GPS',
          style: TextStyle( fontSize: 20, fontWeight: FontWeight.w500 ),
        ),
        MaterialButton(
          child: const Text(
            'Active access',
            style: TextStyle( color:  Colors.white ),
          ),
          color: Colors.black,
          shape:  const StadiumBorder(),
          elevation: 0,
          splashColor: Colors.transparent,
          onPressed: () {
            // final gpsBloc = context.read<GpsBloc>();
            final gpsBloc = BlocProvider.of<GpsBloc>(context);
            gpsBloc.askGpsAccess();
          },
        )
      ],
    );
  }
}

class _EnableGpsMessage extends StatelessWidget {
  const _EnableGpsMessage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Not enabled Location',
      style: TextStyle( fontSize: 25, fontWeight: FontWeight.w300),  
    );
  }
}