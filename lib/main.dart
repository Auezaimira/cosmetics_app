import 'package:cosmetics_app/providers/user_provider.dart';
import 'package:cosmetics_app/screens/add_note_screen.dart';
import 'package:cosmetics_app/screens/home_screen.dart';
import 'package:cosmetics_app/screens/notes_screen.dart';
import 'package:cosmetics_app/screens/profile_screen.dart';
import 'package:cosmetics_app/screens/registration_screen.dart';
import 'package:cosmetics_app/screens/user_preferences_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

import 'screens/ai_assistant.dart';
import 'screens/login_screen.dart';

Future main() async {
  await dotenv.load(fileName: ".env");

  runApp(
    ChangeNotifierProvider(
        create: (context) => UserProvider(),
        child: MaterialApp(
          title: 'Aimira',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
                seedColor: const Color.fromARGB(255, 135, 97, 210)),
            primaryColor: const Color.fromARGB(255, 225, 190, 231),
            useMaterial3: true,
          ),
          home: const LoginPage(),
          routes: {
            '/home': (context) => const HomePage(),
            '/login': (context) => const LoginPage(),
            '/registration': (context) => const RegistrationPage(),
            '/ai-assistant': (context) => const AIConsultantPage(),
            '/profile': (context) => const ProfilePage(),
            '/notes': (context) => const NotesPage(),
            '/notes/add': (context) => const AddNotePage(),
            '/user-preferences': (context) => const UserPreferencesPage(),
          },
        )),
  );
}
