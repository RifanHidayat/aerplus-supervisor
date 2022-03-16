import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:superviso/assets/colors.dart';
import 'package:superviso/blocs/attendance/attandace_submission.dart';
import 'package:superviso/blocs/leave/leave_bloc.dart';
import 'package:superviso/blocs/login/auth_bloc.dart';
import 'package:superviso/blocs/permission/permission_bloc.dart';
import 'package:superviso/blocs/sick/sick_bloc.dart';
import 'package:superviso/pages/splash/splash.dart';
import 'package:superviso/repositories/attandance.dart';
import 'package:superviso/repositories/auth.dart';
import 'package:superviso/repositories/checkin.dart';
import 'package:superviso/repositories/leave.dart';
import 'package:superviso/repositories/permission.dart';
import 'package:superviso/repositories/sick.dart';

import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';

import 'package:flutter_background_service/flutter_background_service.dart';

import 'package:workmanager/workmanager.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  await initializeService();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(MyApp());
}

void onIosBackground() {
  WidgetsFlutterBinding.ensureInitialized();
  print('FLUTTER BACKGROUND FETCH');
}

Future<void> initializeService() async {
  final service = FlutterBackgroundService();
  await service.configure(
    androidConfiguration: AndroidConfiguration(
      // this will executed when app is in foreground or background in separated isolate
      onStart: onStart,

      // auto start service
      autoStart: true,
      isForegroundMode: true,
    ),
    iosConfiguration: IosConfiguration(
      // auto start service
      autoStart: true,

      // this will executed when app is in foreground in separated isolate
      onForeground: onStart,

      // you have to enable background fetch capability on xcode project
      onBackground: onIosBackground,
    ),
  );
}

