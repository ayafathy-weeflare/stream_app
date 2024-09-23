
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart'
    hide Message;
import 'package:stream_app/example/channel_page.dart';
import 'package:stream_app/example/localizations.dart';
import 'package:stream_app/example/routes/routes.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

void showLocalNotification(
  Event event,
  String currentUserId,
  BuildContext context,
) async {
  if (![
        EventType.messageNew,
        EventType.notificationMessageNew,
      ].contains(event.type) ||
      event.user!.id == currentUserId) {
    return;
  }
  if (event.message == null) return;
  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  final initializationSettingsAndroid =
      AndroidInitializationSettings('launch_background');
  final initializationSettingsIOS = DarwinInitializationSettings();
  final initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOS,
  );
  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: (response) async {
    
        // final client = StreamChat.of(context).client;
        // var channel = client.state.channels[response];

        // if (channel == null) {
        //   final type = response.actionId;
        //   final id = response.id;
        //   channel = client.channel(
        //     type,
        //     id: id,
        //   );
        //   await channel.watch();
        // }

        // Navigator.pushNamed(
        //   context,
        //   Routes.CHANNEL_PAGE,
        //   arguments: ChannelPageArgs(
        //     channel: channel,
        //   ),
        // );
      
    },
  );
  await flutterLocalNotificationsPlugin.show(
    event.message!.id.hashCode,
    event.message!.user!.name,
    event.message!.text,
    NotificationDetails(
      android: AndroidNotificationDetails(
        'message channel',
        AppLocalizations.of(context).messageChannelName,
        channelDescription:
            AppLocalizations.of(context).messageChannelDescription,
        priority: Priority.high,
        importance: Importance.high,
      ),
      iOS: DarwinNotificationDetails(),
    ),
    payload: '${event.channelType}:${event.channelId}',
  );
}
