import 'package:flutter/material.dart';
import '../models/car_model.dart';

class CarProvider extends ChangeNotifier {
  // List of cars
  final List<Car> _cars = [
    Car(
      name: 'Proton Saga',
      plateNumber: 'WC 1234',
      imagePath: 'assets/images/proton_saga.png',
    ),
    Car(
      name: 'Honda Civic',
      plateNumber: 'ABC 5678',
      imagePath: 'assets/images/honda_civic.png',
    ),
  ];

  // Controller for the PageView
  final PageController _pageController = PageController();

  // Controller for the text field to edit the car plate
  late TextEditingController _plateController;

  // State variables
  int _currentPage = 0;
  bool _isEditing = false;

  // Getters
  List<Car> get cars => _cars;
  PageController get pageController => _pageController;
  TextEditingController get plateController => _plateController;
  int get currentPage => _currentPage;
  bool get isEditing => _isEditing;

  CarProvider() {
    // Initialize the text controller with the first car's plate number
    _plateController = TextEditingController(text: _cars[0].plateNumber);
    _pageController.addListener(() {
      _currentPage = _pageController.page!.round();
      _plateController.text = _cars[_currentPage].plateNumber;
      _isEditing = false; // Exit edit mode when page changes
      notifyListeners();
    });
  }

  void addCar(String name, String plateNumber, String imagePath) {
    _cars.add(Car(
      name: name,
      plateNumber: plateNumber,
      imagePath: imagePath,
    ));
    // Scroll to the new car after adding it
    _pageController.animateToPage(
      _cars.length - 1,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeIn,
    );
    notifyListeners();
  }

  void toggleEditMode() {
    _isEditing = !_isEditing;
    if (!_isEditing) {
      // Save the new plate number
      _cars[_currentPage].plateNumber = _plateController.text;
    }
    notifyListeners();
  }


  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
    _plateController.dispose();
  }
}