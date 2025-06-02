// This file was generated using the following command and may be overwritten.
// dart-dbus generate-remote-object lib/org.freedesktop.Notifications.xml

import 'dart:async';
import 'dart:math';

import 'package:dbus/dbus.dart';
import 'package:fantasy_rice/providers/notifications.dart';

/// Signal data for org.freedesktop.Notifications.NotificationClosed.
class OrgFreedesktopNotificationsNotificationClosed extends DBusSignal {
  int get id => values[0].asUint32();
  int get reason => values[1].asUint32();

  OrgFreedesktopNotificationsNotificationClosed(DBusSignal signal) : super(sender: signal.sender, path: signal.path, interface: signal.interface, name: signal.name, values: signal.values);
}

/// Signal data for org.freedesktop.Notifications.ActionInvoked.
class OrgFreedesktopNotificationsActionInvoked extends DBusSignal {
  int get id => values[0].asUint32();
  String get action_key => values[1].asString();

  OrgFreedesktopNotificationsActionInvoked(DBusSignal signal) : super(sender: signal.sender, path: signal.path, interface: signal.interface, name: signal.name, values: signal.values);
}

class OrgFreedesktopNotifications extends DBusRemoteObject {
  /// Stream of org.freedesktop.Notifications.NotificationClosed signals.
  late final Stream<OrgFreedesktopNotificationsNotificationClosed> notificationClosed;

  /// Stream of org.freedesktop.Notifications.ActionInvoked signals.
  late final Stream<OrgFreedesktopNotificationsActionInvoked> actionInvoked;

  OrgFreedesktopNotifications(DBusClient client, String destination, DBusObjectPath path) : super(client, name: destination, path: path) {
    notificationClosed = DBusRemoteObjectSignalStream(object: this, interface: 'org.freedesktop.Notifications', name: 'NotificationClosed', signature: DBusSignature('uu')).asBroadcastStream().map((signal) => OrgFreedesktopNotificationsNotificationClosed(signal));

    actionInvoked = DBusRemoteObjectSignalStream(object: this, interface: 'org.freedesktop.Notifications', name: 'ActionInvoked', signature: DBusSignature('us')).asBroadcastStream().map((signal) => OrgFreedesktopNotificationsActionInvoked(signal));
  }

  /// Invokes org.freedesktop.Notifications.Notify()
  Future<int> callNotify(String app_name, int replaces_id, String app_icon, String summary, String body, List<String> actions, Map<String, DBusValue> hints, int timeout, {bool noAutoStart = false, bool allowInteractiveAuthorization = false}) async {
    var result = await callMethod(
        'org.freedesktop.Notifications',
        'Notify',
        [
          DBusString(app_name),
          DBusUint32(replaces_id),
          DBusString(app_icon),
          DBusString(summary),
          DBusString(body),
          DBusArray.string(actions),
          DBusDict.stringVariant(hints),
          DBusInt32(timeout)
        ],
        replySignature: DBusSignature('u'),
        noAutoStart: noAutoStart,
        allowInteractiveAuthorization: allowInteractiveAuthorization);
    return result.returnValues[0].asUint32();
  }

  /// Invokes org.freedesktop.Notifications.CloseNotification()
  Future<void> callCloseNotification(int id, {bool noAutoStart = false, bool allowInteractiveAuthorization = false}) async {
    await callMethod(
        'org.freedesktop.Notifications',
        'CloseNotification',
        [
          DBusUint32(id)
        ],
        replySignature: DBusSignature(''),
        noAutoStart: noAutoStart,
        allowInteractiveAuthorization: allowInteractiveAuthorization);
  }

  /// Invokes org.freedesktop.Notifications.GetCapabilities()
  Future<List<String>> callGetCapabilities({bool noAutoStart = false, bool allowInteractiveAuthorization = false}) async {
    var result = await callMethod('org.freedesktop.Notifications', 'GetCapabilities', [], replySignature: DBusSignature('as'), noAutoStart: noAutoStart, allowInteractiveAuthorization: allowInteractiveAuthorization);
    return result.returnValues[0].asStringArray().toList();
  }

  /// Invokes org.freedesktop.Notifications.GetServerInformation()
  Future<List<DBusValue>> callGetServerInformation({bool noAutoStart = false, bool allowInteractiveAuthorization = false}) async {
    var result = await callMethod('org.freedesktop.Notifications', 'GetServerInformation', [], replySignature: DBusSignature('ssss'), noAutoStart: noAutoStart, allowInteractiveAuthorization: allowInteractiveAuthorization);
    return result.returnValues;
  }
}

class OrgFreedesktopNotificationsHandler extends DBusObject {
  OrgFreedesktopNotificationsHandler({
    required this.onNotification,
    // required this.onNotificationClose,
  }) : super(DBusObjectPath('/org/freedesktop/Notifications'));

  final void Function(NotificationData) onNotification;
  // final void Function(Notification) onNotificationClose;

  @override
  Future<DBusMethodResponse> getProperty(String interface, String name) async {
    // print('getProperty: $interface, $name');
    // if (interface == 'com.example.Test' && name == 'Version') {
    //   return DBusGetPropertyResponse(DBusString('1.2'));
    // } else {
    return DBusMethodErrorResponse.unknownProperty();
    // }
  }

  @override
  Future<DBusMethodResponse> handleMethodCall(DBusMethodCall methodCall) async {
    // print('handleMethodCall: ${methodCall.interface}, ${methodCall.name}, ${methodCall.signature}');
    if (methodCall.interface != 'org.freedesktop.Notifications') {
      return DBusMethodErrorResponse.unknownInterface();
    }

    switch (methodCall.name) {
      case 'GetServerInformation':
        return DBusMethodSuccessResponse([
          DBusString('aaa'),
          DBusString('bbb'),
          DBusString('0.1.0'),
          DBusString('1.2'),
        ]);
      case 'Notify':
        onNotification(
          NotificationData(
            id: Random().nextInt(0xffffffff),
            title: methodCall.values[3].asString(),
            description: methodCall.values[4].asString(),
            hints: methodCall.values[6] as DBusDict,
            icon: methodCall.values[2].asString() == "" ? null : methodCall.values[2].asString(),
          ),
        );
        return DBusMethodSuccessResponse([
          DBusUint32(1),
        ]);
      default:
        return DBusMethodErrorResponse.unknownMethod();
    }
  }
}
