import 'dart:convert';
import 'dart:io';

import 'package:fantasy_rice/utils/timer_stream.dart';
import 'dart:math';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
// import 'package:dart_mpd/dart_mpd.dart' show MpdClient, MpdConnectionDetails, MpdSubsystem;
// import 'package:dart_mpd/dart_mpd.dart' as mpd;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'pc_info.freezed.dart';
part 'pc_info.g.dart';

@freezed
abstract class PCInfoHistoryData with _$PCInfoHistoryData {
  const factory PCInfoHistoryData({
    required List<double> cpuUsage,
    required Map<String, List<double>> gpusUsage,
  }) = _PCInfoHistoryData;

  factory PCInfoHistoryData.fromJson(Map<String, Object?> json) => _$PCInfoHistoryDataFromJson(json);
}

@Riverpod(keepAlive: true)
class PCInfoHistory extends _$PCInfoHistory {
  static const _historyLength = 50;
  List<double>? _prevColumns;

  @override
  PCInfoHistoryData build() {
    timerStream(const Duration(milliseconds: 400), firstTime: true).listen((_) {
      final stat = File("/proc/stat").readAsStringSync();
      final line = stat.split("\n").firstWhere((l) => l.startsWith("cpu "));

      final strColumns = line.split(' ').where((e) => e.isNotEmpty).toList();
      final columns = strColumns.skip(1).map((e) => double.parse(e)).toList();

      if (_prevColumns == null) {
        _prevColumns = columns;
        return;
      }

      final prevIdle = _prevColumns![3] + _prevColumns![4];
      final idle = columns[3] + columns[4];

      final prevNonIdle = _prevColumns![0] + _prevColumns![1] + _prevColumns![2] + _prevColumns![5] + _prevColumns![6] + _prevColumns![7];
      final nonIdle = columns[0] + columns[1] + columns[2] + columns[5] + columns[6] + columns[7];

      final prevTotal = prevIdle + prevNonIdle;
      final total = idle + nonIdle;

      final totald = total - prevTotal;
      final idled = idle - prevIdle;
      final usage = (totald - idled) / totald;

      _prevColumns = columns;
      state = state.copyWith(cpuUsage: state.cpuUsage.skip(1).toList()..add(usage));
    });
    timerStream(const Duration(milliseconds: 400), firstTime: true).listen((_) async {
      final res = await Process.run("/nix/store/b0h63mylpgiwp65z14rzl39cid72g0fn-amdgpu_top-0.10.4/bin/amdgpu_top", [
        "--json",
        "--dump"
      ]);
      final json = jsonDecode(res.stdout as String) as List<dynamic>;
      final whitelisted = ["AMD Radeon RX 6700 XT"];
      final newGpusUsage = json.fold(state.gpusUsage, (acc, e) {
        final name = e["DeviceName"] as String;
        final usage = (e["gpu_activity"]["GFX"]["value"] as num) / 100.0;
        return {
          ...acc,
          if (whitelisted.isEmpty || whitelisted.contains(name))
          name: acc.containsKey(name)
              ? [
                  ...acc[name]!.skip(1),
                  usage
                ]
              : [
                  ...List.generate(_historyLength - 1, (index) => 0.0),
                  usage
                ],
        };
      });

      state = state.copyWith(gpusUsage: newGpusUsage);
    });
    return PCInfoHistoryData(
      cpuUsage: List.generate(_historyLength, (index) => 0.0),
      gpusUsage: {},
    );
  }
}
