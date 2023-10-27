import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints.expand(),
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage("assets/images/background(2).png"),
            fit: BoxFit.cover),
      ),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          toolbarHeight: 250,
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: Column(
            children: [
              Image.asset(
                'assets/logo/dog_paw_logo.png',
                height: 120,
                width: 120,
                color: Colors.white,
              ),
              const SizedBox(
                width: 10,
              ),
              const Text(
                'Profile',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                ),
              ),
            ],
          ),
          centerTitle: true,
          automaticallyImplyLeading: false,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 180),
              ClipOval(
                child: Image.asset(
                  'assets/images/dog_profile.png',
                  scale: 0.75,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xffFF966A).withOpacity(0.6),
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: const EdgeInsets.only(
                    left: 50, right: 50, top: 20, bottom: 20),
                margin:
                    const EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Text(
                      'Name: Dog\'s name',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      'Breed: Dog\'s breed',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      'Age: Dog\'s age',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      'Sex: Male/Female',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      'Owner: Owner\'s name',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  textStyle: const TextStyle(
                    fontSize: 20,
                  ),
                  foregroundColor: Colors.white,
                  backgroundColor: const Color(0xffFF966A),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 40.0, vertical: 20.0),
                  shape: const StadiumBorder(),
                  elevation: 5,
                ),
                onPressed: () {
                  final confirmed = showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      contentTextStyle: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                      titleTextStyle: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      title: const Text('Confirm Delete'),
                      content: const Text(
                          'Are you sure you want to delete your account? This action cannot be undone.'),
                      actions: [
                        TextButton(
                          style: ButtonStyle(
                            foregroundColor:
                                MaterialStateProperty.all<Color>(Colors.black),
                          ),
                          onPressed: () => Navigator.of(context).pop(false),
                          child: const Text('Cancel'),
                        ),
                        ElevatedButton(
                          style: ButtonStyle(
                            foregroundColor:
                                MaterialStateProperty.all<Color>(Colors.white),
                          ),
                          onPressed: () => Navigator.of(context).pop(true),
                          child: const Text('Delete'),
                        ),
                      ],
                    ),
                  );

                  confirmed.then((confirmed) async {
                    if (confirmed == true) {
                      final user = FirebaseAuth.instance.currentUser;
                      if (user != null) {
                        try {
                          await user.delete();
                          // ignore: use_build_context_synchronously
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Account deleted successfully.')),
                          );
                          // ignore: use_build_context_synchronously
                          context.pushReplacement('/home');
                        } on FirebaseAuthException catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text(
                                    'Failed to delete account: ${e.message}')),
                          );
                        }
                      }
                    }
                  });
                },
                child: const Text('Delete Account'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
