import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:rumahsehat_flutter/DTO/GetPasienDTO.dart';
import 'package:rumahsehat_flutter/DTO/SaldoUpdateDTO.dart';

class FormUpdateSaldo extends StatefulWidget {
  final String? username;
  const FormUpdateSaldo({super.key, required this.username});

  @override
  _FormUpdateSaldo createState() => _FormUpdateSaldo(username);
}

class _FormUpdateSaldo extends State<FormUpdateSaldo> {
  final _formKey = GlobalKey<FormState>();

  late GetPasienDTO pasienDetails;

  int? saldo;
  String? username = "";

  _FormUpdateSaldo(String? username) {
    this.username = username;
  }

  // Function to top up saldo as Json
  Future updateSaldo() async {
    print("masuk");
    SaldoUpdateDTO topUp = SaldoUpdateDTO(username, saldo);
    var topUpJson = json.encode(topUp.toJson());
    var response = await http.post(
        Uri.parse('http://localhost:8000/api/v1/pasien/addSaldo'),
        headers: {
          "Accept": "application/json",
          "content-type": "application/json",
        },
        body: topUpJson);
    // print(response.body);
    if (response.statusCode == 200) {
      print("response ok ==============");
      return showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Top Up Successful!'),
              content: const Text('Saldo anda berhasil ditambahkan.'),
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
      print(response.statusCode);
      return showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Update Saldo Failed!'),
              content: const Text('Coba di waktu lain.'),
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
        // future: updateSaldo(),
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
                      'Top Up Saldo',
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
                        onChanged: (String value) => saldo = int.parse(value),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Masukkan jumlah saldo tambahan',
                        ),
                      ),
                    ),
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
                              await updateSaldo();
                              // if (_formKey.currentState!.validate()) {
                              //   postPasien();
                              // }
                            },
                            child: const Text('Submit'),
                          ),
                        ),
                      ],
                    ),
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
