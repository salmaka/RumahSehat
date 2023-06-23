import 'dart:convert';
import 'package:flutter_session/flutter_session.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'form_registrasi_pasien.dart';
import 'home_page.dart';

class AuthPage extends StatefulWidget {
  late final bool invalid;
  AuthPage({required this.invalid});

  @override
  _AuthPage createState() => _AuthPage(invalid: invalid);
}

class _AuthPage extends State<AuthPage> {
  late final bool invalid;
  _AuthPage({required this.invalid});

  final _formKey = GlobalKey<FormState>();

  // Form values
  String email = "";
  String password = "";

  // Function to post login request
  Future loginRequest(
      BuildContext context, String email, String password) async {
    var authJson =
        jsonEncode(<String, String>{"password": password, "email": email});
    var response =
        await http.post(Uri.parse('http://192.168.42.12:8080/api/v1/login'),
            headers: {
              "Accept": "application/json",
              "content-type": "application/json",
              "Access-Control-Allow-Origin": "*",
              "Access-Control-Allow-Method": "POST, GET, PUT, DELETE"
            },
            body: authJson);
    var token = response.body;
    print(response.statusCode); // TODO:
    print(token); // TODO: debug

    if (response.statusCode == 200) {
      print("user found"); // TODO: debug
      // get auth
      var auth = await http
          .get(Uri.parse('http://192.168.42.12:8080/api/v1/info'), headers: {
        "Access-Control-Allow-Origin": "*",
        "Access-Control-Allow-Method": "POST, GET, PUT, DELETE",
        "Authorization": "Bearer $token"
      });
      var jsonAuth = jsonDecode(auth.body);

      if (jsonAuth["role"] == "PASIEN") {
        await FlutterSession().set("token", token);
        print("pasien bisa login"); // TODO: debug
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return HomePage();
        }));
      } else {
        print("bukan pasien"); // TODO: debug
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return AuthPage(invalid: true);
        }));
      }
    } else {
      print("user not found"); // TODO: debug
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return AuthPage(invalid: true);
      }));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rumah Sehat'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: SingleChildScrollView(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 100, horizontal: 32),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                  side: const BorderSide(
                    color: Colors.black12,
                  ),
                ),
                elevation: 20,
                shadowColor: Colors.black26,
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 20, right: 20, bottom: 20, top: 28),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        const Text(
                          'Login Rumah Sehat',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                        TextFormField(
                          decoration: const InputDecoration(
                              labelText: 'Email',
                              border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.green),
                              )),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Masukkan email Anda!';
                            }
                            return null;
                          },
                          onChanged: (String value) {
                            email = value;
                          },
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        TextFormField(
                          decoration: const InputDecoration(
                              labelText: 'Password',
                              border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.green),
                              )),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Masukkan password Anda!';
                            }
                            return null;
                          },
                          onChanged: (String value) {
                            password = value;
                          },
                          obscureText: true,
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        SizedBox(
                          height: invalid ? 20 : 0,
                          child: Text(
                            invalid
                                ? 'Periksa lagi email dan password Anda!'
                                : '',
                            style: const TextStyle(
                              color: Colors.red,
                            ),
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.only(top: 8),
                          child: ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                print("email: $email"); // TODO: debug
                                print("password: $password"); // TODO: debug
                                loginRequest(context, email, password);
                              }
                            },
                            child: const Text('Login'),
                          ),
                        ),
                        SizedBox(
                            width: double.infinity,
                            child: OutlinedButton(
                              onPressed: () {
                                print("Push ke regis"); // TODO: debug
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return const FormRegistrasiPasien();
                                }));
                              },
                              child: const Text('Registrasi Pasien'),
                            )),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
