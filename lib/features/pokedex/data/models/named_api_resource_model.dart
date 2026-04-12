import '../../domain/entities/named_api_resource_entity.dart';

class NamedApiResourceModel extends NamedApiResourceEntity {
  const NamedApiResourceModel({
    required super.name,
    required super.url,
  });

  factory NamedApiResourceModel.fromRaw({
    required String name,
    required String url,
  }) {
    return NamedApiResourceModel(name: name, url: url);
  }
}
