import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:rumahsehat_flutter/DTO/GetPasienDTO.dart';
import 'package:rumahsehat_flutter/pages/form_update_saldo.dart';
import 'package:http/http.dart' as http;

class ViewUserProfile extends StatelessWidget {
  late final String token;
  late final String kodePasien;
  ViewUserProfile({required this.token});

  late GetPasienDTO pasienDetails;

  // Function to get appointment details
  Future GetUserProfile(String kodePasien) async {
    var auth =
        await http.get(Uri.parse('http://10.0.2.2:8080/api/v1/info'), headers: {
      "Access-Control-Allow-Origin": "*",
      "Access-Control-Allow-Method": "POST, GET, PUT, DELETE",
      "Authorization": "Bearer $token"
    });
    var jsonAuth = jsonDecode(auth.body);
    String pasienRole = jsonAuth["role"];
    kodePasien = jsonAuth["id"];

    if (pasienRole == "PASIEN") {
      var response = await http.get(
          Uri.parse('http://localhost:8000/api/v1/pasien/$kodePasien'),
          headers: {
            "Access-Control-Allow-Origin": "*",
            "Access-Control-Allow-Method": "POST, GET, PUT, DELETE",
            "Authorization": "Bearer $token"
          });
      var jsonData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        pasienDetails = GetPasienDTO(
          jsonData["nama"],
          jsonData["username"],
          jsonData["password"],
          jsonData["email"],
          jsonData["saldo"],
          jsonData["umur"],
        );
        return pasienDetails;
      } else {
        return false;
      }
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
        future: GetUserProfile(kodePasien),
        builder: (context, snapshot) {
          if (snapshot.data == false) {
            return SafeArea(
                child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 36),
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text(
                      'Not Found: 404',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      'Ada kesalahan dalam fetch API.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    Container(
                        padding: const EdgeInsets.only(top: 12),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('Back to Home'),
                        )),
                  ],
                ),
              ),
            ));
          } else if (snapshot.data == null) {
            return SafeArea(
                child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 36),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: const <Widget>[
                  Text(
                    'Profile User',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),
                  LinearProgressIndicator(),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Mencari data user.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ));
          } else {
            return SafeArea(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                child: SizedBox(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      const Text(
                        'Profile User',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      SizedBox(
                        width: double.infinity,
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
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  'Nama: ${pasienDetails.nama}',
                                  style: const TextStyle(fontSize: 16),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                Text(
                                  'Username: ${pasienDetails.username}',
                                  style: const TextStyle(fontSize: 16),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                // Text(
                                //   'Password: ${pasienDetails.password}',
                                //   style: const TextStyle(fontSize: 16),
                                // ),
                                // const SizedBox(
                                //   height: 8,
                                // ),
                                Text(
                                  'E-mail: ${pasienDetails.email}',
                                  style: const TextStyle(fontSize: 16),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                Text(
                                  'Saldo: ${pasienDetails.saldo}',
                                  style: const TextStyle(fontSize: 16),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                // Text(
                                //   'Umur: ${pasienDetails.umur}',
                                //   style: const TextStyle(fontSize: 16),
                                // ),
                                // const SizedBox(
                                //   height: 8,
                                // ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Container(
                                padding: const EdgeInsets.only(top: 12),
                                child: OutlinedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text('Back'),
                                )),
                          ),
                          Expanded(
                            child:
                                ButtonTopUp(username: pasienDetails.username),
                          ),
                          const SizedBox(
                            width: 12,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}

class ButtonTopUp extends StatefulWidget {
  late final String? username;
  ButtonTopUp({required this.username});

  _ButtonTopUp createState() => _ButtonTopUp(username: username);
}

class _ButtonTopUp extends State<ButtonTopUp> {
  late final String? username;
  _ButtonTopUp({required this.username});

  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.only(top: 12),
        child: ElevatedButton(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return FormUpdateSaldo(username: username);
            }));
          }, // TODO: navigate to detail resep
          child: const Text('Top Up Saldo'),
        ));
  }
}