void onStart() {
  WidgetsFlutterBinding.ensureInitialized();

  final service = FlutterBackgroundService();
  service.onDataReceived.listen((event) {
    if (event!["action"] == "setAsForeground") {
      service.setForegroundMode(true);
      return;
    }

    if (event["action"] == "setAsBackground") {
      service.setForegroundMode(false);
    }

    if (event["action"] == "stopService") {
      service.stopBackgroundService();
    }
  });

  // bring to foreground
  service.setForegroundMode(true);
  Timer.periodic(const Duration(seconds: 5), (timer) async {
    await Firebase.initializeApp();

    if (!(await service.isServiceRunning())) timer.cancel();
    // service.setNotificationInfo(
    //   title: "My App Service",
    //   content: "Updated at ${DateTime.now()}",
    // );
    _MyAppState().getCurrentLocation();

    // test using external plugin
    final deviceInfo = DeviceInfoPlugin();
    String? device;
    if (Platform.isAndroid) {
      final androidInfo = await deviceInfo.androidInfo;
      device = androidInfo.model;
    }

    if (Platform.isIOS) {
      final iosInfo = await deviceInfo.iosInfo;
      device = iosInfo.model;
    }

    service.sendData(
      {
        "current_date": DateTime.now().toIso8601String(),
        "device": device,
      },
    );
  });
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var employeeId = 0, latitude = 0.0, longitude = 0.0, currentAddress = "null";
  Position? _currentPosition;

  Future<void> init() async {
    WidgetsFlutterBinding.ensureInitialized();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getDataPref("");

    // Timer.periodic(Duration(seconds: 10), (Timer t) => getCurrentLocation());
  }

  getCurrentLocation() {
    Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      _currentPosition = position;
      latitude = _currentPosition!.latitude;
      longitude = _currentPosition!.longitude;

      _getAddressFromLatLng(
          position.latitude.toString(), position.longitude.toString());
    }).catchError((e) {
      print(e);
    });
  }

  _getAddressFromLatLng(var latitude, longitude) async {
    try {
      List<Placemark> p = await Geolocator().placemarkFromCoordinates(
          double.parse(latitude), double.parse(longitude.toString()));

      Placemark place = p[0];

      //setState(() {
      currentAddress =
          "${place.locality}, ${place.postalCode}, ${place.country}";
      //});

      getDataPref("${place.locality}, ${place.postalCode}, ${place.country}");
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthRepository>(
            create: (context) => AuthRepository()),
        RepositoryProvider<SickRepository>(
            create: (context) => SickRepository()),
        RepositoryProvider<PermissionRepository>(
            create: (context) => PermissionRepository()),
        RepositoryProvider<AttendanceRepository>(
            create: (context) => AttendanceRepository()),
        RepositoryProvider<CheckinRepository>(
            create: (context) => CheckinRepository()),
        RepositoryProvider<LeaveRepository>(
            create: (context) => LeaveRepository()),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>(
            create: (BuildContext context) =>
                AuthBloc(authRepository: context.read<AuthRepository>()),
          ),
          BlocProvider<AttendanceBloc>(
            create: (context) => AttendanceBloc(
              attendanceRepository: context.read<AttendanceRepository>(),
            ),
          ),
          BlocProvider<SickBloc>(
              create: (context) =>
                  SickBloc(sickRepository: context.read<SickRepository>())),
          BlocProvider<PermissionBloc>(
              create: (context) => PermissionBloc(
                  permissionRepository: context.read<PermissionRepository>())),
          BlocProvider<LeaveBloc>(
              create: (context) =>
                  LeaveBloc(leaveRepository: context.read<LeaveRepository>()))
        ],
        child: GetMaterialApp(
          color: baseColor,
          debugShowCheckedModeBanner: false,
          title: 'Aerplus Supervisor',
          home: SplassPage(),
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
        ),
      ),
    );
  }

  Future<void> sendData(var currentAddress,employeeId) async {
    await FirebaseFirestore.instance
        .collection('employee_locations')
        .doc(employeeId.toString())
        .update({
      "address": currentAddress.toString(),
      "latitude": latitude.toString(),
      "longitude": longitude.toString()
    }).then((result) {
      print("Saved");
    }).catchError((onError) {
      print("onError ${onError}");
    });
  }

  void getDataPref(var currentAddress) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    // print("employee_id${sharedPreferences.getInt("employee_id")}");
    // setState(() {
    // isTrack = sharedPreferences.getBool("isTrack") ?? false;
    employeeId = sharedPreferences.getInt("employee_id")!;
    // name = sharedPreferences.getString("name");
    // });

    if (employeeId != null) {
      sendData(currentAddress,sharedPreferences.getInt("employee_id")??"0");
    }
  }
}

