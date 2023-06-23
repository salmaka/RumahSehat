import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:rumahsehat_flutter/DTO/GetDetailResepDTO.dart';

import 'package:http/http.dart' as http;
import 'package:rumahsehat_flutter/pages/view_appointment.dart';

class ViewDetailResep extends StatelessWidget {
  late final String token;
  late final String idResep;
  ViewDetailResep({required this.token, required this.idResep});

  late GetDetailResepDTO resepDetails;

  // func to get resep detail
  Future getDetailResep(String idResep) async {
    // get auth
    var auth = await http
        .get(Uri.parse('http://192.168.42.12:8080/api/v1/info'), headers: {
      "Access-Control-Allow-Origin": "*",
      "Access-Control-Allow-Method": "POST, GET, PUT, DELETE",
      "Authorization": "Bearer $token"
    });
    var jsonAuth = jsonDecode(auth.body);
    String pasienRole = jsonAuth["role"];

    if (pasienRole == "PASIEN") {
      var response = await http.get(
          Uri.parse(
              'http://192.168.42.12:8080/api/v1/resep/$idResep'), // harusnya $idResep, ini masih hardcode
          headers: {
            "Access-Control-Allow-Origin": "*",
            "Access-Control-Allow-Method": "POST, GET, PUT, DELETE"
          });
      var jsonData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        String id = jsonData["id"].toString();
        resepDetails = GetDetailResepDTO(
            id,
            jsonData["namaDokter"],
            jsonData["namaPasien"],
            jsonData["statusResep"],
            jsonData["namaApoteker"],
            jsonData["listObat"]);
        return resepDetails;
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
          resizeToAvoidBottomInset: false,
          body: SingleChildScrollView(
            child: FutureBuilder(
              future: getDetailResep(idResep), //idresep masih hardcode
              builder: (context, snapshot) {
                if (snapshot.data == false) {
                  return SafeArea(
                      child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 36),
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
                            ),
                          )
                        ],
                      ),
                    ),
                  ));
                } else if (snapshot.data == null) {
                  return SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 36),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: const <Widget>[
                          Text(
                            'Detail Resep',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 20),
                          LinearProgressIndicator(),
                          SizedBox(height: 20),
                          Text(
                            'Membaca detail resep Anda.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                } else {
                  return SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 24, horizontal: 16),
                      child: SizedBox(
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            const Text(
                              'Detail Resep',
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        'Id: ${resepDetails.id}',
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      Text(
                                        'Dokter: ${resepDetails.namaDokter}',
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      Text(
                                        'Pasien: ${resepDetails.namaPasien}',
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      Text(
                                        'Status: ${resepDetails.statusResep}',
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      Text(
                                        'Nama Apoteker: ${resepDetails.namaApoteker}',
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      DataTable(
                                          columns: [
                                            DataColumn(
                                                label: Text("Nama Obat",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold))),
                                            DataColumn(
                                                label: Text("Jumlah",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold))),
                                          ],
                                          rows: resepDetails.listObat
                                              .map(
                                                  (listObat) => DataRow(cells: [
                                                        DataCell(Text(
                                                            "${listObat['namaObat']}")),
                                                        DataCell(Text(
                                                            "${listObat['kuantitas']}")),
                                                      ]))
                                              .toList())
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
                                              MaterialPageRoute(
                                                  builder: (context) {
                                            return ViewDetailResep(
                                                token: token,
                                                idResep: resepDetails.id);
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
                    ),
                  );
                }
              },
            ),
          ));
    }
  }
