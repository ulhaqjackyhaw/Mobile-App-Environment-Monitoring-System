import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'firebase_options.dart'; // Import the generated firebase_options.dart

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, // Initialize Firebase with options
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Firebase Real-Time',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: GoogleFonts.poppinsTextTheme(),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        scaffoldBackgroundColor: Colors.blue.shade50, // Light background for the app
      ),
      debugShowCheckedModeBanner: false, // Remove debug banner
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref(); // Reference to Firebase Database
  late DatabaseReference _temperatureRef;
  late DatabaseReference _humidityRef;
  late DatabaseReference _ledControlRef;

  String _temperature = "Loading...";
  String _humidity = "Loading...";
  bool _ledState = false;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    // Set references for temperature, humidity, and LED in Firebase
    _temperatureRef = _dbRef.child("iot/temperature");
    _humidityRef = _dbRef.child("iot/humidity");
    _ledControlRef = _dbRef.child("iot/led");

    // Listen for changes in the temperature value in real-time
    _temperatureRef.onValue.listen((event) {
      setState(() {
        _temperature = event.snapshot.value.toString();
      });
    });

    // Listen for changes in the humidity value in real-time
    _humidityRef.onValue.listen((event) {
      setState(() {
        _humidity = event.snapshot.value.toString();
      });
    });

    // Listen for changes in the LED control in real-time
    _ledControlRef.onValue.listen((event) {
      setState(() {
        _ledState = event.snapshot.value == 1;
      });
    });

    // Initialize animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade50, Colors.blue.shade100],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Real-Time Monitoring",
                  style: GoogleFonts.poppins(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade900,
                  ),
                ),
                SizedBox(height: 30),
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: _buildCard(
                    title: "Temperature",
                    value: "$_temperature°C",
                    icon: Icons.thermostat,
                    gradient: LinearGradient(
                      colors: [Colors.orange.shade300, Colors.orange.shade500],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: _buildCard(
                    title: "Humidity",
                    value: "$_humidity%",
                    icon: Icons.water_drop,
                    gradient: LinearGradient(
                      colors: [Colors.blue.shade300, Colors.blue.shade500],
                    ),
                  ),
                ),
                SizedBox(height: 40),
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: _buildLedControlCard(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCard({required String title, required String value, required IconData icon, required LinearGradient gradient}) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 15,
            offset: Offset(4, 4),
          ),
          BoxShadow(
            color: Colors.white.withOpacity(0.2),
            blurRadius: 15,
            offset: Offset(-4, -4),
          ),
        ],
      ),
      child: Row(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.3),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white, size: 35),
          ),
          SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  value,
                  style: GoogleFonts.poppins(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLedControlCard() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.green.shade300, Colors.green.shade500],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 15,
            offset: Offset(4, 4),
          ),
          BoxShadow(
            color: Colors.white.withOpacity(0.2),
            blurRadius: 15,
            offset: Offset(-4, -4),
          ),
        ],
      ),
      child: Row(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.3),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.lightbulb, color: Colors.white, size: 35),
          ),
          SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Control LED",
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _ledState ? "LED ON" : "LED OFF",
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    AnimatedSwitcher(
                      duration: Duration(milliseconds: 300),
                      child: Switch(
                        key: ValueKey<bool>(_ledState),
                        value: _ledState,
                        onChanged: (bool value) {
                          setState(() {
                            _ledState = value;
                          });
                          _ledControlRef.set(_ledState ? 1 : 0); // Update LED state in Firebase
                        },
                        activeColor: Colors.white,
                        activeTrackColor: Colors.green.shade700,
                        inactiveThumbColor: Colors.white,
                        inactiveTrackColor: Colors.grey.shade400,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
