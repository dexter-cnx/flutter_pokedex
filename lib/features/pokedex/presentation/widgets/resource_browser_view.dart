import 'package:flutter/material.dart';

import '../providers/pokedex_providers.dart';
import 'async_error_view.dart';
import 'loading_list_skeleton.dart';

class PageResult<T> {
  final List<T> items;
  final int count;
  final int offset;
  final int limit;

  const PageResult({
    required this.items,
    required this.count,
    required this.offset,
    required this.limit,
  });

  bool get hasMore => offset + items.length < count;
}

typedef PageFetcher<T> = Future<PageResult<T>> Function(
  int offset,
  int limit,
);

class ResourceBrowserView<T> extends StatefulWidget {
  final BrowseMode browseMode;
  final PageFetcher<T> pageFetcher;
  final VoidCallback onRetry;
  final String Function(T item) titleBuilder;
  final String Function(T item)? subtitleBuilder;
  final Widget Function(BuildContext context, T item) leadingBuilder;
  final void Function(BuildContext context, T item) onTap;
  final String searchHint;
  final String emptyMessage;
  final int pageSize;
  final Object? dataSourceKey;

  const ResourceBrowserView({
    super.key,
    required this.browseMode,
    required this.pageFetcher,
    required this.onRetry,
    required this.titleBuilder,
    required this.leadingBuilder,
    required this.onTap,
    required this.searchHint,
    required this.emptyMessage,
    this.dataSourceKey,
    this.subtitleBuilder,
    this.pageSize = 20,
  });

  @override
  State<ResourceBrowserView<T>> createState() => _ResourceBrowserViewState<T>();
}

