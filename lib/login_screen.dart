import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app_settings.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appSettingsData = ref.watch(appSettingsProvider);
    final appSettingsNotifier = ref.watch(appSettingsProvider.notifier);

    TextEditingController usernameController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

    return Scaffold(
      backgroundColor: const Color(0xFF009899),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Siemens',
              style: TextStyle(
                fontFamily: 'Frutiger',
                fontSize: 70,
                color: Colors.white
              ),
            ),
            const SizedBox(height: 80.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 80.0),
              child: TextField(
                controller: usernameController,
                decoration: InputDecoration(
                  hintText: 'Username',
                  errorText: (appSettingsData.loggedInUser == 'invalid') ? 'Invalid Credentials' : null,
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 80.0),
              child: TextField(
                controller: passwordController,
                decoration: InputDecoration(
                  hintText: 'Password',
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                obscureText: true,
              ),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.grey)),
              onPressed: () {
                String username = usernameController.text;
                String password = passwordController.text;

                if (username == 'admin' && password == 'admin') {
                  appSettingsNotifier.setLoggedInUser('admin');
                  appSettingsNotifier.toggleLoggingIn();
                } else if (username == 'user' && password == 'user') {
                  appSettingsNotifier.setLoggedInUser('user');
                  appSettingsNotifier.toggleLoggingIn();
                } else {
                  usernameController.clear();
                  passwordController.clear();
                  appSettingsNotifier.setLoggedInUser('invalid');
                }
              },
              child: const Text('  Login  '),
            ),
          ],
        ),
      )
    );
  }
}
