import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';











///Это файл прородитель, скорее всего он бесполезный, но удалять его пока я не рискну












class Plugin{
  Plugin(); //что означает эта запись?
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
 ///именно в асинхронной среде инициализируются настройки iOS и Android
Future<void> initialize() async {
  const AndroidInitializationSettings initializationSettingsAndroid =
  AndroidInitializationSettings('ic_stat_download');
  final DarwinInitializationSettings initializationSettingsIOS =
  DarwinInitializationSettings(
    requestSoundPermission: true,
    requestBadgePermission: true,
    requestAlertPermission: true,
    onDidReceiveLocalNotification: onDidReceiveLocalNotification, //благодаря этому методу получаем локальное уведомление
  );
  final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onDidReceiveNotificationResponse: onDidReceiveNotificationResponse ); //вызываем и ждём местную службу уведомлений
}
//снова указываем настрйоки IOS and Android, то как должно отображаться наше уведомление на Android и IOS
  Future<NotificationDetails> _showNotificationWithActions() async {
    const AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails(
'channel_id','channel_name', channelDescription: 'myDescription',
      importance: Importance.max,//наша важность
      priority: Priority.max, //наш приоритет
      playSound: true, //врубаем звук на уведомление
      actions: <AndroidNotificationAction>[
        AndroidNotificationAction('id_1', 'Action 1'),
        AndroidNotificationAction('id_2', 'Action 2'),
      ],
    );
    const NotificationDetails notificationDetails =
    NotificationDetails(android: androidNotificationDetails);
    //вот здесь второй раз вызывается метод, отвечающий за вызов уведомления
    // await flutterLocalNotificationsPlugin.show(
    //     0, '...', '...', notificationDetails);
return notificationDetails;
  }

Future<void> showNotification(int id, String? title, String? body, String? payload ) async {
  print('My label: ${id},${title}');
  final details = await _showNotificationWithActions(); //получаем детали настройки
await flutterLocalNotificationsPlugin.show(id, title, body, details);
}

  // void onDidReceiveNotificationResponse(NotificationResponse notificationResponse) async {
  //   final String? payload = notificationResponse.payload;
  //   if (notificationResponse.payload != null) {
  //     debugPrint('notification payload: $payload');
  //   }
  //   await Navigator.push(
  //     context,
  //     MaterialPageRoute<void>(builder: (context) => SecondScreen(payload)),
  //   );
  // }


  void onDidReceiveLocalNotification(int id, String? title, String? body, String? payload) {

  }

  //этот метод отвечает за полезную нагрузку нашего уведомления
  void onDidReceiveNotificationResponse(NotificationResponse details) {
  }
//   void myPayloadmethod(String? payload){
// if(payload!=null){
//   onNotificationCkisk.add(payload);
// }
//   }
}

