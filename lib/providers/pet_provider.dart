import 'package:flutter/material.dart';
import '../models/pet_model.dart';
import '../models/match_model.dart';

class PetProvider extends ChangeNotifier {
  List<PetModel> _discoverPets = [];
  List<PetModel> _myPets = [];
  List<MatchWithPets> _matches = [];
  bool _isLoading = false;
  int _currentSwipeIndex = 0;

  List<PetModel> get discoverPets => _discoverPets;
  List<PetModel> get myPets => _myPets;
  List<MatchWithPets> get matches => _matches;
  bool get isLoading => _isLoading;
  int get currentSwipeIndex => _currentSwipeIndex;
  bool get hasMyPet => _myPets.isNotEmpty;

  void loadSampleData() {
    _discoverPets = PetSampleData.samples;
    _myPets = [PetSampleData.samples.first];
    _matches = MatchSampleData.samples;
    notifyListeners();
  }

  void swipeRight(PetModel pet) {
    // Like action
    _currentSwipeIndex++;
    notifyListeners();
  }

  void swipeLeft(PetModel pet) {
    // Pass action
    _currentSwipeIndex++;
    notifyListeners();
  }

  void resetSwipes() {
    _currentSwipeIndex = 0;
    _discoverPets = PetSampleData.samples;
    notifyListeners();
  }

  void addPet(PetModel pet) {
    _myPets.add(pet);
    notifyListeners();
  }

  void updatePet(PetModel pet) {
    final idx = _myPets.indexWhere((p) => p.id == pet.id);
    if (idx != -1) {
      _myPets[idx] = pet;
      notifyListeners();
    }
  }
}
