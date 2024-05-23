import 'package:cosmetics_app/widgets/dropdown_button.dart';
import 'package:flutter/material.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';
import 'package:provider/provider.dart';

import '../globals/constants.dart';
import '../models/user_preferences.model.dart';
import '../network/api_service.dart';
import '../providers/user_provider.dart';
import '../utils/logger.dart';

class UserPreferencesPage extends StatefulWidget {
  const UserPreferencesPage({super.key});

  @override
  State<UserPreferencesPage> createState() => _UserPreferencesPageState();
}

class _UserPreferencesPageState extends State<UserPreferencesPage> {
  final Map<String, List<String>> _selectedPreferences = {};

  @override
  void dispose() {
    super.dispose();
  }

  // Future<void> loadUserPreferences() async {
  //   print('loading preferences');
  //   final userId = Provider.of<UserProvider>(context, listen: false).user?.id;
  //   if (userId != null) {
  //     try {
  //       final preferences = await ApiService.getPreferences(userId);
  //       final Map<String, List<String>> transformedPreferences = {};
  //       for (var preference in preferences) {
  //         transformedPreferences[preference.preferenceType] =
  //             preference.preferenceValue;
  //       }
  //       setState(() {
  //         _selectedPreferences = transformedPreferences;
  //       });
  //     } catch (e) {
  //       MyLogger.log.e("Ошибка загрузки предпочтений: $e");
  //     }
  //   }
  // }

  void _updatePreference(
      String preferenceType, List<ValueItem<String>> selectedOptions) {
    setState(() {
      _selectedPreferences[preferenceType] =
          selectedOptions.map((e) => e.label).toList();
    });
  }

  Future<void> saveUserPreferences() async {
    final userId = Provider.of<UserProvider>(context, listen: false).user?.id;
    if (userId == null) {
      MyLogger.log.d("Ошибка: userId не найден.");
      return;
    }

    final List<UserPreference> preferences =
        _selectedPreferences.entries.map((entry) {
      return UserPreference(
        preferenceType: entry.key,
        preferenceValue: entry.value,
      );
    }).toList();

    await ApiService.savePreferences(userId, preferences);

    MyLogger.log.i("Сохраняем предпочтения: $preferences");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink[100],
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.pink[200],
        title: const Text(
          'Предпочтения',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            MyDropDown(
              options: Constants.skinTypeOptions,
              hint: 'Тип кожи',
              onOptionsSelected: (selectedOptions) {
                _updatePreference('skinType', selectedOptions);
              },
            ),
            const SizedBox(height: 16.0),
            MyDropDown(
              options: Constants.skinConcerns,
              hint: 'Проблемы кожи',
              selectionType: SelectionType.multi,
              onOptionsSelected: (selectedOptions) {
                _updatePreference('skinConcern', selectedOptions);
              },
            ),
            const SizedBox(height: 16.0),
            MyDropDown(
              options: Constants.hairTypeOptions,
              hint: 'Тип волос',
              onOptionsSelected: (selectedOptions) {
                _updatePreference('hairType', selectedOptions);
              },
            ),
            const SizedBox(height: 16.0),
            MyDropDown(
              options: Constants.ingredients,
              hint: 'Содержит',
              selectionType: SelectionType.multi,
              onOptionsSelected: (selectedOptions) {
                _updatePreference('ingredients', selectedOptions);
              },
            ),
            const SizedBox(height: 16.0),
            MyDropDown(
              options: Constants.productPurposes,
              selectionType: SelectionType.multi,
              hint: 'Назначение продукта',
              onOptionsSelected: (selectedOptions) {
                _updatePreference('purpose', selectedOptions);
              },
            ),
            const SizedBox(height: 16.0),
            MyDropDown(
              options: Constants.ethicalPreferences,
              hint: 'Этические предпочтения',
              selectionType: SelectionType.multi,
              onOptionsSelected: (selectedOptions) {
                _updatePreference('ethicalPreferences', selectedOptions);
              },
            ),
            const SizedBox(height: 16.0),
            MyDropDown(
              options: Constants.ageGroups,
              hint: 'Возрастная группа',
              onOptionsSelected: (selectedOptions) {
                _updatePreference('ageGroup', selectedOptions);
              },
            ),
            const SizedBox(height: 16.0),
            MyDropDown(
              options: Constants.brands,
              hint: 'Бренд',
              onOptionsSelected: (selectedOptions) {
                _updatePreference('brand', selectedOptions);
              },
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async => await saveUserPreferences(),
              child: const Text('Сохранить предпочтения'),
            ),
          ],
        ),
      ),
    );
  }
}
