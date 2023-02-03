import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void signUserOut() {
    // print(FirebaseAuth.instance.curre);
    // print(FirebaseAuth.instance.signo);

    // FirebaseAuth.instance.signOut();
    // context.go('/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Home Screen'),
            ElevatedButton.icon(
              onPressed: () {
                GoRouter.of(context).push('/productDetail/100');
              },
              icon: const Icon(Icons.next_plan),
              label: const Text('Product Detail'),
            )
          ],
        ),
      ),
    );
  }
}
