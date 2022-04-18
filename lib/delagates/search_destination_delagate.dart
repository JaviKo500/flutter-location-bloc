import 'package:flutter/material.dart';

import 'package:app_maps/models/models.dart';

class SearchDestinationDelegate extends SearchDelegate<SearchResult> {
  SearchDestinationDelegate(): super(
    searchFieldLabel: 'Search place'
  );
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon( Icons.clear ),
        onPressed: () {
          query = '';
        }, 
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon( Icons.arrow_back_ios ),
      onPressed: () {
        final result = SearchResult( cancel: true );
        close( context, result );
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return const Text( 'buildREsults' );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return ListView(
      children: [
        ListTile(
          leading: const Icon( Icons.location_on_outlined, color: Colors.black ),
          title: const Text( 'Set location manually' ),
          onTap: () {
            final result = SearchResult( cancel: false, manual: true );
            close( context, result );
          },
        )
      ],
    );
  }

}