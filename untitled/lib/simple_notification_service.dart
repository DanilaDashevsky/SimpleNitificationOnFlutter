import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';

///этот пакет необходим для определения нашей временной зоны
import 'package:timezone/timezone.dart' as tz;
import 'package:rxdart/rxdart.dart';
import 'package:timezone/data/latest.dart' as tz1;

///этот import обязателен, без него будет выдавать ошибку, он явно инициализирует часовой пояс, без которого
/// основной пакет timezone.dart ломается

class SimpleNotification {

  ///инициализируем главный класс нашего пакета
  static final FlutterLocalNotificationsPlugin simpleNotifications =
      FlutterLocalNotificationsPlugin();






  ///ссылка на документацию https://pub.dev/documentation/rxdart/latest/rx/BehaviorSubject-class.html
  ///BehaviorSubject - это специальный StreamController, который фиксирует последжний элемент, добавленный в контроллер, и отправляет его в качестве первого элемента любому новому слушателю
  static final onNotofication = BehaviorSubject<String?>(); ///






  ///Отвечает за вывод простого push-уведомления. Принимает стандартные параметры, последний элемент payload является полезной нагрузкой
  ///await notificationDetails() передаёт параметры вывода нашего push-уведомления для Android
  ///simpleNotifications.show - show() - встроенный метод в главный класс нашего пакета, который отвечает за вывод нашего уведомления
  Future showNotifications(int id, String? title, String? body, String? payload) async {
    simpleNotifications.show(id, title, body, await notificationDetails(), payload: payload);
  }





    ///Отвечает за вывод запланированного push-уведомления
   /// tz1.initializeTimeZones(); инициализация часового пояса
  /// _scheduleDaily(DateTime time) принимает в себя время, в кторое будет показано уведомление
    Future showScheduleNotifications(int id, String? title, String? body, String? payload) async {
    tz1.initializeTimeZones(); ///инициализация часового пояса
    final String currentTimeZone = await FlutterTimezone.getLocalTimezone(); ///создаём объект пакета flutter_timezone, который опреедляет текущую временную зону
    tz.setLocalLocation(tz.getLocation(currentTimeZone)); ///устанавливаем полученную временную зону в пакет timezone.dart
    ///zonedSchedule - таже show, но с другими особенностями
    simpleNotifications.zonedSchedule(id, title, body, _scheduleDaily(DateTime(0, 0, 0, 11, 50)), await notificationDetails(), payload: payload, androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
  }






///Метод инициализирует параметры вывода push-уведомления для платформ iOS и Android, какую иконку применить, разрешить ли звук на IOS и другие параметры
  Future init({bool initScheduled = false}) async {
//Устанавливаем иконку сообщения на Android, как понял, таже иконка будет на iOS
      const AndroidInitializationSettings initializationSettingsAndroid =
          AndroidInitializationSettings('ic_stat_m_logotipomz');

    ///onDidReceiveLocalNotification - необходим по той причине, что новые версии iOS запрашивают разрешение для отображения уведомлений
      /// сам по себе он определяет, что будет, если пользователь даст ответ. Я так понял:)
    final DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
      onDidReceiveLocalNotification: onDidReceiveLocalNotification, ///сам метод пустой
    );
    ///initializationSettings - содержит в себе общие настйроки для обоих систем
    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsIOS);

    ///регистриуем в нашем головном объекте общие настроки для обоих платформ и определяем событие на нажатие пользователя в событии onDidReceiveNotificationResponse,
      ///которое в данном случае добавляет в поток переданную ей полезную нагрузку(некоторое сообщенеи или значение например)
      await simpleNotifications.initialize(initializationSettings,
          onDidReceiveNotificationResponse: (payload) async {
            onNotofication.add(payload.payload); })  ;





      final details = await simpleNotifications.getNotificationAppLaunchDetails();
      //details.didNotificationLaunchApp - проверяет, запустило ли уведомление наше приложение
      if (details != null && details.didNotificationLaunchApp)
      {
        onNotofication.add(details.notificationResponse?.payload);
      }
  }

  ///Просто блок для декорации. largeIcon - содержит в себе просто путь для отображения бейджа справа изображения(не работает),FilePathAndroidBitmap - большое изображенеи снизу уведомления
  final styleInformation = BigPictureStyleInformation(
      FilePathAndroidBitmap('lib/assets/logotipomz'),
      largeIcon: FilePathAndroidBitmap('lib/assets/logotipomz'));



  ///Применение дополнительных параметром к уведомление на Android, где указаны канал_id, по которому будет идентифицироваться уведомление, имя канала,
  ///важность уведомления и есть куча других паарметров,таких как удаление звука и т.д.
  Future notificationDetails() async {
    return NotificationDetails(
      android: AndroidNotificationDetails('channel id', 'channel name',
          importance: Importance.max, styleInformation: styleInformation),
    );
  }

  void onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) {}


///tz.local - содержит в себе название часового пояса
  tz.TZDateTime _scheduleDaily(DateTime dateTime) {
    final now = tz.TZDateTime.now(tz.local); ///получаем текущее время из нашего часового пояса
    ///получаем текущее время
    ///получчаем у текущего времени год, месяцы, дни, часы...
    ///scheduledDate - это то время,в которое должно произойти наше уведомление
    final scheduledDate = tz.TZDateTime(tz.local, now.year, now.month, now.day, ///scheduledDate хранит в себе последнее время вывода уведомления и определяет, когда будет показано уведомление
        dateTime.hour, dateTime.minute, dateTime.day);

    ///если уведомление было отображено до текущего момента, то к дате вывода следующего уведомления прибовляется один день,
    return scheduledDate.isBefore(now)
        ? scheduledDate.add(Duration(days: 1))
        : scheduledDate; ///иначе оставляем всё как есть и выводим уведомление
  }
}



///Прикольный код=============================
//      DateTime dateTime = DateTime.now();
//      print(dateTime.timeZoneName); просто выводит текущую временну зону