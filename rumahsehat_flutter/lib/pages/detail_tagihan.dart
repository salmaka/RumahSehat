import 'package:flutter/material.dart';
import 'package:rumahsehat_flutter/DTO/TagihanDTO.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:rumahsehat_flutter/pages/konfirmasi_pembayaran.dart';

class DetailTagihan extends StatelessWidget {
  late final String noTagihan;
  late final String token;

  DetailTagihan({required this.token, required this.noTagihan});

  late TagihanDTO newTagihan = new TagihanDTO("", "", "", "", 0, "");

  // Async function: Get Detail Tagihan
  Future getDetailTagihan(String noTagihan) async {
    var auth = await http
        .get(Uri.parse('http://localhost:8080/api/v1/info'), headers: {
      "Access-Control-Allow-Origin": "*",
      "Access-Control-Allow-Method": "POST, GET, PUT, DELETE",
      "Authorization": "Bearer $token"
    });

    var jsonAuth = jsonDecode(auth.body);
    String pasienRole = jsonAuth["role"];

    if (pasienRole == "PASIEN") {
      var response = await http.get(
          Uri.parse('http://localhost:8080/api/v1/tagihan/detail/$noTagihan'),
          headers: {
            "Access-Control-Allow-Origin": "*",
            "Access-Control-Allow-Method": "POST, GET, PUT, DELETE"
          });

      var jsonData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        newTagihan = TagihanDTO(
            jsonData["nomorTagihan"],
            jsonData["tanggalTerbuat"],
            jsonData["status"],
            jsonData["idPasien"],
            jsonData["jumlahTagihan"],
            jsonData["tanggalBayar"]);
        return newTagihan;
      } else {
        return false;
      }
    } else {
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
        future: getDetailTagihan(noTagihan),
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
                    'Detail Tagihan',
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
                    'Mengambil detail tagihan yang Anda pilih',
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
                        'Detail Tagihan Anda',
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
                                  'Kode Tagihan: ${newTagihan.nomorTagihan}',
                                  style: const TextStyle(fontSize: 16),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                Text(
                                  'Tanggal Terbuat: ${newTagihan.tanggalTerbuat}',
                                  style: const TextStyle(fontSize: 16),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                Text(
                                  'Tanggal Terbayar: ${newTagihan.tanggalBayar}',
                                  style: const TextStyle(fontSize: 16),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                Text(
                                  'Status Pembayaran: ${newTagihan.status}',
                                  style: const TextStyle(fontSize: 16),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                Text(
                                  'Tarif Tagihan: ${newTagihan.jumlahTagihan}',
                                  style: const TextStyle(fontSize: 16),
                                ),
                                const SizedBox(
                                  height: 8,
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
                                      return DetailTagihan(
                                          token: token,
                                          noTagihan: newTagihan.nomorTagihan);
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
                            child: ButtonBayarTagihan(
                                noTagihan: newTagihan.nomorTagihan,
                                status: newTagihan.status,
                                newTagihan: newTagihan,
                                token: token),
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

class ButtonBayarTagihan extends StatelessWidget {
  late final String noTagihan;
  late final String status;
  late final int jumlahTagihan;
  late final TagihanDTO newTagihan;
  late final String token;

  ButtonBayarTagihan(
      {required this.noTagihan,
      required this.status,
      required this.newTagihan,
      required this.token});

  Widget build(BuildContext context) {
    if (status == "LUNAS") {
      return Container(
          padding: const EdgeInsets.only(top: 12),
          child: ElevatedButton(
            onPressed: () {},
            child: Text('Tagihan Telah Lunas'),
          ));
    } else {
      return Container(
          padding: const EdgeInsets.only(top: 12),
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return KonfirmasiPembayaran(
                    token: token, newTagihan: newTagihan);
              }));
            },
            child: const Text('Bayar Tagihan'),
          ));
    }
  }
}
