class PageResultEntity<T> {
  final List<T> items;
  final int count;
  final int offset;
  final int limit;

  const PageResultEntity({
    required this.items,
    required this.count,
    required this.offset,
    required this.limit,
  });

  bool get hasMore => offset + items.length < count;
}
