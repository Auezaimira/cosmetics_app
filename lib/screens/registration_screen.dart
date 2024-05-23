import 'package:cosmetics_app/network/api_service.dart';
import 'package:cosmetics_app/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'home_screen.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  static const mainColor = Color.fromARGB(255, 196, 68, 140);
  final apiService = ApiService();
  late final TextEditingController _fullName = TextEditingController();
  late final TextEditingController _email = TextEditingController();
  late final TextEditingController _password = TextEditingController();
  late final TextEditingController _passwordConfirmation =
      TextEditingController();

  @override
  void dispose() {
    _fullName.dispose();
    _email.dispose();
    _password.dispose();
    _passwordConfirmation.dispose();
    super.dispose();
  }

  String getEmailValue() {
    return _email.text;
  }

  Future<void> _register() async {
    String fullName = _fullName.text;
    String email = _email.text;
    String password = _password.text;

    try {
      await ApiService.registerUser(
          email: email, password: password, fullName: fullName);

      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const HomePage(),
          ),
        );
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
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: mainColor,
        ),
        elevation: 0,
        leading: const BackButton(),
        title: const Text(
          'Вход в учетную запись',
          style: TextStyle(color: mainColor),
        ),
      ),
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
              const SizedBox(height: 16.0),
              CustomTextField(
                controller: _fullName,
                hintText: 'Введите имя',
              ),
              const SizedBox(height: 12.0),
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
              const SizedBox(height: 12.0),
              CustomTextField(
                controller: _passwordConfirmation,
                hintText: 'Подтвердите пароль',
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
                            onPressed: _register,
                            child: const Text('ЗАРЕГИСТРИРОВАТЬСЯ'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