//
// import 'dart:async';
// import 'dart:io';
//
// import 'package:device_info_plus/device_info_plus.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_background_service/flutter_background_service.dart';
//
// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await initializeService();
//   runApp(const MyApp());
// }
//
// Future<void> initializeService() async {
//   final service = FlutterBackgroundService();
//   await service.configure(
//     androidConfiguration: AndroidConfiguration(
//       // this will executed when app is in foreground or background in separated isolate
//       onStart: onStart,
//
//       // auto start service
//       autoStart: true,
//       isForegroundMode: true,
//     ),
//     iosConfiguration: IosConfiguration(
//       // auto start service
//       autoStart: true,
//
//       // this will executed when app is in foreground in separated isolate
//       onForeground: onStart,
//
//       // you have to enable background fetch capability on xcode project
//       onBackground: onIosBackground,
//     ),
//   );
// }
//
// // to ensure this executed
// // run app from xcode, then from xcode menu, select Simulate Background Fetch
// void onIosBackground() {
//   WidgetsFlutterBinding.ensureInitialized();
//   print('FLUTTER BACKGROUND FETCH');
// }
//
// void onStart() {
//   WidgetsFlutterBinding.ensureInitialized();
//
//   final service = FlutterBackgroundService();
//   service.onDataReceived.listen((event) {
//     if (event!["action"] == "setAsForeground") {
//       service.setForegroundMode(true);
//       return;
//     }
//
//     if (event["action"] == "setAsBackground") {
//       service.setForegroundMode(false);
//     }
//
//     if (event["action"] == "stopService") {
//       service.stopBackgroundService();
//     }
//   });
//
//   // bring to foreground
//   service.setForegroundMode(true);
//   Timer.periodic(const Duration(seconds: 1), (timer) async {
//     if (!(await service.isServiceRunning())) timer.cancel();
//     service.setNotificationInfo(
//       title: "My App Service",
//       content: "Updated at ${DateTime.now()}",
//     );
//
//     // test using external plugin
//     final deviceInfo = DeviceInfoPlugin();
//     String? device;
//     if (Platform.isAndroid) {
//       final androidInfo = await deviceInfo.androidInfo;
//       device = androidInfo.model;
//     }
//
//     if (Platform.isIOS) {
//       final iosInfo = await deviceInfo.iosInfo;
//       device = iosInfo.model;
//     }
//
//     service.sendData(
//       {
//         "current_date": DateTime.now().toIso8601String(),
//         "device": device,
//       },
//     );
//   });
// }
//
// class MyApp extends StatefulWidget {
//   const MyApp({Key? key}) : super(key: key);
//
//   @override
//   _MyAppState createState() => _MyAppState();
// }
//
// class _MyAppState extends State<MyApp> {
//   String text = "Stop Service";
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: const Text('Service App'),
//         ),
//         body: Column(
//           children: [
//             StreamBuilder<Map<String, dynamic>?>(
//               stream: FlutterBackgroundService().onDataReceived,
//               builder: (context, snapshot) {
//                 if (!snapshot.hasData) {
//                   return const Center(
//                     child: CircularProgressIndicator(),
//                   );
//                 }
//
//                 final data = snapshot.data!;
//                 String? device = data["device"];
//                 DateTime? date = DateTime.tryParse(data["current_date"]);
//                 return Column(
//                   children: [
//                     Text(device ?? 'Unknown'),
//                     Text(date.toString()),
//                   ],
//                 );
//               },
//             ),
//             ElevatedButton(
//               child: const Text("Foreground Mode"),
//               onPressed: () {
//                 FlutterBackgroundService()
//                     .sendData({"action": "setAsForeground"});
//               },
//             ),
//             ElevatedButton(
//               child: const Text("Background Mode"),
//               onPressed: () {
//                 FlutterBackgroundService()
//                     .sendData({"action": "setAsBackground"});
//               },
//             ),
//             ElevatedButton(
//               child: Text(text),
//               onPressed: () async {
//                 final service = FlutterBackgroundService();
//                 var isRunning = await service.isServiceRunning();
//                 if (isRunning) {
//                   service.sendData(
//                     {"action": "stopService"},
//                   );
//                 } else {
//                   service.start();
//                 }
//
//                 if (!isRunning) {
//                   text = 'Stop Service';
//                 } else {
//                   text = 'Start Service';
//                 }
//                 setState(() {});
//               },
//             ),
//           ],
//         ),
//         floatingActionButton: FloatingActionButton(
//           onPressed: () {
//             FlutterBackgroundService().sendData({
//               "hello": "world",
//             });
//           },
//           child: const Icon(Icons.play_arrow),
//         ),
//       ),
//     );
//   }
// }

