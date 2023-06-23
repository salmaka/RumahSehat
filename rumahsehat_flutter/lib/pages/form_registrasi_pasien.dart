import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:rumahsehat_flutter/DTO/GetPasienDTO.dart';

class FormRegistrasiPasien extends StatefulWidget {
  const FormRegistrasiPasien({super.key});

  @override
  _FormRegistrasiPasien createState() => _FormRegistrasiPasien();
}

class _FormRegistrasiPasien extends State<FormRegistrasiPasien> {
  final _formKey = GlobalKey<FormState>();
  String? nama;
  String? username;
  String? password = "";
  String? email;
  int? saldo;
  int? umur;

  // Function to post Appointment as Json
  Future postPasien() async {
    GetPasienDTO pasien = GetPasienDTO(
        nama, username, password, email, saldo, umur); // TODO: BINGUNG INI APA
    var pasienJson = json.encode(pasien.toJson());
    var response = await http.post(
        Uri.parse('http://localhost:8000/api/v1/pasien/add'),
        headers: {
          "Accept": "application/json",
          "content-type": "application/json"
        },
        body: pasienJson);
    if (response.statusCode == 200) {
      return showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Pasien Created!'),
              content: const Text('Registrasi akun pasien berhasil dilakukan'),
              actions: <Widget>[
                TextButton(
                  child: const Text('Ok'),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          });
    } else {
      return showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Create Pasien Failed!'),
              content: const Text('Oh no! Coba buat di waktu yang lain...'),
              actions: <Widget>[
                TextButton(
                  child: const Text('Ok'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rumah Sehat'),
        centerTitle: true,
      ),
      body: FutureBuilder(
        builder: (context, snapshot) {
          return Form(
            key: _formKey,
            child: SafeArea(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 36),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    const Text(
                      'Registrasi Pasien',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                      child: TextField(
                        onChanged: (String value) => nama = value,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Nama *',
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                      child: TextField(
                        onChanged: (String value) => username = value,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Username *',
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                      child: TextField(
                        onChanged: (String value) => password = value,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Password *',
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                      child: TextField(
                        onChanged: (String value) => email = value,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'E-mail *',
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                      child: TextField(
                        onChanged: (String value) => umur = int.parse(value),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Umur *',
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                            padding: const EdgeInsets.only(top: 12),
                            child: OutlinedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('Cancel'),
                            )),
                        const SizedBox(
                          width: 12,
                        ),
                        Container(
                          padding: const EdgeInsets.only(top: 12),
                          child: ElevatedButton(
                            onPressed: () async {
                              await postPasien();
                              // if (_formKey.currentState!.validate()) {
                              //   postPasien();
                              // }
                            },
                            child: const Text('Submit'),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
