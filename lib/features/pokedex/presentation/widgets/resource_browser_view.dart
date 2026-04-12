import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'async_error_view.dart';
import 'loading_list_skeleton.dart';

class ResourceBrowserView<T> extends StatefulWidget {
  final AsyncValue<List<T>> asyncItems;
  final VoidCallback onRetry;
  final String Function(T item) titleBuilder;
  final String Function(T item)? subtitleBuilder;
  final Widget Function(BuildContext context, T item) leadingBuilder;
  final void Function(BuildContext context, T item) onTap;
  final String searchHint;
  final String emptyMessage;
  final int pageSize;

  const ResourceBrowserView({
    super.key,
    required this.asyncItems,
    required this.onRetry,
    required this.titleBuilder,
    required this.leadingBuilder,
    required this.onTap,
    required this.searchHint,
    required this.emptyMessage,
    this.subtitleBuilder,
    this.pageSize = 20,
  });

  @override
  State<ResourceBrowserView<T>> createState() => _ResourceBrowserViewState<T>();
}

class _ResourceBrowserViewState<T> extends State<ResourceBrowserView<T>> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';
  int _selectedFilterIndex = 0;
  int _pageIndex = 0;

  static const _filters = <String>[
    'All',
    'A-F',
    'G-L',
    'M-R',
    'S-Z',
    '0-9',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  bool _matchesFilter(String title) {
    final normalized = title.trim().toLowerCase();
    if (normalized.isEmpty) return false;
    if (_selectedFilterIndex == 0) return true;

    final codeUnit = normalized.codeUnitAt(0);
    final firstChar = normalized[0];

    if (_selectedFilterIndex == 5) {
      return RegExp(r'^[0-9]').hasMatch(firstChar);
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

  @override
  Widget build(BuildContext context) {
    return widget.asyncItems.when(
      loading: () => const LoadingListSkeleton(),
      error: (error, _) =>
          AsyncErrorView(error: error, onRetry: widget.onRetry),
      data: (items) {
        final filtered = items.where((item) {
          final searchable = _combinedSearchText(item);
          final queryMatch = _query.isEmpty || searchable.contains(_query);
          final filterMatch = _matchesFilter(widget.titleBuilder(item));
          return queryMatch && filterMatch;
        }).toList(growable: false);

        final totalPages = filtered.isEmpty
            ? 0
            : ((filtered.length - 1) ~/ widget.pageSize) + 1;
        final safePage =
            totalPages == 0 ? 0 : _pageIndex.clamp(0, totalPages - 1).toInt();
        final start = safePage * widget.pageSize;
        final end = (start + widget.pageSize).clamp(0, filtered.length);
        final pageItems =
            filtered.isEmpty ? <T>[] : filtered.sublist(start, end);

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
                              _pageIndex = 0;
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
                    _pageIndex = 0;
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
                        _pageIndex = 0;
                      });
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: pageItems.isEmpty
                  ? Center(child: Text(widget.emptyMessage))
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                      itemCount: pageItems.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final item = pageItems[index];
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
            if (totalPages > 1)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Row(
                  children: [
                    OutlinedButton.icon(
                      onPressed: safePage > 0
                          ? () => setState(() => _pageIndex = safePage - 1)
                          : null,
                      icon: const Icon(Icons.arrow_back),
                      label: const Text('Prev'),
                    ),
                    const SizedBox(width: 12),
                    Text('Page ${safePage + 1} of $totalPages'),
                    const Spacer(),
                    OutlinedButton.icon(
                      onPressed: safePage < totalPages - 1
                          ? () => setState(() => _pageIndex = safePage + 1)
                          : null,
                      icon: const Icon(Icons.arrow_forward),
                      label: const Text('Next'),
                    ),
                  ],
                ),
              ),
          ],
        );
      },
    );
  }
}
