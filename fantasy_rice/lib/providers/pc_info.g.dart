// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pc_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PCInfoHistoryData _$PCInfoHistoryDataFromJson(Map<String, dynamic> json) =>
    _PCInfoHistoryData(
      cpuUsage: (json['cpuUsage'] as List<dynamic>)
          .map((e) => (e as num).toDouble())
          .toList(),
      gpusUsage: (json['gpusUsage'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(
            k, (e as List<dynamic>).map((e) => (e as num).toDouble()).toList()),
      ),
    );

Map<String, dynamic> _$PCInfoHistoryDataToJson(_PCInfoHistoryData instance) =>
    <String, dynamic>{
      'cpuUsage': instance.cpuUsage,
      'gpusUsage': instance.gpusUsage,
    };

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$pCInfoHistoryHash() => r'25739b6711b5044c5e38c78ddc7382bb3b669a82';

/// See also [PCInfoHistory].
@ProviderFor(PCInfoHistory)
final pCInfoHistoryProvider =
    NotifierProvider<PCInfoHistory, PCInfoHistoryData>.internal(
  PCInfoHistory.new,
  name: r'pCInfoHistoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$pCInfoHistoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$PCInfoHistory = Notifier<PCInfoHistoryData>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
