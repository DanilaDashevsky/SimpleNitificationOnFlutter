import 'package:flutter/material.dart';
import 'package:untitled/SecondPage.dart';
import 'package:untitled/notification_service.dart';
import 'package:untitled/simple_notification_service.dart';

///Важно!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
///Заголовок меняется в \android\app\src\main\AndroidManifest.xml в поле label


Future<void> main() async {
  runApp(MaterialApp(
    home: MyApp()
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  late final Plugin service;
  late final SimpleNotification simpleService;
  @override
  void initState(){
    //service = Plugin();
    simpleService = SimpleNotification();
    //service.initialize();
    ///и вся проблема до этого была в том, что я не вызывал метод инициализации
    simpleService.init(); ///обязательно инициализируй этот класс, там есть важные насйтроки
    listenToNotification(); ///используется для прослушки наших уведомлений
    simpleService.showNotifications(1, 'Мой заголовок', 'Тело моего уведомления','sss' );
    super.initState();
  }
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Container(child: Column(children: [
        Padding(padding: EdgeInsets.only(top: 100)),
        ElevatedButton(onPressed: () async { /*await service.showNotification(1, 'Мой заголовок', 'Тело моего уведомления','ssss');*/}, child: Text('Показать первое уведомление')),
        ElevatedButton(onPressed: () async { await simpleService.showNotifications(1, 'Мой заголовок', 'Тело моего уведомления','ssss');}, child: Text('Показать первое уведомление')),
        ElevatedButton(onPressed: () async { await simpleService.showScheduleNotifications(1, 'Мой заголовок', 'Тело моего уведомления','sss', );}, child: Text('Показать первое уведомление')),
        ElevatedButton(onPressed: () async { Navigator.of(context).push(MaterialPageRoute(builder:(context)=>SecondPage()));}, child: Text('Показать первое уведомление')),
      ],),),
    ));
}

///onNotofication - это объект BehaviorSubject(конроллера потоков), в котором мы слушаем полезную нагрузку, если мало ли нам понадобится отправит её на другую страницу
void listenToNotification()=>SimpleNotification.onNotofication.stream.listen(onClickedNotification);

  //Вместо SecondPage должен быть класс, отображающий вторую страницу
  ///Как я понял, если в поток поступает какое-то строковое значение(от того, что мы нажали), то срабатывает тригер onClickedNotification
  void onClickedNotification(String? payload) =>
      Navigator.of(context).push(MaterialPageRoute(builder:(context)=>SecondPage()));


}
