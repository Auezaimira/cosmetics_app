import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class Navbar extends StatefulWidget {
  final void Function() onCurrentUserLoad;

  const Navbar({Key? key, required this.onCurrentUserLoad}) : super(key: key);

  @override
  State<Navbar> createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  static const mainColor = Color(0xFFF48FB1);
  int _selectedIndex = 0;
  int _previousIndex = 0;

  void _updateSelectedIndex(int index) {
    if (mounted) {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  void _onItemTapped(int index) {
    _previousIndex = _selectedIndex;
    setState(() {
      _selectedIndex = index;
    });
    if (index == 1) {
      Navigator.pushNamed(context, '/ai-assistant').then((_) {
        _updateSelectedIndex(_previousIndex);
      });
    }
    if (index == 2) {
      Navigator.pushNamed(context, '/profile').then((_) {
        _updateSelectedIndex(_previousIndex);
      });
    }
    if (index == 3) {
      Navigator.pushNamed(context, '/notes').then((_) {
        _updateSelectedIndex(_previousIndex);
      });
    }
    if (index == 4) {
      Navigator.pushNamed(context, '/user-preferences').then((_) {
        _updateSelectedIndex(_previousIndex);
        widget.onCurrentUserLoad();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SalomonBottomBar(
      backgroundColor: mainColor,
      currentIndex: _selectedIndex,
      onTap: _onItemTapped,
      items: [
        SalomonBottomBarItem(
          icon: const Icon(
            Icons.home,
            color: Colors.white,
          ),
          title: const Text("Home"),
          selectedColor: Colors.white,
        ),
        SalomonBottomBarItem(
          icon: const Icon(
            Icons.search,
            color: Colors.white,
          ),
          title: const Text("AI Consultant"),
          selectedColor: Colors.white,
        ),
        SalomonBottomBarItem(
          icon: const Icon(
            Icons.person,
            color: Colors.white,
          ),
          title: const Text("Profile"),
          selectedColor: Colors.white,
        ),
        SalomonBottomBarItem(
          icon: const Icon(
            Icons.note_add,
            color: Colors.white,
          ),
          title: const Text("Notes"),
          selectedColor: Colors.white,
        ),
        SalomonBottomBarItem(
          icon: const Icon(
            Icons.settings,
            color: Colors.white,
          ),
          title: const Text("Preferences"),
          selectedColor: Colors.white,
        ),
      ],
    );
  }
}
