import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AuthFunc extends StatelessWidget {
  const AuthFunc({
    super.key,
    required this.loggedIn,
    required this.signOut,
  });

  final bool loggedIn;
  final void Function() signOut;

  @override
  Widget build(BuildContext context) {
    final ButtonStyle style = ElevatedButton.styleFrom(
      textStyle: const TextStyle(
        fontSize: 20,
      ),
      foregroundColor: Colors.white,
      backgroundColor: const Color(0xffFF966A),
      padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
      shape: const StadiumBorder(),
      elevation: 5,
    );

    return Column(
      children: <Widget>[
        ElevatedButton(
          style: style,
          onPressed: () {
            !loggedIn ? context.push('/sign-in') : signOut();
          },
          child: !loggedIn ? const Text('Sign in') : const Text('Logout'),
        ),
        const SizedBox(height: 20),
        Visibility(
          visible: loggedIn,
          child: ElevatedButton(
            style: style,
            onPressed: () {
              context.push('/profile');
            },
            child: const Text('Profile'),
          ),
        ),
        const SizedBox(height: 20),
        Visibility(
          visible: loggedIn,
          child: ElevatedButton(
            style: style,
            onPressed: () {
              context.push('/map');
            },
            child: const Text('Maps'),
          ),
        ),
      ],
    );
  }
}
