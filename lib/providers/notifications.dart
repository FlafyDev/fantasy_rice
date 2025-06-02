import 'dart:core';

import 'package:dbus/dbus.dart';
import 'package:fantasy_rice/dbus/notifications_object.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'notifications.g.dart';
part 'notifications.freezed.dart';

@freezed
abstract class NotificationData with _$NotificationData {
  const factory NotificationData({
    required int id,
    required String title,
    required String description,
  }) = _NotificationData;
}

@riverpod
class NotificationsState extends _$NotificationsState {
  @override
  List<NotificationData> build() {
    final dBusClient = DBusClient.session()
      ..requestName('org.freedesktop.Notifications')
      ..registerObject(
        OrgFreedesktopNotificationsHandler(
          onNotification: _onNotification,
        ),
      );
    
    ref.onDispose(dBusClient.close);

    return const [];
  }

  Future<void> closeNotification(int id) async {
    state = state.where((n) => n.id != id).toList();
  }

  void _onNotification(NotificationData notification) {
    state = [
      ...state,
      notification
    ];
  }
}