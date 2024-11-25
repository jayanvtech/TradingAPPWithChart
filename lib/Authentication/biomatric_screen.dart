import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter/services.dart';
import 'package:tradingapp/Utils/Bottom_nav_bar_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: PinAuthenticationScreen(),
    );
  }
}

class PinAuthenticationScreen extends StatefulWidget {
  @override
  _PinAuthenticationScreenState createState() =>
      _PinAuthenticationScreenState();
}

class _PinAuthenticationScreenState extends State<PinAuthenticationScreen> {
  final LocalAuthentication _localAuth = LocalAuthentication();
  bool _canCheckBiometrics = false;
  bool _isBiometricSupported = false;
  List<BiometricType> _biometricTypes = [];
  String _pin = "";
  TextEditingController _pinController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _checkBiometricSupport();
  }

  Future<void> _checkBiometricSupport() async {
    try {
      _canCheckBiometrics = await _localAuth.canCheckBiometrics;
      _isBiometricSupported = await _localAuth.isDeviceSupported();
      _biometricTypes = await _localAuth.getAvailableBiometrics();
    } on PlatformException catch (e) {
      print('Error checking biometrics: $e');
    }
    setState(() {});
  }

  Future<void> _authenticateWithBiometrics() async {
    try {
      bool authenticated = false;

      // Try fingerprint or FaceID based on available biometrics
      authenticated = await _localAuth.authenticate(
        localizedReason: 'Please authenticate to proceed',


      );

      if (authenticated) {
        // Biometrics successful, continue with  app flow
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => MainScreen()));
      } else {
        // Biometrics failed, show PIN input
        _showPinInput();
      }
    } catch (e) {
      print("Error during biometric authentication: $e");
      _showPinInput();
    }
  }

  // Show PIN input dialog
  void _showPinInput() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Enter your PIN'),
          content: TextField(
            controller: _pinController,
            keyboardType: TextInputType.number,
            obscureText: true,
            decoration: InputDecoration(hintText: 'PIN'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (_pinController.text.isNotEmpty) {
                  _pin = _pinController.text;
                  Navigator.pop(context);
                  // Proceed with the PIN (for now, print it)
                  print('Entered PIN: $_pin');
                  Navigator.pushReplacement(
                      context, MaterialPageRoute(builder: (_) => MainScreen()));
                }
              },
              child: Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Authentication")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_canCheckBiometrics)
              ElevatedButton(
                onPressed: _authenticateWithBiometrics,
                child: Text('Authenticate with Biometrics'),
              ),
            if (_biometricTypes.isEmpty)
              ElevatedButton(
                onPressed: _showPinInput,
                child: Text('Enter PIN Manually'),
              ),
          ],
        ),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      body: Center(child: Text('Welcome to the app!')),
    );
  }
}
