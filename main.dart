import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginSignupScreen(),
      routes: {
        '/signup': (context) => SignupScreen(),
        '/homepage': (context) => HomePage(),
        '/account': (context) => AccountScreen(),
      },
    );
  }
}

class LoginSignupScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Background(),
          Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 32.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      hintText: 'Email',
                      hintStyle: TextStyle(color: Colors.white54),
                      filled: true,
                      fillColor: Colors.white12,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    style: TextStyle(color: Colors.white),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: passwordController,
                    decoration: InputDecoration(
                      hintText: 'Password',
                      hintStyle: TextStyle(color: Colors.white54),
                      filled: true,
                      fillColor: Colors.white12,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    style: TextStyle(color: Colors.white),
                    obscureText: true,
                  ),
                  SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        loginUser(
                          context,
                          emailController.text.trim(),
                          passwordController.text.trim(),
                        );
                      },
                      child: Text('Login'),
                    ),
                  ),
                  SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/signup');
                      },
                      child: Text('Sign Up'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final dobController = TextEditingController();
  final weightController = TextEditingController();
  final heightController = TextEditingController();

  String selectedGender = 'Male';
  String selectedActivityLevel = 'Moderately Active';
  int calculatedAge = 0;

  final List<String> genders = ['Male', 'Female'];
  final List<String> activityLevels = [
    'Sedentary',
    'Lightly Active',
    'Moderately Active',
    'Very Active'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Stack(
        children: [
          Background(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                _buildTextField(firstNameController, 'First Name'),
                SizedBox(height: 16),
                _buildTextField(lastNameController, 'Last Name'),
                SizedBox(height: 16),
                _buildTextField(emailController, 'Email', TextInputType.emailAddress),
                SizedBox(height: 16),
                _buildTextField(passwordController, 'Password', null, true),
                SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: dobController,
                        readOnly: true,
                        decoration: InputDecoration(
                          labelText: 'Date of Birth (MM/DD/YYYY)',
                          labelStyle: TextStyle(color: Colors.white),
                          filled: true,
                          fillColor: Colors.white12,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        style: TextStyle(color: Colors.white),
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime(2000),
                            firstDate: DateTime(1900),
                            lastDate: DateTime.now(),
                          );

                          if (pickedDate != null) {
                            setState(() {
                              dobController.text = "${pickedDate.month}/${pickedDate.day}/${pickedDate.year}";
                              calculatedAge = _calculateAge(pickedDate);
                            });
                          }
                        },
                      ),
                    ),
                    SizedBox(width: 16),
                    Text(
                      "Age: $calculatedAge",
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                _buildTextField(weightController, 'Weight (kg)', TextInputType.number),
                SizedBox(height: 16),
                _buildTextField(heightController, 'Height (cm)', TextInputType.number),
                SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: selectedGender,
                  items: genders.map((String gender) {
                    return DropdownMenuItem<String>(
                      value: gender,
                      child: Text(gender, style: TextStyle(color: Colors.white)),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedGender = newValue!;
                    });
                  },
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white12,
                    labelText: 'Gender',
                    labelStyle: TextStyle(color: Colors.white),
                  ),
                  style: TextStyle(color: Colors.white),
                  dropdownColor: Colors.black,
                ),
                SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: selectedActivityLevel,
                  items: activityLevels.map((String level) {
                    return DropdownMenuItem<String>(
                      value: level,
                      child: Text(level, style: TextStyle(color: Colors.white)),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedActivityLevel = newValue!;
                    });
                  },
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white12,
                    labelText: 'Activity Level',
                    labelStyle: TextStyle(color: Colors.white),
                  ),
                  style: TextStyle(color: Colors.white),
                  dropdownColor: Colors.black,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    signUpUser(
                      context,
                      emailController.text.trim(),
                      passwordController.text.trim(),
                      firstNameController.text.trim(),
                      lastNameController.text.trim(),
                      calculatedAge,
                      double.tryParse(weightController.text.trim()) ?? 0.0,
                      double.tryParse(heightController.text.trim()) ?? 0.0,
                      selectedGender,
                      selectedActivityLevel,
                    );
                  },
                  child: Text('Done'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, [TextInputType? type, bool isPassword = false]) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.white),
        filled: true,
        fillColor: Colors.white12,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
      ),
      style: TextStyle(color: Colors.white),
      keyboardType: type,
      obscureText: isPassword,
    );
  }

  int _calculateAge(DateTime birthDate) {
    DateTime currentDate = DateTime.now();
    int age = currentDate.year - birthDate.year;
    if (currentDate.month < birthDate.month || (currentDate.month == birthDate.month && currentDate.day < birthDate.day)) {
      age--;
    }
    return age;
  }
}

Future<void> signUpUser(
    BuildContext context,
    String email,
    String password,
    String firstName,
    String lastName,
    int age,
    double weight,
    double height,
    String gender,
    String activityLevel,
    ) async {
  try {
    UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    await FirebaseFirestore.instance.collection('users').doc(userCredential.user?.uid).set({
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'age': age,
      'weight': weight,
      'height': height,
      'gender': gender,
      'activityLevel': activityLevel,
    });

    Navigator.pushNamed(context, '/homepage');
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("User registered successfully!")));
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
  }
}

