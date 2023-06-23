import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:rumahsehat_flutter/DTO/CreateAppointmentDTO.dart';
import 'package:rumahsehat_flutter/DTO/GetDokterDTO.dart';

class FormCreateAppointment extends StatefulWidget {
  late final String token;
  FormCreateAppointment({required this.token});

  _FormCreateAppointment createState() => _FormCreateAppointment(token: token);
}

class _FormCreateAppointment extends State<FormCreateAppointment> {
  late final String token;
  _FormCreateAppointment({required this.token});

  final _formKey = GlobalKey<FormState>();
  final dateTimeController = TextEditingController();
  List<GetDokterDTO> listDokter = [];
  bool runGetDokter = false;

  // Form values
  DateTime? chosenDateTime;
  String? chosenDoctorId;

  // Function to get list of Dokter
  Future getDokter() async {
    print("====== GET DOKTER ======"); // TODO: debug
    // get auth
    var auth = await http.get(
        Uri.parse('http://10.0.2.2:8080/api/v1/info'),
        headers: {
          "Access-Control-Allow-Origin": "*",
          "Access-Control-Allow-Method": "POST, GET, PUT, DELETE",
          "Authorization": "Bearer $token"
        }
    );
    var jsonAuth = jsonDecode(auth.body);
    String pasienId = jsonAuth["id"];
    String pasienRole = jsonAuth["role"];
    print("token: $pasienId"); // TODO: debug

    if (pasienRole == "PASIEN") {
      // get response
      var response = await http.get(
          Uri.parse('http://10.0.2.2:8080/api/v1/dokter'),
          headers: {
            "Access-Control-Allow-Origin": "*",
            "Access-Control-Allow-Method": "POST, GET, PUT, DELETE"
          }
      );
      var jsonData = jsonDecode(response.body);
      print("response:\n$jsonData"); // TODO: debug

      listDokter = [];
      for (var d in jsonData) {
        GetDokterDTO dokter = GetDokterDTO(d["id"], d["nama"], d["tarif"]);
        listDokter.add(dokter);
      }

      if (runGetDokter == false) {
        chosenDoctorId = listDokter[0].dokterId;
      }
      runGetDokter = true;
      return listDokter;
    }
  }

  // Function to post Appointment as Json
  Future postAppointment() async {
    print("====== POST APT ======"); // TODO: debug
    // get auth
    var auth = await http.get(
        Uri.parse('http://10.0.2.2:8080/api/v1/info'),
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
      // post response
      CreateAppointmentDTO appointment = CreateAppointmentDTO(chosenDateTime!, chosenDoctorId!, pasienId);
      var aptJson = json.encode(appointment.toJson());
      var response = await http.post(
          Uri.parse('http://10.0.2.2:8080/api/v1/appointment/add'),
          headers: {
            "Accept": "application/json",
            "content-type": "application/json",
            "Access-Control-Allow-Origin": "*",
            "Access-Control-Allow-Method": "POST, GET, PUT, DELETE"
          },
          body: aptJson
      );
      print("apt:\n$aptJson"); // TODO: debug
      if (response.statusCode == 200) {
        return showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Appointment Created!'),
                content: const Text('Appointment Anda sudah kami catat.'),
                actions: <Widget>[
                  TextButton(
                    child: const Text('Oke'),
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                  ),
                ],
              );
            }
        );
      } else {
        return showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Create Appointment Failed!'),
                content: const Text(
                    'Dokter yang Anda pilih tidak tersedia di waktu ini.'),
                actions: <Widget>[
                  TextButton(
                    child: const Text('Okede bang'),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              );
            }
        );
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
        future: getDokter(),
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return SafeArea(
                child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 36),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: const <Widget>[
                  Text(
                    'Membuat Appointment',
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
                    'Mencari dokter untuk Anda.',
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
                      'Membuat Appointment',
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
                      'Maaf, dokter tidak tersedia.',
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
                        'Membuat Appointment',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Pilih waktu dan dokter untuk sesi appointment Anda.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: dateTimeController,
                        decoration: const InputDecoration(
                          hintText: 'Pilih tanggal & jam',
                          labelText: 'Waktu Appointment',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Pilih waktu appointment!';
                          }
                          return null;
                        },
                        onTap: () async {
                          FocusScope.of(context).requestFocus(FocusNode());
                          await DatePicker.showDateTimePicker(
                            context,
                            showTitleActions: true,
                            minTime: DateTime.now(),
                            currentTime: DateTime.now(),
                            locale: LocaleType.en,
                            onConfirm: (date) {
                              dateTimeController.text =
                                  DateFormat('dd-MM-yyyy hh:mm').format(date);
                              chosenDateTime = date;
                            },
                          );
                        },
                      ),
                      const SizedBox(height: 12),
                      DropdownButton<String>(
                        menuMaxHeight: 300,
                        isExpanded: true,
                        icon: const Icon(Icons.keyboard_arrow_down),
                        items:
                            snapshot.data.map<DropdownMenuItem<String>>((item) {
                          return DropdownMenuItem<String>(
                            value: item.dokterId,
                            child: Text('${item.nama} - ${item.tarif}'),
                          );
                        }).toList(),
                        value: chosenDoctorId,
                        onChanged: (String? newValue) {
                          setState(() {
                            chosenDoctorId = newValue!;
                          });
                        },
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
                            )
                          ),
                          const SizedBox(
                            width: 12,
                          ),
                          Container(
                            padding: const EdgeInsets.only(top: 12),
                            child: ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  postAppointment();
                                }
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
          }
        },
      ),
    );
  }
}
