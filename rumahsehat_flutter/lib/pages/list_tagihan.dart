import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rumahsehat_flutter/pages/detail_tagihan.dart';
import 'package:rumahsehat_flutter/pages/list_tagihan.dart';
import 'package:rumahsehat_flutter/pages/viewall_appointment.dart';

import '../DTO/TagihanDTO.dart';

class ViewAllTagihan extends StatelessWidget {
  late final String token;
  ViewAllTagihan({required this.token});

  List<TagihanDTO> listTagihan = [];

  // Function to get list of Appointment
  Future getTagihan() async {
    var auth = await http
        .get(Uri.parse('http://localhost:8080/api/v1/info'), headers: {
      "Access-Control-Allow-Origin": "*",
      "Access-Control-Allow-Method": "POST, GET, PUT, DELETE",
      "Authorization": "Bearer $token"
    });
    var jsonAuth = jsonDecode(auth.body);
    String pasienId = jsonAuth["id"];
    String pasienRole = jsonAuth["role"];

    if (pasienRole == "PASIEN") {
      var response = await http.get(
          Uri.parse('http://localhost:8080/api/v1/tagihan/$pasienId'),
          headers: {
            "Access-Control-Allow-Origin": "*",
            "Access-Control-Allow-Method": "POST, GET, PUT, DELETE"
          });
      var jsonData = jsonDecode(response.body);

      listTagihan = [];

      if (response.statusCode == 200) {
        for (var a in jsonData) {
          TagihanDTO bill = TagihanDTO(
              a["nomorTagihan"],
              a["tanggalTerbuat"],
              a["status"],
              a["idPasien"],
              a["jumlahTagihan"],
              a["tanggalBayar"]);
          listTagihan.add(bill);
        }
        return listTagihan;
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
        future: getTagihan(), // TODO: pasienId masih hard code
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
                    'Daftar Tagihan Anda',
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
                    'Mencari Tagihan Anda.',
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
                      'Daftar Tagihan Anda',
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
                      'Anda belum memiliki tagihan.',
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
                      'Daftar Tagihan Anda',
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
                            final TagihanDTO tagihan = snapshot.data[index];
                            return InkWell(
                              onTap: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return DetailTagihan(
                                      token: token,
                                      noTagihan: tagihan.nomorTagihan);
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
                                            'Kode Tagihan: ${tagihan.nomorTagihan}',
                                            style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 12,
                                          ),
                                          Text(
                                            'Tanggal Terbuat: ${tagihan.tanggalTerbuat}',
                                            style:
                                                const TextStyle(fontSize: 16),
                                          ),
                                          const SizedBox(
                                            height: 4,
                                          ),
                                          Text(
                                            'Tanggal Terbayar: ${tagihan.tanggalBayar}',
                                            style:
                                                const TextStyle(fontSize: 16),
                                          ),
                                          const SizedBox(
                                            height: 4,
                                          ),
                                          Text(
                                            'Status Pembayaran: ${tagihan.status}',
                                            style:
                                                const TextStyle(fontSize: 16),
                                          ),
                                          const SizedBox(
                                            height: 4,
                                          ),
                                          Text(
                                            'Tarif Tagihan: ${tagihan.jumlahTagihan}',
                                            style:
                                                const TextStyle(fontSize: 16),
                                          ),
                                          const SizedBox(
                                            height: 4,
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
                                            return DetailTagihan(
                                                token: token,
                                                noTagihan:
                                                    tagihan.nomorTagihan);
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
                                    return ViewAllTagihan(token: token);
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
