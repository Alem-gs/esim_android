import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter_esim/flutter_esim.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isSupportESim = false;
  final _flutterEsimPlugin = FlutterEsim();

  //LPA or activation code
  final String _activationCode =
      "LPA:1\$consumer.e-sim.global\$TN20240704143140B8803D46";

  @override
  void initState() {
    super.initState();
    initPlatformState();
    _flutterEsimPlugin.onEvent.listen((event) {
      print(event);
    });
  }

  //platform messages are asynchronous, so we initialize in an async method
  Future<void> initPlatformState() async {
    bool isSupportESim;
    //platform messages may fail, so we use a try/catch PlatformException
    //we also handle the message potentially returning null
    try {
      isSupportESim = await _flutterEsimPlugin.isSupportESim(["test"]);
    } on PlatformException {
      isSupportESim = false;
    }

    //If the widget was removed from the tree while the asynchronous platform
    //message in flight, we want to discard the reply rather than calling
    //setState to update our non-existent appearance
    if (!mounted) return;
    setState(() {
      _isSupportESim = isSupportESim;
    });
  }

  //Method to install eSIM using the placeholder activation code
  Future<void> installEsim() async {
    // try {
    //   print("it has reached here");
    //   await _flutterEsimPlugin.installEsimProfile(_placeholderActivationCode);
    //   print("eSIM installation initiated with placeholder code");
    // } catch (e, stackTrace) {
    //   print("Error during eSIM installation: $e");
    //   print("Stack trace: $stackTrace");
    // }
    try {
      print("Attempting to install eSIM...");
      var result = await _flutterEsimPlugin.installEsimProfile(_activationCode);
      print("Result of eSIM installation: $result");
      if (result == null || result == false) {
        print("eSIM installation failed (no exception thrown).");
      }
    } catch (e, stackTrace) {
      print("Caught an exception during eSIM installation: $e");
      print("Stack trace: $stackTrace");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Center(
            child: const Text('eSIM Installation Test'),
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('isSupportEsim: $_isSupportESim\n'),
              ElevatedButton(
                onPressed: () {
                  //print("Install Esim button pressed");
                  installEsim();
                },
                child: const Text('Install Esim'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
