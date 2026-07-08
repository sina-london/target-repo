import 'package:hive_flutter/hive_flutter.dart';

part 'provider_model.g.dart';

@HiveType(typeId: 2)
class ProviderSettings extends HiveObject {
  @HiveField(0)
  final String selectedProviderName;
  @HiveField(1)
  final String? customApiUrl;

  ProviderSettings({
    this.selectedProviderName = 'hianime',
    this.customApiUrl,
  });

  ProviderSettings copyWith({
    String? selectedProviderName,
    String? customApiUrl,
  }) {
    return ProviderSettings(
      selectedProviderName: selectedProviderName ?? this.selectedProviderName,
      customApiUrl: customApiUrl ?? this.customApiUrl,
    );
  }
}