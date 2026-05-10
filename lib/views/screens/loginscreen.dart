import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx/views/screens/register.dart';

class loginscreen extends StatelessWidget {
  const loginscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff154c79),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                alignment: Alignment.center,
                child: Image.asset('assets/images/canvanLogo.png', 
                  height: 230,
                  width: 180,
                ),
              ),
                  const SizedBox(height: 40),
                  const Text('Username', 
                            style: TextStyle(color: Colors.white, fontSize: 20, 
                            fontWeight: FontWeight.w500),),
                  const SizedBox(height: 15),
                  const TextField(
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(),
                      hintText: 'Enter your username',
                    ),
                  ),


                  const SizedBox(height: 20),
                  const Text('Password', 
                            style: TextStyle(color: Colors.white, fontSize: 20, 
                            fontWeight: FontWeight.w500),),
                  const SizedBox(height: 15),
                  const TextField(
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(),
                      hintText: 'Enter your password',
                    ),
                  ),

                  const SizedBox(height: 40),
                  Center(
                    child: Container(
                   decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: Colors.white,
                   ),
                   height: 45,
                   width: 90,

                   child: const Center(
                    child: const Text('Login', style: TextStyle(fontSize: 20,
                   color: Color(0xff154c79),
                   ),
                   ),
                   )
                  ),
                  ),
                  const SizedBox(height: 20),

                  Row(mainAxisAlignment: MainAxisAlignment.center,
                   children: [
                    const Text('Don\'t have an account?', 
                    style: TextStyle(color: Colors.white, 
                    fontSize: 16,
                    ),
                    ),

                    InkWell(
                      onTap: () {
                        Get.to(() => RegisterScreen());
                      },
                      child: const Text(' Register', 
                    style: TextStyle(color: Colors.blue, 
                    fontSize: 16,
                    ),
                    ),)
                   ],
                  )
            ],
          ),

      ),
      ),
      ),
    );
  }
}