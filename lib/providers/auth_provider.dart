import 'package:flutter/material.dart';
import '../models/user_model.dart';

class AuthProvider extends ChangeNotifier {
  UserModel? _currentUser;
  bool _isLoading = false;
  bool _isLoggedIn = false;
  String? _error;

  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  bool get isLoggedIn => _isLoggedIn;
  String? get error => _error;

  // Demo: simulate a logged in user
  void setDemoUser() {
    _currentUser = UserModel(
      id: 'demo_user',
      name: 'Alex Johnson',
      email: 'alex@petner.com',
      phone: '+92 300 1234567',
      photoUrl: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=200',
      bio: 'Dog lover and outdoor enthusiast 🐕 Proud owner of Bella!',
      location: 'Lahore, Pakistan',
      role: 'pet_owner',
      petIds: ['1'],
      matchIds: ['m1'],
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
      isOnline: true,
      isVerified: true,
    );
    _isLoggedIn = true;
    notifyListeners();
  }

  Future<void> loginWithEmail(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    await Future.delayed(const Duration(seconds: 1));
    setDemoUser();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> loginWithGoogle() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 800));
    setDemoUser();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> signUpWithEmail(String name, String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    await Future.delayed(const Duration(seconds: 1));
    _currentUser = UserModel(
      id: 'new_user_${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      email: email,
      createdAt: DateTime.now(),
    );
    _isLoggedIn = true;
    _isLoading = false;
    notifyListeners();
  }

  void logout() {
    _currentUser = null;
    _isLoggedIn = false;
    notifyListeners();
  }

  void updateProfile({String? name, String? bio, String? location, String? photoUrl}) {
    if (_currentUser == null) return;
    _currentUser = _currentUser!.copyWith(
      name: name,
      bio: bio,
      location: location,
      photoUrl: photoUrl,
    );
    notifyListeners();
  }
}
