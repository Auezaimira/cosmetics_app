import 'package:cosmetics_app/network/api_service.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../providers/user_provider.dart';
import '../widgets/custom_textfield.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  XFile? _image;
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final XFile? selectedImage =
        await _picker.pickImage(source: ImageSource.gallery);

    if (selectedImage != null) {
      setState(() {
        _image = selectedImage;
      });

      try {
        final updatedUser =
            await ApiService.uploadProfileImage(selectedImage.path);

        if (!mounted) return;
        Provider.of<UserProvider>(context, listen: false).setUser(updatedUser);

        Fluttertoast.showToast(
          msg: 'Фото профиля успешно обновлено',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );
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
  }

  Future<void> _updateProfile(
      TextEditingController email, TextEditingController fullName) async {
    final userData = ({
      'email': email.text,
      'fullName': fullName.text,
    });

    try {
      final updatedUser = await ApiService.updateUser(userData);

      if (!mounted) return;

      Provider.of<UserProvider>(context, listen: false).setUser(updatedUser);

      Fluttertoast.showToast(
        msg: 'Профиль успешно обновлен',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );
    } catch (error) {
      throw Exception('Error: $error');
    }
  }

  Future<void> _onLogout() async {
    try {
      await ApiService.logout();

      Fluttertoast.showToast(
        msg: 'Успешный выход',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );

      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/login');
      }
    } catch (error) {
      Fluttertoast.showToast(
        msg: 'Произошла ошибка $error',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;

    _emailController.text = (user?.email ?? "");
    _nameController.text = (user?.fullName ?? "");
    _image = XFile(user?.profileImageUrl ?? "");

    return Scaffold(
      backgroundColor: Colors.pink[100],
      appBar: AppBar(
        backgroundColor: Colors.pink[200],
        title: const Text(style: TextStyle(color: Colors.white), 'Профиль'),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
              icon: const Icon(Icons.logout),
              tooltip: 'Выход',
              onPressed: _onLogout),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(user?.profileImageUrl ?? ""),
                  child: (_image == null || user?.profileImageUrl == null)
                      ? const Icon(Icons.camera_alt, size: 50)
                      : null,
                )),
            const SizedBox(height: 16.0),
            const Text(
              'Настройки профиля',
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.white70,
                  fontWeight: FontWeight.normal),
            ),
            const SizedBox(height: 8.0),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 0.0, horizontal: 16.0),
              child: CustomTextField(
                controller: _emailController,
                hintText: 'email',
              ),
            ),
            const SizedBox(height: 16.0),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 0.0, horizontal: 16.0),
              child: CustomTextField(
                controller: _nameController,
                hintText: 'Имя',
              ),
            ),
            const SizedBox(height: 12.0),
            ElevatedButton(
              onPressed: () =>
                  _updateProfile(_emailController, _nameController),
              child: const Text('Сохранить'),
            ),
          ],
        ),
      ),
    );
  }
}
