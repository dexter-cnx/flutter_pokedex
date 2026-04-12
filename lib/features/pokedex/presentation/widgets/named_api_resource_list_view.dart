import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/named_api_resource_entity.dart';
import 'async_error_view.dart';
import 'loading_list_skeleton.dart';

class NamedApiResourceListView extends StatelessWidget {
  final AsyncValue<List<NamedApiResourceEntity>> asyncResources;
  final VoidCallback onRetry;
  final Widget Function(NamedApiResourceEntity resource) onTapPageBuilder;
  final IconData icon;
  final String emptyLabel;

  const NamedApiResourceListView({
    super.key,
    required this.asyncResources,
    required this.onRetry,
    required this.onTapPageBuilder,
    required this.icon,
    required this.emptyLabel,
  });

  String _formatName(String value) {
    return value.split('-').map((part) {
      if (part.isEmpty) return part;
      return part[0].toUpperCase() + part.substring(1);
    }).join(' ');
  }

  @override
  Widget build(BuildContext context) {
    return asyncResources.when(
      loading: () => const LoadingListSkeleton(),
      error: (error, _) => AsyncErrorView(error: error, onRetry: onRetry),
      data: (resources) {
        if (resources.isEmpty) {
          return Center(child: Text(emptyLabel));
        }

        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: resources.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final resource = resources[index];
            return Card(
              elevation: 1,
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => onTapPageBuilder(resource),
                    ),
                  );
                },
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  leading: CircleAvatar(
                    child: Icon(icon),
                  ),
                  title: Text(_formatName(resource.name)),
                  subtitle: const Text('Tap to open details'),
                  trailing: const Icon(Icons.chevron_right),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