class _ResourceBrowserViewState<T> extends State<ResourceBrowserView<T>> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final Map<int, List<T>> _pageCache = {};
  final List<T> _loadedItems = [];

  String _query = '';
  int _selectedFilterIndex = 0;
  int _pageIndex = 0;
  int _totalCount = 0;
  bool _initialLoading = true;
  bool _initialError = false;
  bool _loadingPage = false;
  bool _loadingMore = false;
  bool _hasMore = true;
  Object? _error;
  Object? _pageError;

  static const _filters = <String>[
    'All',
    'A-F',
    'G-L',
    'M-R',
    'S-Z',
    '0-9',
  ];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_handleScroll);
    _fetchFirstPage();
  }

  @override
  void didUpdateWidget(covariant ResourceBrowserView<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.browseMode != widget.browseMode ||
        oldWidget.dataSourceKey != widget.dataSourceKey) {
      _resetAndReload();
    }
  }

  Future<void> _fetchFirstPage() async {
    setState(() {
      _initialLoading = true;
      _initialError = false;
      _error = null;
      _pageCache.clear();
      _loadedItems.clear();
      _pageIndex = 0;
      _totalCount = 0;
      _hasMore = true;
      _loadingPage = false;
      _loadingMore = false;
      _pageError = null;
    });

    try {
      final page = await widget.pageFetcher(0, widget.pageSize);
      if (!mounted) return;

      setState(() {
        _pageCache[0] = page.items;
        _loadedItems.addAll(page.items);
        _totalCount = page.count;
        _hasMore = page.hasMore;
        _initialLoading = false;
        _pageError = null;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _initialLoading = false;
        _initialError = true;
        _error = error;
        _pageError = null;
      });
    }
  }

  Future<void> _fetchPage(int pageIndex) async {
    if (_pageCache.containsKey(pageIndex) || _loadingPage) return;

    setState(() {
      _loadingPage = true;
      _error = null;
    });

    try {
      final page = await widget.pageFetcher(
        pageIndex * widget.pageSize,
        widget.pageSize,
      );
      if (!mounted) return;

      setState(() {
        _pageCache[pageIndex] = page.items;
        _totalCount = page.count;
        _loadingPage = false;
        _initialError = false;
        _pageError = null;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _loadingPage = false;
        _error = error;
        _pageError = error;
      });
    }
  }

  Future<void> _loadMore() async {
    if (!_hasMore || _loadingMore) return;

    setState(() {
      _loadingMore = true;
      _error = null;
    });

    try {
      final page = await widget.pageFetcher(
        _loadedItems.length,
        widget.pageSize,
      );
      if (!mounted) return;

      setState(() {
        _loadedItems.addAll(page.items);
        _hasMore = page.hasMore;
        _totalCount = page.count;
        _loadingMore = false;
        _initialError = false;
        _pageError = null;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _loadingMore = false;
        _error = error;
        _pageError = error;
      });
    }
  }

  void _resetAndReload() {
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(0);
    }
    _fetchFirstPage();
  }

  void _handleScroll() {
    if (widget.browseMode != BrowseMode.infiniteScroll) return;
    if (!_scrollController.hasClients) return;
    if (_scrollController.position.extentAfter > 240) return;
    _loadMore();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_handleScroll);
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  bool _matchesFilter(String title) {
    final normalized = title.trim().toLowerCase();
    if (normalized.isEmpty) return false;
    if (_selectedFilterIndex == 0) return true;

    final codeUnit = normalized.codeUnitAt(0);
    if (_selectedFilterIndex == 5) {
      return RegExp(r'^[0-9]').hasMatch(normalized);
    }

    final ranges = <int, List<String>>{
      1: ['a', 'f'],
      2: ['g', 'l'],
      3: ['m', 'r'],
      4: ['s', 'z'],
    };
    final range = ranges[_selectedFilterIndex];
    if (range == null) return true;

    return codeUnit >= range[0].codeUnitAt(0) &&
        codeUnit <= range[1].codeUnitAt(0);
  }

  String _combinedSearchText(T item) {
    final title = widget.titleBuilder(item);
    final subtitle = widget.subtitleBuilder?.call(item) ?? '';
    return '$title $subtitle'.toLowerCase();
  }

  int get _totalPages {
    if (_totalCount <= 0) return 0;
    return ((_totalCount - 1) ~/ widget.pageSize) + 1;
  }

  @override
  Widget build(BuildContext context) {
    if (_initialLoading) {
      return const LoadingListSkeleton();
    }

    if (_initialError) {
      return AsyncErrorView(
        error: _error ?? 'Failed to load data',
        onRetry: () {
          widget.onRetry();
          _fetchFirstPage();
        },
      );
    }

    if (widget.browseMode == BrowseMode.pagination &&
        _pageError != null &&
        (_pageCache[_pageIndex] == null || _pageCache[_pageIndex]!.isEmpty)) {
      return AsyncErrorView(
        error: _pageError!,
        onRetry: () => _fetchPage(_pageIndex),
      );
    }

    if (widget.browseMode == BrowseMode.pagination &&
        _loadingPage &&
        (_pageCache[_pageIndex] == null || _pageCache[_pageIndex]!.isEmpty)) {
      return const LoadingListSkeleton();
    }

    final visibleSource = switch (widget.browseMode) {
      BrowseMode.pagination => _pageCache[_pageIndex] ?? <T>[],
      BrowseMode.lazyLoading => _loadedItems,
      BrowseMode.infiniteScroll => _loadedItems,
    };

    final filtered = visibleSource.where((item) {
      final searchable = _combinedSearchText(item);
      final queryMatch = _query.isEmpty || searchable.contains(_query);
      final filterMatch = _matchesFilter(widget.titleBuilder(item));
      return queryMatch && filterMatch;
    }).toList(growable: false);

    final shouldShowPagination =
        widget.browseMode == BrowseMode.pagination && _totalPages > 1;
    final hasMoreLazy =
        widget.browseMode != BrowseMode.pagination && _hasMore;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: widget.searchHint,
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _query.isEmpty
                  ? null
                  : IconButton(
                      onPressed: () {
                        _searchController.clear();
                        setState(() {
                          _query = '';
                        });
                      },
                      icon: const Icon(Icons.close),
                    ),
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
            ),
            onChanged: (value) {
              setState(() {
                _query = value.trim().toLowerCase();
              });
            },
          ),
        ),
        SizedBox(
          height: 44,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: _filters.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              return ChoiceChip(
                label: Text(_filters[index]),
                selected: _selectedFilterIndex == index,
                onSelected: (_) {
                  setState(() {
                    _selectedFilterIndex = index;
                  });
                },
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: filtered.isEmpty
              ? Center(child: Text(widget.emptyMessage))
              : ListView.separated(
                  controller: _scrollController,
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                  itemCount: filtered.length +
                      ((widget.browseMode == BrowseMode.lazyLoading &&
                              hasMoreLazy)
                          ? 1
                          : 0) +
                      ((_error != null && widget.browseMode != BrowseMode.pagination)
                          ? 1
                          : 0),
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    if (widget.browseMode == BrowseMode.lazyLoading &&
                        hasMoreLazy &&
                        index == filtered.length) {
                      return OutlinedButton.icon(
                        onPressed: _loadingMore ? null : _loadMore,
                        icon: _loadingMore
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Icon(Icons.more_horiz),
                        label: Text(_loadingMore ? 'Loading...' : 'Load more'),
                      );
                    }

                    if (_error != null &&
                        widget.browseMode != BrowseMode.pagination &&
                        index == filtered.length + (hasMoreLazy ? 1 : 0)) {
                      return OutlinedButton.icon(
                        onPressed: _loadingMore ? null : _loadMore,
                        icon: const Icon(Icons.refresh),
                        label: const Text('Retry loading more'),
                      );
                    }

                    final item = filtered[index];
                    return Card(
                      elevation: 1,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: () => widget.onTap(context, item),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          leading: widget.leadingBuilder(context, item),
                          title: Text(widget.titleBuilder(item)),
                          subtitle: widget.subtitleBuilder == null
                              ? null
                              : Text(widget.subtitleBuilder!(item)),
                          trailing: const Icon(Icons.chevron_right),
                        ),
                      ),
                    );
                  },
                ),
        ),
        if (widget.browseMode == BrowseMode.pagination && shouldShowPagination)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Row(
              children: [
                OutlinedButton.icon(
                  onPressed: _pageIndex > 0
                      ? () async {
                          final nextPage = _pageIndex - 1;
                          setState(() => _pageIndex = nextPage);
                          await _fetchPage(nextPage);
                        }
                      : null,
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Prev'),
                ),
                const SizedBox(width: 12),
                Text('Page ${_pageIndex + 1} of $_totalPages'),
                const Spacer(),
                OutlinedButton.icon(
                  onPressed: _pageIndex < _totalPages - 1
                      ? () async {
                          final nextPage = _pageIndex + 1;
                          setState(() => _pageIndex = nextPage);
                          await _fetchPage(nextPage);
                        }
                      : null,
                  icon: const Icon(Icons.arrow_forward),
                  label: const Text('Next'),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
