import 'package:flutter/material.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff154c79),
      body: SafeArea(child: SingleChildScrollView(
         child: 
         Padding(padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
         child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only( top: 30),
              alignment: Alignment.center,
              child: const Text(
                'Register New User',
                style: TextStyle(fontSize: 25, color: Colors.white
                ),
              ),
            ),
            const SizedBox(height: 20),

             TextFormField(
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(),
                hintText: 'Enter your name',
              ),
            ),
            const SizedBox(height: 20),

             TextFormField(
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(),
                hintText: 'Enter your email',
              ),
            ),
            const SizedBox(height: 20),

             TextFormField(
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(),
                hintText: 'Enter your pasword',
              ),
            ),
            const SizedBox(height: 20),

             TextFormField(
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(),
                hintText: 'confirm password',
              ),
            ),
            
          ],
         ),
      ),
      ),
      ),
      
    );
  }
}