Future<void> loginUser(BuildContext context, String email, String password) async {
  try {
    UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    Navigator.pushNamed(context, '/homepage');
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Logged in successfully!")));
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Login failed: $e")));
  }
}

// New screen for account profile
class AccountScreen extends StatefulWidget {
  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController heightController = TextEditingController();

  User? user;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(user!.uid).get();

      if (userDoc.exists) {
        firstNameController.text = userDoc['firstName'] ?? '';
        lastNameController.text = userDoc['lastName'] ?? '';
        emailController.text = userDoc['email'] ?? '';
        ageController.text = userDoc['age'].toString() ?? '';
        weightController.text = userDoc['weight'].toString() ?? '';
        heightController.text = userDoc['height'].toString() ?? '';
      }
    }

    setState(() {
      isLoading = false;
    });
  }

  Future<void> updateUserData() async {
    if (user != null) {
      await FirebaseFirestore.instance.collection('users').doc(user!.uid).update({
        'firstName': firstNameController.text.trim(),
        'lastName': lastNameController.text.trim(),
        'age': int.tryParse(ageController.text.trim()) ?? 0,
        'weight': double.tryParse(weightController.text.trim()) ?? 0.0,
        'height': double.tryParse(heightController.text.trim()) ?? 0.0,
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Information updated successfully!")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Account Information'),
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildTextField(firstNameController, 'First Name'),
            SizedBox(height: 16),
            _buildTextField(lastNameController, 'Last Name'),
            SizedBox(height: 16),
            _buildTextField(emailController, 'Email', TextInputType.emailAddress),
            SizedBox(height: 16),
            _buildTextField(ageController, 'Age', TextInputType.number),
            SizedBox(height: 16),
            _buildTextField(weightController, 'Weight (kg)', TextInputType.number),
            SizedBox(height: 16),
            _buildTextField(heightController, 'Height (cm)', TextInputType.number),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: updateUserData,
              child: Text('Update Information'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, [TextInputType? type, bool isPassword = false]) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.white),
        filled: true,
        fillColor: Colors.white12,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
      ),
      style: TextStyle(color: Colors.white),
      keyboardType: type,
      obscureText: isPassword,
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double? bmi;
  int waterIntake = 0; // Mock value for water intake in milliliters
  int steps = 0;       // Mock value for steps count
  int calorieLimit = 2000; // Set a daily calorie limit
  int consumedCalories = 0; // Mock consumed calories

  @override
  void initState() {
    super.initState();
    fetchUserDataAndCalculateBMI();
  }

  Future<void> fetchUserDataAndCalculateBMI() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (userDoc.exists) {
        double weight = userDoc['weight'] ?? 0.0; // Weight in kg
        double height = userDoc['height'] ?? 0.0; // Height in cm
        height = height / 100; // Convert to meters
        double calculatedBMI = weight / (height * height);
        setState(() {
          bmi = calculatedBMI;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double calorieProgress = consumedCalories / calorieLimit;

    return Scaffold(
      body: Stack(
        children: [
          Background(),
          Positioned(
            top: 400,
            left: 16,
            right: 16,
            child: Container(
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8),
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 6,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text("Calories Left", style: TextStyle(color: Colors.black, fontSize: 20)),
                  SizedBox(height: 10),
                  CircularProgressIndicator(
                    value: calorieProgress,
                    backgroundColor: Colors.white12,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                    strokeWidth: 8.0,
                  ),
                  SizedBox(height: 10),
                  Text(
                    '${calorieLimit - consumedCalories} cal left',
                    style: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 150,
            left: 16,
            right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildInfoBox('Water Intake', '$waterIntake ml'),
                _buildInfoBox('Steps', '$steps'),
              ],
            ),
          ),
          Positioned(
            bottom: 70,
            left: 16,
            right: 16,
            child: Container(
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8),
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 6,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: bmi == null
                  ? Text(
                'Calculating BMI...',
                style: TextStyle(fontSize: 18, color: Colors.black),
              )
                  : Text(
                'Your BMI: ${bmi!.toStringAsFixed(2)}',
                style: TextStyle(fontSize: 18, color: Colors.black),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 8.0,
        color: Colors.black, // Bar color
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.favorite, color: Colors.red), // Heart icon
              iconSize: 32.0,
              onPressed: () {
                print("Heart button pressed");
              },
            ),
            SizedBox(width: 40),
            IconButton(
              icon: Icon(Icons.account_circle, color: Colors.white), // Account icon
              iconSize: 32.0,
              onPressed: () {
                Navigator.pushNamed(context, '/account'); // Navigate to account screen
              },
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print("Plus button pressed");
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.white.withOpacity(0.8), // Plus button
      ),
    );
  }

  Widget _buildInfoBox(String title, String value) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 4.0),
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.8),
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 6,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
            SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

class Background extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: CustomPaint(
        size: Size(double.infinity, double.infinity),
        painter: XPainter(),
      ),
    );
  }
}

class XPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..strokeWidth = 10;

    canvas.drawLine(Offset(0, 0), Offset(size.width, size.height), paint);
    canvas.drawLine(Offset(size.width, 0), Offset(0, size.height), paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}