import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:rumahsehat_flutter/DTO/GetDetailAppointmentDTO.dart';
import 'package:rumahsehat_flutter/pages/detail_resep.dart';

import 'package:http/http.dart' as http;

class ViewAppointment extends StatelessWidget {
  late final String token;
  late final String kodeApt;
  ViewAppointment({required this.token, required this.kodeApt});

  late GetDetailAppointmentDTO aptDetails;

  // Function to get appointment details
  Future getDetailAppointment(String kodeApt) async {
    // get auth
    var auth = await http
        .get(Uri.parse('http://192.168.42.12:8080/api/v1/info'), headers: {
      "Access-Control-Allow-Origin": "*",
      "Access-Control-Allow-Method": "POST, GET, PUT, DELETE",
      "Authorization": "Bearer $token"
    });
    var jsonAuth = jsonDecode(auth.body);
    String pasienRole = jsonAuth["role"];
    print("role: " + pasienRole); // TODO: debug

    if (pasienRole == "PASIEN") {
      // get response
      var response = await http.get(
          Uri.parse(
              'http://192.168.42.12:8080/api/v1/appointment/detail/$kodeApt'),
          headers: {
            "Access-Control-Allow-Origin": "*",
            "Access-Control-Allow-Method": "POST, GET, PUT, DELETE"
          });
      var jsonData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        var raw = jsonData["waktuAwal"].split('T');
        String idResep = "NO RESEP";
        if (jsonData["resep"] != null) {
          idResep = jsonData["resep"]["id"].toString();
        }
        aptDetails = GetDetailAppointmentDTO(
            jsonData["kode"],
            jsonData["isDone"],
            raw[0],
            raw[1],
            jsonData["dokter"]["nama"],
            idResep);
        return aptDetails;
      } else {
        return false;
      }
    } else {
      // not pasien
      return false;
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
        future: getDetailAppointment(kodeApt),
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
                    'Detail Appointment',
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
                    'Membaca detail appointment Anda.',
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
                        'Detail Appointment',
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
                                  'Kode: ${aptDetails.kode}',
                                  style: const TextStyle(fontSize: 16),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                Text(
                                  'Dokter: ${aptDetails.namaDokter}',
                                  style: const TextStyle(fontSize: 16),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                Text(
                                  'Tanggal: ${aptDetails.tanggal}',
                                  style: const TextStyle(fontSize: 16),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                Text(
                                  'Jam: ${aptDetails.jam}',
                                  style: const TextStyle(fontSize: 16),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                Text(
                                  aptDetails.isDone
                                      ? 'Status: Is Done'
                                      : 'Status: Is Not Done',
                                  style: const TextStyle(fontSize: 16),
                                ),
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
                          const SizedBox(
                            width: 12,
                          ),
                          Expanded(
                            child: Container(
                                padding: const EdgeInsets.only(top: 12),
                                child: OutlinedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return ViewAppointment(
                                        token: token,
                                        kodeApt: aptDetails.kode,
                                      );
                                    }));
                                  },
                                  child: const Text('Reload'),
                                )),
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child:
                                ButtonLihatResep(idResep: aptDetails.idResep, token: token),
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

class ButtonLihatResep extends StatefulWidget {
  late final String idResep;
  late final String token;
  ButtonLihatResep({required this.idResep, required this.token});

  _ButtonLihatResep createState() => _ButtonLihatResep(idResep: idResep, token: token);
}

class _ButtonLihatResep extends State<ButtonLihatResep> {
  late final String idResep;
  late final String token;
  _ButtonLihatResep({required this.idResep, required this.token});

  Widget build(BuildContext context) {
    if (idResep == "NO RESEP") {
      return Container(
          padding: const EdgeInsets.only(top: 12),
          child: const ElevatedButton(
            onPressed: null,
            child: Text('Tidak Ada Resep'),
          ));
    } else {
      return Container(
          padding: const EdgeInsets.only(top: 12),
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return ViewDetailResep(token: token, idResep: idResep);
              }));
            }, // TODO: navigate to detail resep
            child: const Text('Lihat Resep'),
          ));
    }
  }
}
