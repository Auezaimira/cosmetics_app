import 'package:flutter/material.dart';
import 'package:multi_dropdown/models/value_item.dart';

import '../models/category.model.dart';

class Constants {
  static const List<Map<String, String>> tips = [
    {
      "title": "Увлажнение кожи",
      "description":
          "Увлажнение изнутри помогает поддерживать кожу здоровой и сияющей. Старайтесь пить не менее 8 стаканов воды в день.",
    },
    {
      "title": "Правильное питание",
      "description":
          "Сбалансированное питание, богатое антиоксидантами и витаминами, способствует здоровью кожи и волос.",
    },
    {
      "title": "Регулярная стрижка волос",
      "description":
          "Регулярная стрижка волос предотвращает посеченные концы и способствует их здоровому росту.",
    },
    {
      "title": "Мягкое сушение волос",
      "description":
          "Избегайте чрезмерного теплового воздействия при сушке волос. Позвольте волосам естественным образом высыхать как можно чаще.",
    },
    {
      "title": "Ночной уход за кожей",
      "description":
          "Ночной крем или сыворотка могут работать чудеса, восстанавливая вашу кожу во время сна.",
    },
    {
      "title": "Умеренное использование косметики",
      "description":
          "Чрезмерное использование косметики может забивать поры и приводить к проблемам с кожей.",
    },
    {
      "title": "Уход за кожей рук",
      "description":
          "Не забывайте о коже рук, особенно в холодное время года. Регулярно используйте питательный крем для рук.",
    },
  ];

  static List<Category> categories = [
    Category(name: 'Body spa', icon: Icons.spa),
    Category(name: 'Makeup', icon: Icons.palette),
    Category(name: 'Feet', icon: Icons.directions_walk),
    Category(name: 'Nail', icon: Icons.fingerprint),
    Category(name: 'Hair', icon: Icons.cut),
  ];

  static List<ValueItem<String>> ingredients = [
    ValueItem(label: 'Гиалуроновая кислота', value: 'Гиалуроновая кислота'),
    ValueItem(label: 'Ретинол(Витамин А)', value: 'Ретинол(Витамин А)'),
    ValueItem(label: 'Витамин C', value: 'Витамин C'),
    ValueItem(label: 'Витамин B3', value: 'Витамин B3'),
    ValueItem(label: 'Пептиды', value: 'Пептиды'),
    ValueItem(label: 'Цинк', value: 'Цинк'),
    ValueItem(label: 'Алоэ Вера', value: 'Алоэ Вера'),
    ValueItem(label: 'SPF', value: 'SPF'),
  ];

  static List<ValueItem<String>> ethicalPreferences = [
    ValueItem(
        label: 'Не тестируется на животных',
        value: 'Не тестируется на животных'),
    ValueItem(label: 'Органическая', value: 'Органическая'),
    ValueItem(label: 'Экологичная упаковка', value: 'Экологичная упаковка'),
    ValueItem(label: 'Отсутствие химикатов', value: 'Отсутствие химикатов'),
  ];

  static List<ValueItem<String>> brands = [
    ValueItem(label: 'StrengthHair', value: 'StrengthHair'),
    ValueItem(label: 'SunBlocker', value: 'SunBlocker'),
    ValueItem(label: 'Dr.Heimish', value: 'Dr.Heimish'),
    ValueItem(label: 'Dr.Ceuracle', value: 'Dr.Ceuracle'),
    ValueItem(label: 'Nivea', value: 'Nivea'),
    ValueItem(label: 'Head&Shoulders', value: 'Head&Shoulders'),
  ];

  static List<ValueItem<String>> skinConcerns = [
    ValueItem(label: 'Акне и высыпания', value: 'Акне и высыпания'),
    ValueItem(label: 'Морщины и линии', value: 'Морщины и линии'),
    ValueItem(label: 'Пигментация', value: 'Пигментация'),
    ValueItem(label: 'Чувствительность', value: 'Чувствительность'),
    ValueItem(label: 'Сухость', value: 'Сухость'),
    ValueItem(label: 'Обезвоженность', value: 'Обезвоженность'),
    ValueItem(label: 'Краснота', value: 'Краснота'),
  ];

  static List<ValueItem<String>> ageGroups = [
    ValueItem(label: 'Подросток', value: 'Подросток'),
    ValueItem(label: 'Молодой(ая)', value: 'Молодой(ая)'),
    ValueItem(label: 'Зрелый(ая)', value: 'Зрелый(ая)'),
    ValueItem(label: 'Предпожилой(ая)', value: 'Предпожилой(ая)'),
    ValueItem(label: 'Пожилой(ая)', value: 'Пожилой(ая)'),
  ];

  static List<ValueItem<String>> productPurposes = [
    ValueItem(label: 'Увлажнение', value: 'Увлажнение'),
    ValueItem(label: 'Питание', value: 'Питание'),
    ValueItem(label: 'Очищение', value: 'Очищение'),
    ValueItem(label: 'Защита', value: 'Защита'),
    ValueItem(label: 'Борьба с акне', value: 'Борьба с акне'),
    ValueItem(label: 'Успокоение', value: 'Успокоение'),
  ];

  static List<ValueItem<String>> skinTypeOptions = [
    ValueItem(label: 'Жирная кожа', value: 'Жирная кожа'),
    ValueItem(label: 'Сухая кожа', value: 'Сухая кожа'),
    ValueItem(label: 'Комбинированная кожа', value: 'Комбинированная кожа'),
    ValueItem(label: 'Нормальная кожа', value: 'Нормальная кожа'),
  ];

  static List<ValueItem<String>> hairTypeOptions = [
    ValueItem(label: 'Жирные волосы', value: 'Жирные волосы'),
    ValueItem(label: 'Сухие волосы', value: 'Сухие волосы'),
    ValueItem(label: 'Нормальные волосы', value: 'Нормальные волосы'),
  ];
}
