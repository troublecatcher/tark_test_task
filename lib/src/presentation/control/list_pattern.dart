class ListPattern {
  final String from;
  final String to;

  ListPattern({required this.from, required this.to})
      : assert(from.codeUnitAt(0) < to.codeUnitAt(0),
            'FROM must have a lower ASCII code than TO');

  static final List<ListPattern> patterns = [
    ListPattern(
      from: 'A',
      to: 'H',
    ),
    ListPattern(
      from: 'I',
      to: 'P',
    ),
    ListPattern(
      from: 'Q',
      to: 'Z',
    ),
  ];
}
