import 'package:flutter/material.dart';

// A simple data model for a car
class Car {
  String name;
  String plateNumber;
  String imagePath;

  Car({required this.name, required this.plateNumber, required this.imagePath});
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // A list of cars to be displayed. This can be fetched from a database or API in a real app.
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
    // Add more cars as needed
  ];

  // Controller for the PageView
  final PageController _pageController = PageController();

  // Controller for the text field to edit the car plate
  late TextEditingController _plateController;

  // State variables
  int _currentPage = 0;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    // Initialize the text controller with the first car's plate number
    _plateController = TextEditingController(text: _cars[0].plateNumber);
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page!.round();
        _plateController.text = _cars[_currentPage].plateNumber;
        _isEditing = false; // Exit edit mode when page changes
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _plateController.dispose();
    super.dispose();
  }

  void _addCar() {
    setState(() {
      _cars.add(
        Car(
          name: 'New Car',
          plateNumber: 'NEW 0000',
          imagePath: 'assets/images/placeholder_car.png', // Placeholder image
        ),
      );
      // Scroll to the new car after adding it
      _pageController.animateToPage(
        _cars.length - 1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    });
  }

  void _toggleEditMode() {
    setState(() {
      _isEditing = !_isEditing;
      if (!_isEditing) {
        // Save the new plate number
        _cars[_currentPage].plateNumber = _plateController.text;
        // Optionally, save to a database here
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Car plate saved!')),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'HomePage',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 20.0),
          child: Column(
            children: [
              // Car section
              SizedBox(
                height: 250, // Height for the PageView
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: _cars.length,
                  itemBuilder: (context, index) {
                    final car = _cars[index];
                    return Container(
                      margin: const EdgeInsets.all(16.0),
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(15.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey,
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                car.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              IconButton(
                                icon: Icon(
                                  _isEditing
                                      ? Icons.save
                                      : Icons.edit_outlined,
                                  color: _isEditing ? Colors.green : null,
                                ),
                                onPressed: _toggleEditMode,
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: _isEditing && _currentPage == index
                                ? TextFormField(
                              controller: _plateController,
                              decoration: const InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.zero,
                                border: InputBorder.none,
                              ),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            )
                                : Text(
                              car.plateNumber,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Expanded(
                            child: Center(
                              child: Image.asset(
                                car.imagePath,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              // Page indicator
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(_cars.length, (index) {
                  return Container(
                    width: 8,
                    height: 8,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      color: _currentPage == index
                          ? Colors.blue
                          : Colors.grey[300],
                      borderRadius: BorderRadius.circular(4),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 16),
              // Add New Car Button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: ElevatedButton(
                  onPressed: _addCar,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                      side: BorderSide(color: Colors.grey.shade300),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add_circle_outline, color: Colors.blue[700]),
                      const SizedBox(width: 8),
                      Text(
                        'Add New Car',
                        style: TextStyle(
                          color: Colors.blue[700],
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // What service we have section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'What service we have',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Table(
                      children: [
                        TableRow(
                          children: [
                            _buildServiceIcon(
                                'Maintenance', Icons.build_outlined),
                            _buildServiceIcon(
                                'Engine', Icons.engineering_outlined),
                            _buildServiceIcon(
                                'Breakdown', Icons.directions_car_filled),
                          ],
                        ),
                        TableRow(
                          children: [
                            _buildServiceIcon(
                                'Inspection', Icons.car_rental_outlined),
                            _buildServiceIcon('Gear', Icons.settings_outlined),
                            _buildServiceIcon(
                                'Service', Icons.handyman_outlined),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    // Make Appointment button
                    Center(
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.yellow[700],
                          padding: const EdgeInsets.symmetric(
                              horizontal: 60, vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Text(
                          'Make Appointment',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    // Service Man section
                    const Text(
                      'Service Man',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildServiceMan('Chee Wee', 'assets/images/chee_wee.png'),
                        _buildServiceMan('Yi Yon', 'assets/images/yi_yon.png'),
                        _buildServiceMan('Ka Hong', 'assets/images/ka_hong.png'),
                        _buildServiceMan('Min Zhe', 'assets/images/min_zhe.png'),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: '',
          ),
        ],
      ),
    );
  }

  Widget _buildServiceIcon(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Icon(icon, size: 30, color: Colors.blue.shade700),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(fontSize: 12),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildServiceMan(String name, String imagePath) {
    return Column(
      children: [
        CircleAvatar(
          radius: 35,
          backgroundImage: AssetImage(imagePath),
        ),
        const SizedBox(height: 8),
        Text(
          name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        Row(
          children: List.generate(
            5,
                (index) => Icon(
              Icons.star,
              color: Colors.yellow[700],
              size: 12,
            ),
          ),
        ),
      ],
    );
  }
}