import 'package:flutter/material.dart';
import 'package:productosapp/screens/screens.dart';
import 'package:provider/provider.dart';
import 'package:productosapp/services/auth_service.dart';

class CheckAuthScreen extends StatelessWidget {
  const CheckAuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    return Scaffold(
      body: Center(
          child: FutureBuilder(
        future: authService.readToken(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Text('');
          if (snapshot.data == '') {
            // sirve para que lo haga tan pronto pueda que redibuje el widget
            Future.microtask(() {
              Navigator.pushReplacement(
                  context,
                  PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          const LoginScreen(),
                      transitionDuration: const Duration(seconds: 0)));
            });
          } else {
            Future.microtask(() {
              Navigator.pushReplacement(
                  context,
                  PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          const HomeScreen(),
                      transitionDuration: const Duration(seconds: 0)));
            });
          }
          return Container();
        },
      )),
    );
  }
}
