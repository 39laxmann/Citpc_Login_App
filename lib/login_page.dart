import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool obscureTEXT = true;
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String loginStatus = '';
  Color statusColor = Colors.transparent;

   @override
  void initState() {
    super.initState();
    loadCredentials();
  }

Future<void> saveCredentials(String username, String password)async{
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('username', username);
    await prefs.setString('password', password);

}Future<void> loadCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    usernameController.text = prefs.getString('username') ?? '';
    passwordController.text = prefs.getString('password') ?? '';
  }

  Future<void> loginUser() async {
    final username = usernameController.text.trim();
    final password = passwordController.text;
    final url = Uri.parse('https://10.100.1.1:8090/httpclient.html');

    if(username.isEmpty || password.isEmpty){
      setState(() {
        loginStatus = "Please enter both username and password.";
        statusColor = Colors.redAccent;
      });
      return;
    }

    setState(() {
      loginStatus = "Logging in ....";
      statusColor = Colors.yellowAccent;
    });

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/x-www-form-urlencoded"},
        body: {
          'mode': '191',
          'username': username,
          'password': password,
          'a': DateTime.now().millisecondsSinceEpoch.toString(),
          'producttype': '0',
        },
      ).timeout(const Duration(seconds: 8));
      if (response.statusCode == 200) {
        setState(() {
          loginStatus = "Login Succesful";
          statusColor = const Color.fromARGB(255, 26, 255, 0);
        });
        debugPrint("Response: ${response.body}");
      } else {
        setState(() {
          loginStatus = "Login failed. ${response.statusCode}";
          statusColor = Colors.redAccent;
        });
      }
      
    }on TimeoutException{
      setState(() {
        loginStatus = "Request timed out. Check your network.";
        statusColor = Colors.redAccent;
      });
    } 
    catch (e) {
      loginStatus = "Error occurred : $e";
      statusColor = Colors.redAccent;
    }
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Login to CITPC Internet",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 31),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          //background content
          Positioned.fill(
            child: Opacity(
              opacity: 0.623,
              child: Image.asset('assets/images/logo.png', fit: BoxFit.cover),
            ),
          ),

          //foreground content
          SingleChildScrollView(
            scrollDirection: Axis.vertical,
            padding: EdgeInsets.only(
              bottom:
                  MediaQuery.of(context).viewInsets.bottom +
                  60, // pushes up when keyboard appears
            ),

            child: Center(
              child: Column(
                children: [
                  const SizedBox(height: 136),
                  Text(
                    "Make sure you are connected to a CITPC Network",

                    style: TextStyle(
                      backgroundColor: Colors.black12,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 30),

                  SizedBox(
                    width: 350,
                    child: Column(
                      children: [
                        const SizedBox(height: 50),
                        Text(
                          "Username",
                          style: TextStyle(
                            fontSize: 26,
                            color: const Color.fromARGB(255, 255, 255, 255),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          style: TextStyle(fontSize: 18),
                          controller: usernameController,
                          decoration: InputDecoration(
                            hintText: "eg:080bei021",
                            filled: true,
                            fillColor: Color.fromRGBO(72, 72, 72, 0.87),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(11),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(11),
                              borderSide: BorderSide(
                                color: Colors.blue,
                                width: 1.09,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 18),
                        Text(
                          "Password",
                          style: TextStyle(
                            fontSize: 26,
                            color: const Color.fromARGB(255, 255, 255, 255),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          obscureText: obscureTEXT,
                          style: TextStyle(fontSize: 18),
                          controller: passwordController,
                          decoration: InputDecoration(
                            hintText: "xxxx-xxxx",
                            filled: true,
                            fillColor: Color.fromRGBO(72, 72, 72, 0.87),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(11),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(11),
                              borderSide: BorderSide(
                                color: Colors.blue,
                                width: 1.09,
                              ),
                            ),
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  obscureTEXT = !obscureTEXT;
                                });
                              },
                              icon: Icon(
                                obscureTEXT
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 37),
                  SizedBox(
                    width: 350,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: () {
                        String username = usernameController.text;
                        String password = passwordController.text;

                        debugPrint("Username : $username");
                        debugPrint("Password : $password");
                        debugPrint("Login button pressed");
                        loginUser();
                      },
                      style: ButtonStyle(
                        shape: WidgetStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(11),
                          ),
                        ),
                        backgroundColor: WidgetStatePropertyAll(
                          Color.fromRGBO(23, 165, 23, 0.87),
                        ),
                      ),
                      child: Text(
                        "Login",
                        style: TextStyle(
                          fontSize: 19,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    loginStatus,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: statusColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          "Developed by ©080BEI",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 13.7,
            fontWeight: FontWeight.bold,
            wordSpacing: 7,
            letterSpacing: 2,
          ),
        ),
      ),
    );
  }
}
