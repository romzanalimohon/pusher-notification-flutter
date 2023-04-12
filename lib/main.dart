import 'dart:async';
import 'dart:convert';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:push_notification/push_notification.dart';

import 'package:pusher_websocket_flutter/pusher.dart';
Future<void> main() async {



  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}


class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  late Channel _channel;

  String user_name = '';





  late FlutterLocalNotificationsPlugin localNotification;



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initPusher();

    var androidInitialize = new AndroidInitializationSettings('ic_launcher');
    var initializationSettings = new InitializationSettings(android: androidInitialize);
    localNotification = new FlutterLocalNotificationsPlugin();
    localNotification.initialize(initializationSettings);
  }

  Future _showNotification() async{

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(user_name),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.notifications),
        onPressed: _showNotification,
      ),
    );
  }


  Future<void> _initPusher() async{
    try{
      await Pusher.init('52ac6f15d9e885669467', PusherOptions(cluster: 'ap2'));
    }catch(e){
      print(e);
    }

    //connect
    Pusher.connect(
      onConnectionStateChange: (value){
        print(value.currentState);
      },
      onError: (err){
        print(err.message);
      }
    );

    //subscribe
    _channel = await Pusher.subscribe('anime_channel');

    //bind
    _channel.bind('anime_event', (onEvent) async{
      //print(onEvent.data);
      final data = json.decode(onEvent.data);
      if(mounted){

        setState(() {
          print((data['name']));
          user_name = data['species'];

         // Get.snackbar(data['name'], data['species']);




          var androidDetails = new AndroidNotificationDetails(
              "channelId",
              "local notification"
                  "this is description",
              importance: Importance.high
          );
          var generalNotificationDetails = new NotificationDetails(
              android: androidDetails
          );
           localNotification.show(0, data['name'], data['species'], generalNotificationDetails);


        });
      }

    });

  }

}



