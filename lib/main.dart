// ignore_for_file: avoid_print


// ...

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:valo_accounts/constants/components.dart';
import 'package:valo_accounts/cubit/cubit_functions.dart';
import 'package:valo_accounts/cubit/states.dart';
import 'package:valo_accounts/local/cach.dart';
import 'package:valo_accounts/screens/home_screen.dart';
import 'package:valo_accounts/screens/login_screen.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform,);
  await CasheHelper.init();
  uId = CasheHelper.getData(key: 'uId');
  Widget widget;

  if (uId != null) {
    widget =  HomeScreen();
    print('uid here');
  } else {
    widget = const LoginScreen();
    print('uid is not here');

  }
  runApp(MyApp(
    theStart: widget,
  ));
}

class MyApp extends StatelessWidget {
   const MyApp({super.key, required this.theStart});

  // This widget is the root of your application.
   final Widget theStart;

   @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) =>ValoAccCubit()..GetUserData()..user_model..GetSharedAccounts()..GetSharedAccounts(),
      child: BlocConsumer<ValoAccCubit,ValoAccStates>(
        listener: (context, state) {},
        builder: (context, state) {
         return MaterialApp(
            theme: ThemeData.dark().copyWith(scaffoldBackgroundColor: mobileBackgroundColor,),
            title: 'Flutter instagram',
            debugShowCheckedModeBanner: false,
            home: theStart,
          );
        },
      ),
    );
  }
}
