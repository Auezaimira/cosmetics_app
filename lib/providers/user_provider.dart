import 'package:flutter/material.dart';

import '../models/recommendations.model.dart';
import '../models/user.model.dart';

class UserProvider with ChangeNotifier {
  User? _user;

  User? get user => _user;

  void setUser(User newUser) {
    _user = newUser;
    notifyListeners();
  }

  List<Recommendations>? _recommendations;

  List<Recommendations>? get recommendations => _recommendations;

  void setRecommendations(List<Recommendations> newRecommendations) {
    _recommendations = newRecommendations;
    notifyListeners();
  }
}