// import 'dart:async';
// import 'dart:io';
//
// import 'package:device_info_plus/device_info_plus.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_background_service/flutter_background_service.dart';
//
// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//
//   runApp(const MyApp());
// }
//
// Future<void> initializeService() async {
//   final service = FlutterBackgroundService();
//   await service.configure(
//     androidConfiguration: AndroidConfiguration(
//       // this will executed when app is in foreground or background in separated isolate
//       onStart: onStart,
//
//       // auto start service
//       autoStart: true,
//       isForegroundMode: true,
//     ),
//     iosConfiguration: IosConfiguration(
//       // auto start service
//       autoStart: true,
//
//       // this will executed when app is in foreground in separated isolate
//       onForeground: onStart,
//
//       // you have to enable background fetch capability on xcode project
//       onBackground: onIosBackground,
//     ),
//   );
// }
//
// // to ensure this executed
// // run app from xcode, then from xcode menu, select Simulate Background Fetch
// void onIosBackground() {
//   WidgetsFlutterBinding.ensureInitialized();
//   print('FLUTTER BACKGROUND FETCH');
// }
//
// void onStart() {
//   WidgetsFlutterBinding.ensureInitialized();
//
//   final service = FlutterBackgroundService();
//   service.onDataReceived.listen((event) {
//     if (event!["action"] == "setAsForeground") {
//       service.setForegroundMode(true);
//       return;
//     }
//
//     if (event["action"] == "setAsBackground") {
//       service.setForegroundMode(false);
//     }
//
//     if (event["action"] == "stopService") {
//       service.stopBackgroundService();
//     }
//   });
//
//   // bring to foreground
//   service.setForegroundMode(true);
//   Timer.periodic(const Duration(seconds: 1), (timer) async {
//     if (!(await service.isServiceRunning())) timer.cancel();
//     service.setNotificationInfo(
//       title: "My App Service",
//       content: "Updated at ${DateTime.now()}",
//     );
//
//     // test using external plugin
//     final deviceInfo = DeviceInfoPlugin();
//     String? device;
//     if (Platform.isAndroid) {
//       final androidInfo = await deviceInfo.androidInfo;
//       device = androidInfo.model;
//     }
//
//     if (Platform.isIOS) {
//       final iosInfo = await deviceInfo.iosInfo;
//       device = iosInfo.model;
//     }
//
//     service.sendData(
//       {
//         "current_date": DateTime.now().toIso8601String(),
//         "device": device,
//       },
//     );
//   });
// }
//
// class MyApp extends StatefulWidget {
//   const MyApp({Key? key}) : super(key: key);
//
//   @override
//   _MyAppState createState() => _MyAppState();
// }
//
//
// class _MyAppState extends State<MyApp> {
//   String text = "Stop Service";
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     init();
//
//   }
//   void init() async{
//     await initializeService();
//   }
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: const Text('Service App'),
//         ),
//         body: Column(
//           children: [
//             StreamBuilder<Map<String, dynamic>?>(
//               stream: FlutterBackgroundService().onDataReceived,
//               builder: (context, snapshot) {
//                 if (!snapshot.hasData) {
//                   return const Center(
//                     child: CircularProgressIndicator(),
//                   );
//                 }
//
//                 final data = snapshot.data!;
//                 String? device = data["device"];
//                 DateTime? date = DateTime.tryParse(data["current_date"]);
//                 return Column(
//                   children: [
//                     Text(device ?? 'Unknown'),
//                     Text(date.toString()),
//                   ],
//                 );
//               },
//             ),
//             ElevatedButton(
//               child: const Text("Foreground Mode"),
//               onPressed: () {
//                 FlutterBackgroundService()
//                     .sendData({"action": "setAsForeground"});
//               },
//             ),
//             ElevatedButton(
//               child: const Text("Background Mode"),
//               onPressed: () {
//                 FlutterBackgroundService()
//                     .sendData({"action": "setAsBackground"});
//               },
//             ),
//             ElevatedButton(
//               child: Text(text),
//               onPressed: () async {
//                 final service = FlutterBackgroundService();
//                 var isRunning = await service.isServiceRunning();
//                 if (isRunning) {
//                   service.sendData(
//                     {"action": "stopService"},
//                   );
//                 } else {
//                   service.start();
//                 }
//
//                 if (!isRunning) {
//                   text = 'Stop Service';
//                 } else {
//                   text = 'Start Service';
//                 }
//                 setState(() {});
//               },
//             ),
//           ],
//         ),
//         floatingActionButton: FloatingActionButton(
//           onPressed: () {
//             FlutterBackgroundService().sendData({
//               "hello": "world",
//             });
//           },
//           child: const Icon(Icons.play_arrow),
//         ),
//       ),
//     );
//   }
// }
