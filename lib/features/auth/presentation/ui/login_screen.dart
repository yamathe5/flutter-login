import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youtube_sample_app/route/go_router_notifier.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../components/my_button.dart';
import '../../../../components/my_textfield.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  //sign user in method
  void signUserIn() async {
    //show loading circle
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      //pop loading circle
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      if (e.code == 'user-not-found') {
        wrongEmailMessage();
      } else if (e.code == 'wrong-password') {
        wrongPasswordMessage();
      } else {
        wrongCredentialsMessage();
      }
    }
  }

  void wrongEmailMessage() {
    showDialog(
        context: context,
        builder: ((context) {
          return const AlertDialog(
            title: Text('Incorrect email'),
          );
        }));
  }

  //wrong password message popup
  void wrongPasswordMessage() {
    showDialog(
        context: context,
        builder: ((context) {
          return const AlertDialog(
            title: Text('Incorrect password'),
          );
        }));
  }

  //wrong password message popup
  void wrongCredentialsMessage() {
    showDialog(
        context: context,
        builder: ((context) {
          return const AlertDialog(
            title: Text('Incorrect credentials'),
          );
        }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,

        /// para centrar todos los documentos
        children: [
          // const SizedBox(height: 50),
          // logo

          const Icon(
            // Welcome
            Icons.lock,
            size: 100,
          ),

          const SizedBox(height: 50),

          // Welcome
          Text(
            'Bienvenido de vuelta',
            style: TextStyle(
              color: Colors.grey[700],
              fontSize: 16,
            ),
          ),

          const SizedBox(height: 25),

          // usrname texfield

          MyTextField(
            controller: emailController,
            hintText: 'Email',
            obscureText: false,
          ),

          const SizedBox(height: 10),
          // password textfield

          MyTextField(
            controller: passwordController,
            hintText: 'Password',
            obscureText: true,
          ),
          const SizedBox(height: 10),

          // forgot password?

          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Olvidaste tu contraseña?',
                    style: TextStyle(color: Colors.grey[600]),
                  )
                ],
              )),

          const SizedBox(height: 25),
          // sign in button
          MyButton(
            onTap: signUserIn,
          ),
          const SizedBox(height: 50),

          // or continue with
          Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 25,
              ),
              child: Row(
                children: [
                  Expanded(
                      child: Divider(
                    thickness: 0.5,
                    color: Colors.grey[400],
                  )),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      'O continua con',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                  ),
                  Expanded(
                      child: Divider(
                    thickness: 0.5,
                    color: Colors.grey[400],
                  ))
                ],
              )),
          const SizedBox(height: 20),

          // google + apple sign in buttons
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.white),
                borderRadius: BorderRadius.circular(16),
                color: Colors.grey[200]),
            child: Image.asset(
              '../assets/img/google.png',
              width: 40,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text('No tiene cuenta?'),
              SizedBox(width: 4),
              Text(
                'Registrese ahora',
                style:
                    TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
              ),
            ],
          )
          // not a member? register noe
        ],
      )),
    );
  }
}
