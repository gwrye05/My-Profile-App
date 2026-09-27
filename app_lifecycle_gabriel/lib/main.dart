import 'package:flutter/material.dart';



void main() {

  runApp(const MyApp());

}



class MyApp extends StatefulWidget {

  const MyApp({super.key});



  @override

  State<MyApp> createState() => _MyAppState();

}



class _MyAppState extends State<MyApp> with WidgetsBindingObserver {

  @override

  void initState() {

    super.initState();



    WidgetsBinding.instance.addObserver(this);

  }



  @override

  void didChangeAppLifecycleState(AppLifecycleState state) {

    switch (state) {

      case AppLifecycleState.resumed:

        print('App status: Resumed');

        break;



      case AppLifecycleState.inactive:

        print('App status: Inactive');

        break;



      case AppLifecycleState.paused:

        print('App status: Paused');

        break;



      case AppLifecycleState.detached:

        print('App status: Detached');

        break;



      case AppLifecycleState.hidden:

        print('App status: Hidden');

        break;

    }

  }



  @override

  void dispose() {

    WidgetsBinding.instance.removeObserver(this);



    super.dispose();

  }



  @override

  Widget build(BuildContext context) {

    return MaterialApp(

      home: Scaffold(

        appBar: AppBar(

          title: const Text('App Lifecycle'),

        ),

        body: const Center(

          child: Text(

            'App Lifecycle Example',

            style: TextStyle(fontSize: 24),

          ),

        ),

      ),

    );

  }

}
