class SearchResult {
  
  final bool cancel;
  final bool manual;

  SearchResult({
    required this.cancel,
    this.manual = false
  });
  // TODO: 
  // name , descrip, lon lat

  @override
  String toString() {
    return '{ cancel $cancel, manual: $manual }';
  }
}