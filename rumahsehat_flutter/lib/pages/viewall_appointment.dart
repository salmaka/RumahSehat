import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rumahsehat_flutter/pages/view_appointment.dart';

import '../DTO/GetAppointmentDTO.dart';

class ViewAllAppointment extends StatelessWidget {
  late final String token;
  ViewAllAppointment({required this.token});
  List<GetAppointmentDTO> listApt = [];

  // Function to get list of Appointment
  Future getAppointment() async {
    // get auth
    var auth = await http.get(
        Uri.parse('http://192.168.42.12:8080/api/v1/info'),
        headers: {
          "Access-Control-Allow-Origin": "*",
          "Access-Control-Allow-Method": "POST, GET, PUT, DELETE",
          "Authorization": "Bearer $token"
        }
    );
    var jsonAuth = jsonDecode(auth.body);
    String pasienId = jsonAuth["id"];
    String pasienRole = jsonAuth["role"];

    if (pasienRole == "PASIEN") {
      // get response
      var response = await http.get(
          Uri.parse('http://192.168.42.12:8080/api/v1/appointment/$pasienId'),
          headers: {
            "Access-Control-Allow-Origin": "*",
            "Access-Control-Allow-Method": "POST, GET, PUT, DELETE"
          });
      var jsonResponse = jsonDecode(response.body);

      listApt = [];

      if (response.statusCode == 200) {
        for (var a in jsonResponse) {
          var raw = a["waktuAwal"].split('T');
          GetAppointmentDTO apt = GetAppointmentDTO(
              a["kode"], a["dokter"]["nama"], raw[0], raw[1], a["isDone"]);
          listApt.add(apt);
        }
        return listApt;
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
        future: getAppointment(),
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
                        )
                      ),
                    ],
                  ),
                ),
              )
            );
          } else if (snapshot.data == null) {
            print("masuk ke loading"); // TODO: debug
            return SafeArea(
                child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 36),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: const <Widget>[
                  Text(
                    'Daftar Appointment',
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
                    'Mencari appointment Anda.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ));
          } else if (snapshot.data.length == 0) {
            return SafeArea(
                child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 36),
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text(
                      'Daftar Appointment',
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
                      'Anda belum memiliki appointment.',
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
          } else {
            return SafeArea(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                child: Column(
                  children: <Widget>[
                    const Text(
                      'Daftar Appointment',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Expanded(
                      child: ListView.separated(
                          itemCount: snapshot.data.length,
                          separatorBuilder: (BuildContext context, int index) =>
                              const SizedBox(
                                height: 12,
                              ),
                          itemBuilder: (context, index) {
                            final GetAppointmentDTO aptNow =
                                snapshot.data[index];
                            return InkWell(
                              onTap: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return ViewAppointment(
                                    token: token,
                                    kodeApt: aptNow.kode
                                  );
                                }));
                              },
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
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            'Appointment ${aptNow.kode}',
                                            style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 12,
                                          ),
                                          Text(
                                            'Dokter: ${aptNow.namaDokter}',
                                            style:
                                                const TextStyle(fontSize: 16),
                                          ),
                                          const SizedBox(
                                            height: 4,
                                          ),
                                          Text(
                                            'Tanggal: ${aptNow.tanggal}',
                                            style:
                                                const TextStyle(fontSize: 16),
                                          ),
                                          const SizedBox(
                                            height: 4,
                                          ),
                                          Text(
                                            'Jam: ${aptNow.jam}',
                                            style:
                                                const TextStyle(fontSize: 16),
                                          ),
                                          const SizedBox(
                                            height: 4,
                                          ),
                                          Text(
                                            aptNow.isDone
                                                ? 'Status: Is Done'
                                                : 'Status: Is Not Done',
                                            style:
                                                const TextStyle(fontSize: 16),
                                          ),
                                        ],
                                      ),
                                      IconButton(
                                        icon: const Icon(
                                            Icons.chevron_right_outlined),
                                        iconSize: 28,
                                        color: Colors.green,
                                        splashColor:
                                            Colors.green.withOpacity(0.3),
                                        onPressed: () {
                                          Navigator.push(context,
                                              MaterialPageRoute(
                                                  builder: (context) {
                                            return ViewAppointment(
                                              token: token,
                                              kodeApt: aptNow.kode,
                                            );
                                          }));
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }),
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
                                    return ViewAllAppointment(token: token,);
                                  }));
                                },
                                child: const Text('Reload'),
                              )),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
