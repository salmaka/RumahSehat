import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:rumahsehat_flutter/DTO/GetDetailAppointmentDTO.dart';

import 'package:http/http.dart' as http;
import 'package:rumahsehat_flutter/DTO/TagihanDTO.dart';

class Pembayaran extends StatelessWidget {
  late final String noTagihan;
  late final String token;
  late final TagihanDTO updatedTagihan;

  Pembayaran({required this.token, required this.noTagihan});

  Future tagihanAfterPembayaran(String noTagihan) async {
    // get auth
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
          Uri.parse(
              'http://localhost:8080/api/v1/tagihan/pembayaran/$noTagihan'),
          headers: {
            "Access-Control-Allow-Origin": "*",
            "Access-Control-Allow-Method": "POST, GET, PUT, DELETE"
          });
      var jsonData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        updatedTagihan = TagihanDTO(
            jsonData["nomorTagihan"],
            jsonData["tanggalTerbuat"],
            jsonData["status"],
            jsonData["idPasien"],
            jsonData["jumlahTagihan"],
            jsonData["tanggalBayar"]);
        return updatedTagihan;
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
            future: tagihanAfterPembayaran(noTagihan),
            builder: (context, snapshot) {
              if (snapshot.data == false) {
                return SafeArea(
                    child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 36),
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
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 36),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: const <Widget>[
                      Text(
                        'Memproses Pembayaran Tagihan Anda',
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
                        'Mohon Menunggu',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ));
              } else {
                if (updatedTagihan.status == "LUNAS") {
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
                                      'Tagihan Anda Lunas',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const Text(
                                      'Saldo Anda telat terpotong sesuai dengan jumlah tagihan.',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 24,
                                    ),
                                  ]))));
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
                                      'Maaf Pembayaran Tidak Dapat Dilakukan',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const Text(
                                      'Saldo Anda tidak mencukupi. Untuk melanjutkan pembayaran silakan top-up saldo.',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 24,
                                    ),
                                  ]))));
                }
              }
            }));
  }
}
