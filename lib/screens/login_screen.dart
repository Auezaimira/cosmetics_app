import 'package:cosmetics_app/network/api_service.dart';
import 'package:cosmetics_app/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'registration_screen.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  static const mainColor = Color.fromARGB(255, 196, 68, 140);

  late final TextEditingController _email = TextEditingController();
  late final TextEditingController _password = TextEditingController();
  final apiService = ApiService();

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  String getEmailValue() {
    return _email.text;
  }

  Future<void> _login() async {
    String email = _email.text;
    String password = _password.text;

    try {
      await ApiService.login(email: email, password: password);

      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/home');
      }
    } catch (error) {
      Fluttertoast.showToast(
        msg: 'Упс, что-то пошло не так! $error',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      throw Exception('Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'lib/assets/womanLogo.svg',
                height: 150,
                width: 150,
              ),
              const Text(
                'Cosmetic Advisor',
                style: TextStyle(
                    color: mainColor,
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16.0),
              CustomTextField(
                controller: _email,
                hintText: 'Введите email',
              ),
              const SizedBox(height: 12.0),
              CustomTextField(
                controller: _password,
                hintText: 'Введите пароль',
                isPassword: true,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 50.0,
                          child: TextButton(
                            style: ButtonStyle(
                                shape:
                                    MaterialStateProperty.all<OutlinedBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                ),
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(mainColor),
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.white)),
                            onPressed: _login,
                            child: const Text(
                              'ВОЙТИ',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.white),
                ),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const RegistrationPage(),
                    ),
                  );
                },
                child: const Text(
                  'Еще не зарегистрированы?',
                  style: TextStyle(color: mainColor),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
