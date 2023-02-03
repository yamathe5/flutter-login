import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youtube_sample_app/route/go_router_notifier.dart';

class SettingScreen extends ConsumerStatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends ConsumerState<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Setting'),
      // ),
      body: Center(
        child: Column(
          children: [
            const Text('Setting Screen'),
            ElevatedButton(
              onPressed: () {
                ref.read(goRouterNotifierProvider).isLoggedIn = false;
              },
              child: const Text('SignOut'),
            )
          ],
        ),
      ),
    );
  }
}
